defmodule CloudsightElixir do
  @moduledoc """
  Core functions for interfacing with the API

  Additional References:
  https://cloudsight.readme.io/reference
  """

  alias CloudsightElixir.Images

  @doc """
  Send an image or url to the Cloudsight API for identification

  ## Examples

      client = CloudsightElixir.Client.new("sample_api_key")
      CloudsightElixir.send(%{locale: "en", remote_image_url: "https://dropbox.com/my_image.png"}, client)

  """
  @spec send(map, Client.t) :: {atom, [key: binary]}
  defdelegate send(options, client), to: Images

  @doc """
  Retrieve the result of a token

  ## Examples

      client = CloudsightElixir.Client.new("sample_api_key")
      CloudsightElixir.retrieve("my_token", client)
  """
  @spec retrieve(binary, Client.t) :: {atom, [key: binary]}
  defdelegate retrieve(token, client), to: Images

  @doc """
  Poll for a response until the timeout is reached - defaults to 20 seconds

  ## Examples

      client = CloudsightElixir.Client.new("sample_api_key")
      CloudsightElixir.wait_for("my_token", client, %{ttl: 10_000}) # wait 10 seconds
  """
  @spec retrieve(binary, Client.t) :: {atom, [key: binary] | atom}
  defdelegate wait_for(token, client), to: Images
  defdelegate wait_for(token, client, options), to: Images
end
