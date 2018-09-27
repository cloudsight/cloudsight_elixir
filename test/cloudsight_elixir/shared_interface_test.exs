defmodule CloudsightElixir.SharedInterfaceTest do
  use ExUnit.Case, async: false
  alias CloudsightElixir.SharedInterface

  test "encode body" do
    assert SharedInterface.encode_body(%{locale: "en"}) == Poison.encode!(%{locale: "en"})
  end

  test "encode body with image" do
    file = "test/support/logo.png"
    assert SharedInterface.encode_body(%{image: file, locale: "en"}) == 
      {:multipart, [
        {:file, file, {"form-data", [name: "image", filename: Path.basename(file)]}, []},
        {"locale", "en"}
        ]
      }
  end

  test "encode body with video" do
    file = "test/support/logo.png"
    assert SharedInterface.encode_body(%{video: file, locale: "en"}) == 
      {:multipart, [
        {:file, file, {"form-data", [name: "video", filename: Path.basename(file)]}, []},
        {"locale", "en"}
        ]
      }
  end
end
