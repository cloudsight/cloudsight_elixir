# Cloudsight Elixir

Simple Elixir wrapper for the [Cloudsight Api](https://cloudsight.readme.io/reference).


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `cloudsight_elixir` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:cloudsight_elixir, "~> 0.1.0"}
  ]
end
```

## Examples

First create a client with your API Key from [Cloudsight](https://cloudsight.ai).

```elixir
# Create client with your api key
iex()> client = CloudsightElixir.Client.new("your_api_key")
%CloudsightElixir.Client{api_key: "your_api_key",
 endpoint: "https://api.cloudsight.ai"}

# Send an image to Cloudsight for identification
iex()> {:ok, body} = CloudsightElixir.send(%{image: "./path/to/my/file.png", locale: "en"}, client)
{:ok,
 [status: "not completed", token: "dasdGD9YULEKy53BG",
   url: "https://api.cloudsight.ai/uploads/image_request/image/10678/file.png"]}
 
# Or send an image that is hosted at a remote url
iex()> {:ok, body} = CloudsightElixir.send(%{remote_image_url: "http://sample.com/husky.jpg", locale: "en"}, client)
{:ok,
 [status: "not completed", token: "dXlycVGpIED9YULEKyXd7g",
   url: "https://api.cloudsight.ai/uploads/image_request/image/1066/husky.jpg"]}

# Note the token so you can retrieve it
iex()> token = body[:token]
"dXlycVGpIED9YULEKyXd7g"

# Check on the response - the image is usually identified in 5-10 seconds
iex()> {:ok, body} = CloudsightElixir.retrieve(token, client)
{:ok,
[name: "Grey Husky Dog", status: "completed", terms: ["Husky", "Dog"],
token: "dXlycVGpIED9YULEKyXd7g", ttl: -240.0,
url: "https://api.cloudsight.ai/uploads/image_request/image/462/462197/462197426/training_image_placeholder.gif"]}

# Use CloudsightElixir.wait_for to poll for you until the response is ready - defaults to timing out after 20 seconds
iex()> {:ok, body} = CloudsightElixir.wait_for(token, client)
{:ok,
[name: "Grey Husky Dog", status: "completed", terms: ["Husky", "Dog"],
token: "dXlycVGpIED9YULEKyXd7g", ttl: -240.0,
url: "https://api.cloudsight.ai/uploads/image_request/image/462/462197/462197426/training_image_placeholder.gif"]}

```