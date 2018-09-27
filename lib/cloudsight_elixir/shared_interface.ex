defmodule CloudsightElixir.SharedInterface do
  alias CloudsightElixir.Api

  @moduledoc """
  Shared interface methods that both the Image and Video APIs use
  """

  @spec send(binary, map, Client.t) :: {atom, map}
  def send(path, options, client) do
    Api.post(path, encode_body(options), client)
  end

  @spec retrieve(binary, binary, Client.t) :: {atom, map}
  def retrieve(path, token, client) do
    path
    |> get_path(token)
    |> Api.get(client)
  end

  @spec wait_for(binary, binary, Client.t, number) :: {atom, atom | [key: binary]}
  def wait_for(_path, _token, _client, time_remaining) when time_remaining <= 0, do: {:error, :timeout}
  def wait_for(path, token, client, time_remaining) do
    time       = :os.system_time(:millisecond)
    response   = retrieve(path, token, client)
    time_spent = (:os.system_time(:millisecond) - time)

    case handle_response(response) do
      {:ok, response} -> {:ok, response}
      {:no, _}    -> wait_for(path, token, client, time_remaining - time_spent)
    end
  end

  @spec handle_response({atom, map}) :: {atom, map | nil}
  defp handle_response({:ok, %{body: body} = response}) do
    case body["status"] do
      "completed"     -> {:ok, response}
      _               -> {:no, nil}
    end
  end

  @spec encode_body(map) :: binary
  def encode_body(%{image: _image} = map), do: encode_multipart_body(map, :image)
  def encode_body(%{video: _video} = map), do: encode_multipart_body(map, :video)
  def encode_body(options) do
    options
    |> Poison.encode!
  end

  @spec encode_multipart_body(map, atom) :: {atom, list}
  defp encode_multipart_body(map, file_type) do
    {path, map} = Map.pop(map, file_type)

    additional_params = Enum.reduce(map, [], fn {k, v}, acc ->
      acc ++ [{to_string(k), v}]
    end)

    {:multipart,
      [
        {:file, path, {"form-data", [name: to_string(file_type), filename: Path.basename(path)]}, []}
      ] ++ additional_params
    }
  end

  @spec get_path(binary, binary) :: binary
  defp get_path(path, token), do: path <> "/" <> token
end
