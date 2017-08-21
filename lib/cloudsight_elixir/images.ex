defmodule CloudsightElixir.Images do
  alias CloudsightElixir.Api

  @post_path "/v1/images"
  @get_path  "/v1/images"

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

  @spec get_path(binary) :: binary
  defp get_path(token), do: @get_path <> "/" <> token

  @spec encode_body(map) :: {atom, list}
  def encode_body(%{image: path} = map) do
    additional_params =
      Map.delete(map, :image)
      |> Enum.reduce([], fn {k, v}, acc -> acc ++ [{to_string(k), v}] end)

    {:multipart,
      [
        {:file, path, {"form-data", [name: "image", filename: Path.basename(path)]}, []}
      ] ++ additional_params
    }
  end

  @spec encode_body(map) :: binary
  def encode_body(options) do
    options
    |> Poison.encode!
  end
end
