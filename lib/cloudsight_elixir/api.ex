defmodule CloudsightElixir.Api do
  @moduledoc """
  Core functions for interfacing with the API
  """

  use HTTPoison.Base

  @spec get(binary, Client.t) :: {atom, map}
  def get(path, client) do
    _request(:get, process_url(path, client), client)
  end

  @spec post(binary, binary, Client.t) :: {atom, map}
  def post(path, body, client) do
    _request(:post, process_url(path, client), client, body)
  end

  @spec _request(:get | :post, binary, Client.t, binary) :: {atom, map}
  def _request(method, url, client, body \\ "") do
    headers = header_for(body) ++ [{"Authorization", authorization_header(client)}]

    method
    |> raw_request(url, body, headers)
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

  @spec authorization_header(Client.t) :: binary
  def authorization_header(client) do
    "CloudSight #{client.api_key}"
  end

  def process_response_body(""),  do: ""
  def process_response_body(body) do
    body
    |> Poison.decode!
  end

  def header_for({:multipart, _}), do: [{"Content-type", "application/x-www-form-urlencoded"}]
  def header_for(_), do: [{"Content-type", "application/json"}]
end
