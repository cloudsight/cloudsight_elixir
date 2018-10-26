defmodule CloudsightElixir.OAuth1ClientTest do
  use ExUnit.Case, async: true
  doctest CloudsightElixir.OAuth1Client
  import CloudsightElixir.OAuth1Client

  test "initiating a client" do
    client = new(%{consumer_key: "abcd", consumer_secret: "abcd"})
    assert client.endpoint == "https://api.cloudsight.ai"
    assert %OAuther.Credentials{consumer_key: "abcd", consumer_secret: "abcd"} = client.credentials
  end

  test "with a custom endpoint" do
    client = new(%{consumer_key: "abcd", consumer_secret: "abcd", endpoint: "test_endpoint"})
    assert client.endpoint == "test_endpoint"
    assert %OAuther.Credentials{consumer_key: "abcd", consumer_secret: "abcd"} = client.credentials
  end
end
