[![Build Status](https://travis-ci.org/cloudsight/cloudsight_elixir.svg?branch=master)](https://travis-ci.org/cloudsight/cloudsight_elixir)

# Cloudsight Elixir

Simple Elixir wrapper for the [Cloudsight Api](https://cloudsight.readme.io/reference).


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `cloudsight_elixir` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:cloudsight_elixir, "~> 0.2.0"}
  ]
end
```

## Examples

First create a client with your API Key from [Cloudsight](https://cloudsight.ai).

```elixir
# Create client with your api key
iex()> client = CloudsightElixir.Client.new("your_api_key")
%CloudsightElixir.Client{api_key: "your_api_key", endpoint: "https://api.cloudsight.ai"}

# Send an image to Cloudsight for identification
iex()> {:ok, resp} = CloudsightElixir.send(%{image: "./path/to/my/file.png", locale: "en"}, client)
{:ok,
 %{
   body: %{
     "status" => "not completed",
	 "token": "dx23sdGD9YULEKy53BG",
     "url": "https://api.cloudsight.ai/uploads/image_request/image/10378/file.png"
   },
   status_code: 200
 }
}

# Or send an image that is hosted at a remote url
iex()> {:ok, resp} = CloudsightElixir.send(%{remote_image_url: "http://sample.com/husky.jpg", locale: "en"}, client)
{:ok,
 %{
   body: %{
     "status" => "not completed",
	 "token": "dx23sdGD9YULEKy53BG",
     "url": "https://api.cloudsight.ai/uploads/image_request/image/10378/file.png"
   },
   status_code: 200
 }
}

# Note the token so you can retrieve it
iex()> token = resp.body["token"]
"dx23sdGD9YULEKy53BG"

# Check on the response - the image is usually identified in 5-10 seconds
iex()> {:ok, resp} = CloudsightElixir.retrieve(token, client)
{:ok,
 %{
   body: %{
     "name" => "Adult Siberian Husky",
     "status" => "completed",
	 "token": "dx23sdGD9YULEKy53BG",
     "url": "https://api.cloudsight.ai/uploads/image_request/image/10378/file.png"
   },
   status_code: 200
 }
}
 
# Use CloudsightElixir.wait_for to poll for you until the response is ready - defaults to timing out after 20 seconds
iex()> {:ok, body} = CloudsightElixir.wait_for(token, client)
{:ok,
 %{
   body: %{
     "name" => "Adult Siberian Husky",
     "status" => "completed",
	 "token": "dx23sdGD9YULEKy53BG",
     "url": "https://api.cloudsight.ai/uploads/image_request/image/10378/file.png"
   },
   status_code: 200
 }
}

# Requests with errors will still return with :ok but give a non 200 status_code and have an error in the body
{:ok, resp} = CloudsightElixir.send(%{remote_image_url: "http://sample.com/husky.jpg"}, client)
{:ok, %{body: %{"error" => %{"locale" => ["can't be blank"]}}, status_code: 422}}

# A timeout will return a tuple starting with :error
iex()> {:ok, body} = CloudsightElixir.wait_for(token, client)
{:error, :timeout}
```
