defmodule CloudsightElixir do
  @moduledoc """
  Core functions for interfacing with the API

  Additional References:
  https://cloudsight.readme.io/reference
  """

  alias CloudsightElixir.{Images, Videos}

  @deprecated "Use send_image or send_video instead"
  @spec send(map, Client.t) :: {atom, [key: binary]}
  defdelegate send(options, client), to: Images

  @deprecated "Use retrieve_image or retrieve_image instead"
  @spec retrieve(binary, Client.t) :: {atom, [key: binary]}
  defdelegate retrieve(token, client), to: Images

  @deprecated "Use wait_for_image or wait_for_video instead"
  @spec wait_for(binary, Client.t) :: {atom, [key: binary] | atom}
  defdelegate wait_for(token, client), to: Images
  defdelegate wait_for(token, client, options), to: Images

  @doc """
  Repost an image if it expired in the queue without returning a response

  ## Examples

      client = CloudsightElixir.Client.new("sample_api_key")
      CloudsightElixir.repost("my_token", client)
  """
  @spec repost(binary, Client.t) :: {atom, binary}
  defdelegate repost(token, client), to: Images

  @doc """
  Send an image file or url to the Cloudsight API for identification

  ## Examples

    client = CloudsightElixir.Client.new("sample_api_key")
    CloudsightElixir.send_image(%{locale: "en", remote_image_url: "https://dropbox.com/my_video.mp4"}, client)

    client = CloudsightElixir.Client.new("sample_api_key")
    CloudsightElixir.send_image(%{locale: "en", image: "./my_image.jpg"}, client)
  """
  @spec send_image(map, Client.t) :: {atom, [key: binary]}
  def send_image(options, client), do: Images.send(options, client)

  @doc """
  Send a video file or url to the Cloudsight API for identification

  ## Examples

    client = CloudsightElixir.Client.new("sample_api_key")
    CloudsightElixir.send_video(%{locale: "en", remote_video_url: "https://dropbox.com/my_video.mp4"}, client)

    client = CloudsightElixir.Client.new("sample_api_key")
    CloudsightElixir.send_video(%{locale: "en", video: "./my_video.mp4"}, client)
  """
  @spec send_video(map, Client.t) :: {atom, [key: binary]}
  def send_video(options, client), do: Videos.send(options, client)

  @doc """
  Retrieve the result of an image token

  ## Examples

      client = CloudsightElixir.Client.new("sample_api_key")
      CloudsightElixir.retrieve_image("my_token", client)
  """
  @spec retrieve_image(binary, Client.t) :: {atom, [key: binary]}
  def retrieve_image(token, client), do: Images.retrieve(token, client)

  @doc """
  Retrieve the result of a video token

  ## Examples

      client = CloudsightElixir.Client.new("sample_api_key")
      CloudsightElixir.retrieve_video("my_token", client)
  """
  @spec retrieve_video(binary, Client.t) :: {atom, [key: binary]}
  def retrieve_video(token, client), do: Videos.retrieve(token, client)

  @doc """
  Poll for an image response until the timeout is reached - defaults to 20 seconds

  ## Examples

      client = CloudsightElixir.Client.new("sample_api_key")
      CloudsightElixir.wait_for_image("my_token", client, %{ttl: 10_000}) # wait 10 seconds
  """
  @spec wait_for_image(binary, Client.t) :: {atom, [key: binary] | atom}
  def wait_for_image(token, client), do: Images.wait_for(token, client)
  def wait_for_image(token, client, options), do: Images.wait_for(token, client, options)

  @doc """
  Poll for an video response until the timeout is reached - defaults to 20 seconds

  ## Examples

      client = CloudsightElixir.Client.new("sample_api_key")
      CloudsightElixir.wait_for_video("my_token", client, %{ttl: 10_000}) # wait 10 seconds
  """
  @spec wait_for_video(binary, Client.t) :: {atom, [key: binary] | atom}
  def wait_for_video(token, client), do: Videos.wait_for(token, client)
  def wait_for_video(token, client, options), do: Videos.wait_for(token, client, options)
end
