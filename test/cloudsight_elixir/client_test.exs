defmodule CloudsightElixir.ClientTest do
  use ExUnit.Case, async: true
  doctest CloudsightElixir.Client
  import CloudsightElixir.Client

  test "initiating a client" do
    client = new("test_key")
    assert client.endpoint == "https://api.cloudsight.ai"
    assert client.api_key  == "test_key"
  end

  test "with a custom endpoint" do
    client = new("test_key", "test_endpoint")
    assert client.endpoint == "test_endpoint"
    assert client.api_key  == "test_key"
  end
end
