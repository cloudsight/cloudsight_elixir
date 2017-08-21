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

      client = CloudsightElixir.Client.new("sample_token")
      CloudsightElixir.send(%{locale: "en", remote_image_url: "https://dropbox.com/my_image.png"}, client)

  """
  @spec send(map, Client.t) :: {atom, map}
  defdelegate send(options, client), to: Images

  @doc """
  Retrieve the result of a token
  """
  @spec retrieve(binary, Client.t) :: {atom, map}
  defdelegate retrieve(token, client), to: Images
end
