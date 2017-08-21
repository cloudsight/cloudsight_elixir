# CloudsightElixir

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

First create a client with your API Key received from [Cloudsight](https://cloudsight.ai).

```elixir

# Create client with your api key
iex(1)> client = CloudsightElixir.Client.new("your_api_key")
%CloudsightElixir.Client{api_key: "your_api_key",
 endpoint: "https://api.cloudsight.ai"}

# Send an image or remote image url to Cloudsight for identification
iex(2)> {:ok, body} = CloudsightElixir.send(%{remote_image_url: "http://englishbookgeorgia.com/blogebg/wp-content/uploads/2015/08/husky.jpg", locale: "en"}, client)
{:ok,
 [status: "not completed", token: "dXlycVGpIED9YULEKyXd7g",
   url: "http://tagpics_app_1:3000/uploads/image_request/image/1066/1066384/1066384278/husky.jpg"]}

# Note the token so you can retrieve it
iex(3)> token = body[:token]
"dXlycVGpIED9YULEKyXd7g"


# Poll for the response - the image is usually identified in 5-10 seconds
iex(4)> {:ok, body} = CloudsightElixir.retrieve(token, client)
{:ok,
[name: "Grey Husky Dog", status: "completed", terms: ["Husky", "Dog"],
token: "dXlycVGpIED9YULEKyXd7g", ttl: -240.0,
url: "http://tagpics_app_1:3000/uploads/image_request/image/462/462197/462197426/training_image_placeholder.gif"]}

```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/cloudsight_elixir](https://hexdocs.pm/cloudsight_elixir).
