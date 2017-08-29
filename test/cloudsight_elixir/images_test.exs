defmodule CloudsightElixir.ImagesTest do
  use ExUnit.Case, async: false
  doctest CloudsightElixir.Images
  alias CloudsightElixir.Images
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    HTTPoison.start
  end

  setup do
    api_key = Application.get_env(:cloudsight_elixir, :api_key)
    client = CloudsightElixir.Client.new(api_key, "api.lvh.me:3000")
    {:ok, %{client: client}}
  end

  test "send", %{client: client} do
    use_cassette "image_request_send" do
      map = %{remote_image_url: "http://englishbookgeorgia.com/blogebg/wp-content/uploads/2015/08/husky.jpg", locale: "en"}
      {:ok, body} = Images.send(map, client)
      assert body[:status] == "not completed"
      assert body[:token]  == "tTzMU7bDpsT4gsDyJLilDA"
    end
  end

  test "send file", %{client: client} do
    use_cassette "image_request_send" do
      map = %{image: "test/support/logo.png", locale: "en"}
      {:ok, body} = Images.send(map, client)
      assert body[:status] == "not completed"
      assert body[:token]  == "tTzMU7bDpsT4gsDyJLilDA"
    end
  end

  test "send with error", %{client: client} do
    use_cassette "image_request_send_with_error" do
      map = %{remote_image_url: "http://englishbookgeorgia.com/blogebg/wp-content/uploads/2015/08/husky.jpg"}
      {:error, error} = Images.send(map, client)
      assert error[:error] == %{"locale" => ["can't be blank"]}
    end
  end

  test "retrieve timeout", %{client: client} do
    use_cassette "image_response_get_timeout" do
      token = "tTzMU7bDpsT4gsDyJLilDA"
      {:ok, body} = Images.retrieve(token, client)
      assert body[:status] == "timeout"
    end
  end

  test "retrieve completed", %{client: client} do
    use_cassette "image_response_get_completed" do
      token = "dogs_image_request"
      {:ok, body} = Images.retrieve(token, client)
      assert body[:status] == "completed"
      assert body[:name] == "Husky"
    end
  end

  test "wait for with timeout", %{client: client} do
    use_cassette "image_response_get_timeout" do
      assert Images.wait_for("tTzMU7bDpsT4gsDyJLilDA", client, 5) == {:error, :timeout}
    end
  end

  test "wait for with completed response", %{client: client} do
    use_cassette "image_response_get_completed" do
      token = "dogs_image_request"
      {:ok, body} = Images.wait_for(token, client)
      assert body[:status] == "completed"
      assert body[:name] == "Husky"
    end
  end

  test "encode body" do
    assert Images.encode_body(%{locale: "en"}) == Poison.encode!(%{locale: "en"})
  end

  test "encode body with file" do
    file = "test/support/logo.png"
    assert Images.encode_body(%{image: file, locale: "en"}) == 
      {:multipart, [
        {:file, file, {"form-data", [name: "image", filename: Path.basename(file)]}, []},
        {"locale", "en"}
        ]
      }
  end

  test "repost_path" do
    assert Images.repost_path("abc123") == "/v1/images/abc123/repost"
  end

  test "repost", %{client: client} do
    use_cassette "image_request_repost" do
      token = "tTzMU7bDpsT4gsDyJLilDA"
      {:ok, body} = Images.repost(token, client)
      assert body == ""
    end
  end
end
