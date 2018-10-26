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

  test "headers for json with oauth" do
    client = CloudsightElixir.OAuth1Client.new(%{consumer_key: "abcd", consumer_secret: "abcd"})
    body = %{
      locale: "en",
      remote_image_url: "http://example.com/pic.jpg"
    }

    [content_type, auth] = headers_for(:post, "http://cloudsight.ai/v1/images", client, body)

    assert content_type == {"content-type", "application/json"}
    assert {"Authorization", "OAuth oauth_signature" <> _rest} = auth
  end

  test "headers for multipart with oauth" do
    client = CloudsightElixir.OAuth1Client.new(%{consumer_key: "abcd", consumer_secret: "abcd"})
    body = %{
      locale: "en",
      image: "test/support/logo.png"
    }

    [content_type, auth] = headers_for(:post, "http://cloudsight.ai/v1/images", client, body)

    assert content_type == {"content-type", "application/x-www-form-urlencoded"}
    assert {"Authorization", "OAuth oauth_signature" <> _rest} = auth
  end

  test "headers for json with basic auth", %{client: client} do
    [content_type, auth] = headers_for(:post, "http://cloudsight.ai/v1/images", client, %{locale: "en"})

    assert content_type == {"content-type", "application/json"}
    assert auth == {"Authorization", "CloudSight test_api_key"}
  end

  test "headers for multipart with basic auth", %{client: client} do
    [content_type, auth] = headers_for(:post, "http://cloudsight.ai/v1/images", client, %{image: "an_image.jpg"})

    assert content_type == {"content-type", "application/x-www-form-urlencoded"}
    assert auth == {"Authorization", "CloudSight test_api_key"}
  end
end
