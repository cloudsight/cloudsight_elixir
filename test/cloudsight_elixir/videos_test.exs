defmodule CloudsightElixir.VideosTest do
  use ExUnit.Case, async: false
  doctest CloudsightElixir.Videos
  alias CloudsightElixir.Videos
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    HTTPoison.start
  end

  setup do
    ExVCR.Config.cassette_library_dir("test/fixture/vcr_cassettes")
    ExVCR.Config.filter_sensitive_data("CloudSight [^\"]+", "CloudSight yourtokencomeshere")

    api_key = Application.get_env(:cloudsight_elixir, :api_key)
    client = CloudsightElixir.Client.new(api_key, "api.lvh.me:3000")

    {:ok, %{client: client}}
  end

  test "send", %{client: client} do
    use_cassette "video_request_send" do
      map = %{remote_video_url: "http://techslides.com/demos/sample-videos/small.mp4", locale: "en"}
      {:ok, %{body: body}} = Videos.send(map, client)
      assert body["status"] == "not completed"
      assert body["token"]  == "TnXkoZOjJCch7BXoJTL0QA"
    end
  end

  test "send file", %{client: client} do
    use_cassette "video_request_send" do
      map = %{video: "test/support/test_video.png", locale: "en"}
      {:ok, %{body: body}} = Videos.send(map, client)
      assert body["status"] == "not completed"
      assert body["token"]  == "TnXkoZOjJCch7BXoJTL0QA"
    end
  end

  test "send with error", %{client: client} do
    use_cassette "video_request_send_with_error" do
      map = %{remote_video_url: "http://techslides.com/demos/sample-videos/small.mp4"}
      {:ok, %{status_code: status_code, body: body}} = Videos.send(map, client)
      assert body["error"] == %{"locale" => ["can't be blank"]}
      assert status_code == 422
    end
  end

  test "retrieve completed", %{client: client} do
    use_cassette "video_response_get_completed" do
      token = "slam_video"
      {:ok, %{body: body}} = Videos.retrieve(token, client)
      assert body["status"] == "completed"
      assert Enum.map(body["children"], fn child_video ->
        child_video["name"]
      end) == ["full video", "full video"]
    end
  end

  test "wait for with timeout", %{client: client} do
    use_cassette "video_response_get_timeout" do
      assert Videos.wait_for("tTzMU7bDpsT4gsDyJLilDA", client, %{ttl: 5}) == {:error, :timeout}
    end
  end

  test "wait for with completed response", %{client: client} do
    use_cassette "video_response_get_completed" do
      token = "slam_video"
      {:ok, %{body: body}} = Videos.wait_for(token, client)
      assert body["status"] == "completed"
      assert Enum.map(body["children"], fn child_video ->
        child_video["name"]
      end) == ["full video", "full video"]
    end
  end
end
