defmodule CloudsightElixir.Videos do
  alias CloudsightElixir.Api

  @post_path "/v1/videos"
  @get_path  "/v1/videos"

  @spec send(map, Client.t) :: {atom, map}
  def send(options, client) do
    @post_path
    |> Api.post(encode_body(options), client)
  end

  @spec retrieve(binary, Client.t) :: {atom, map}
  def retrieve(token, client) do
    token
    |> get_path
    |> Api.get(client)
  end

  @spec wait_for(binary, Client.t) :: {:ok, list}
  def wait_for(token, client), do: wait_for(token, client, 20_000)

  @spec wait_for(binary, Client.t, map) :: {:ok, list}
  def wait_for(token, client, %{ttl: ttl}), do: wait_for(token, client, ttl)

  @spec wait_for(binary, Client.t, number) :: {atom, atom | [key: binary]}
  def wait_for(_token, _client, time_remaining) when time_remaining <= 0, do: {:error, :timeout}
  def wait_for(token, client, time_remaining) do
    time       = :os.system_time(:millisecond)
    response   = retrieve(token, client)
    time_spent = (:os.system_time(:millisecond) - time)

    case handle_response(response) do
      {:ok, response} -> {:ok, response}
      {:no, _}    -> wait_for(token, client, time_remaining - time_spent)
    end
  end

  @spec handle_response({atom, map}) :: {atom, map | nil}
  defp handle_response({:ok, %{body: body} = response}) do
    case body["status"] do
      "completed"     -> {:ok, response}
      _               -> {:no, nil}
    end
  end

  @spec get_path(binary) :: binary
  defp get_path(token), do: @get_path <> "/" <> token

  @spec encode_body(map) :: {atom, list}
  def encode_body(%{video: path} = map) do
    additional_params =
      Map.delete(map, :video)
      |> Enum.reduce([], fn {k, v}, acc -> acc ++ [{to_string(k), v}] end)

    {:multipart,
      [
        {:file, path, {"form-data", [name: "video", filename: Path.basename(path)]}, []}
      ] ++ additional_params
    }
  end

  @spec encode_body(map) :: binary
  def encode_body(options) do
    options
    |> Poison.encode!
  end
end
