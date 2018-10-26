defmodule CloudsightElixir.SharedInterface do
  alias CloudsightElixir.Api

  @moduledoc """
  Shared interface methods that both the Image and Video APIs use
  """

  @spec send(binary, map, Client.t) :: {atom, map}
  def send(path, options, client) do
    Api.post(path, options, client)
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

  @spec get_path(binary, binary) :: binary
  defp get_path(path, token), do: path <> "/" <> token
end
