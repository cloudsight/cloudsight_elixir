defmodule CloudsightElixir.ApiTest do
  use ExUnit.Case, async: false

  doctest CloudsightElixir.Api
  import CloudsightElixir.Api

  setup do
    client = CloudsightElixir.Client.new("test_api_key", "api.lvh.me:3000")
    {:ok, %{client: client}}
  end

  test "process url", %{client: client} do
    assert process_url("/test_path", client) == "api.lvh.me:3000/test_path"
  end

  test "authorization header with api_key", %{client: client} do
    assert authorization_header(client) == "CloudSight test_api_key"
  end

end
