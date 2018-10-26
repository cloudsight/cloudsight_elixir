defmodule CloudsightElixir.Api do
  @moduledoc """
  Core functions for interfacing with the API
  """

  use HTTPoison.Base

  alias CloudsightElixir.{Client, OAuth1Client}

  @spec get(binary, Client.t) :: {atom, map}
  def get(path, client) do
    _request(:get, process_url(path, client), client)
  end

  @spec post(binary, map, Client.t) :: {atom, map}
  def post(path, params, client) do
    _request(:post, process_url(path, client), client, params)
  end

  @spec _request(:get | :post, binary, Client.t, map | {:multipart, map}) :: {atom, map}
  def _request(method, url, client, params \\ %{}) do
    headers = headers_for(method, url, client, params)

    method
    |> raw_request(url, encode_body(params), headers)
    |> handle_response
  end

  @spec handle_response(HTTPoison.Response.t) :: {atom, map}
  def handle_response(%HTTPoison.Response{status_code: status_code, body: body}) do
    {:ok, %{ status_code: status_code, body: body }}
  end

  @spec raw_request(:get | :post, binary, binary, list) :: HTTPoison.Response.t
  def raw_request(method, url, body \\ "", headers \\ []) do
    request!(method, url, body, headers, [timeout: 20_000])
  end

  @spec process_url(binary, Client.t) :: binary
  def process_url(path, client) do
    client.endpoint <> path
  end

  def process_response_body(""),  do: ""
  def process_response_body(body) do
    body
    |> Poison.decode!
  end

  def headers_for(method, url, %OAuth1Client{} = client, params) do
    [
      content_type_header(params),
      oauth_signature(client, method, params, url)
    ]
  end

  def headers_for(_method, _url, %Client{} = client, params) do
    [
      content_type_header(params),
      basic_auth_header(client)
    ]
  end

  defp content_type_header(%{image: _}), do: multipart_content_type_header()
  defp content_type_header(%{video: _}), do: multipart_content_type_header()
  defp content_type_header(_), do: json_content_type_header()

  defp oauth_signature(client, method, params, url) do
    OAuther.sign(
      Atom.to_string(method),
      url,
      convert_oauth_params_for_signature(params),
      client.credentials
    ) |> OAuther.header |> elem(0)
  end

  defp basic_auth_header(client) do
    {"Authorization", "CloudSight #{client.api_key}"}
  end

  defp json_content_type_header() do
    {"content-type", "application/json"}
  end

  defp multipart_content_type_header() do
    {"content-type", "application/x-www-form-urlencoded"}
  end

  defp convert_oauth_params_for_signature(params) do
    params
    |> convert_atom_map_to_string_map
    |> Enum.reject(fn {k, _v} -> k == "image"|| k == "video" end)
  end

  defp convert_atom_map_to_string_map(keyword_map) do
    for {key, val} <- keyword_map, into: %{}, do: {to_string(key), val}
  end

  @spec encode_body(map) :: binary | {:multipart, list}
  defp encode_body(%{image: _image} = map), do: encode_multipart_body(map, :image)
  defp encode_body(%{video: _video} = map), do: encode_multipart_body(map, :video)
  defp encode_body(options) do
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
end
