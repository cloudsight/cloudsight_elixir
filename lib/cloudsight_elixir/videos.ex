defmodule CloudsightElixir.Videos do
  alias CloudsightElixir.SharedInterface

  @post_path "/v1/videos"
  @get_path  "/v1/videos"

  @spec send(map, Client.t) :: {atom, map}
  def send(options, client) do
    SharedInterface.send(@post_path, options, client)
  end

  @spec retrieve(binary, Client.t) :: {atom, map}
  def retrieve(token, client) do
    SharedInterface.retrieve(@get_path, token, client)
  end

  @spec wait_for(binary, Client.t) :: {:ok, list}
  def wait_for(token, client) do
    SharedInterface.wait_for(@get_path, token, client, 20_000)
  end

  @spec wait_for(binary, Client.t, map) :: {:ok, list}
  def wait_for(token, client, %{ttl: ttl}) do
    SharedInterface.wait_for(@get_path, token, client, ttl)
  end
end
