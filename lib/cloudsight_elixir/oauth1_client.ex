defmodule CloudsightElixir.OAuth1Client do
  defstruct credentials: nil, endpoint: "https://api.cloudsight.ai"

  @type endpoint :: binary
  @type credentials :: OAuther.Credentials.t()
  @type t :: %__MODULE__{
          credentials: credentials,
          endpoint: endpoint,
        }



  @doc ~S"""
  Creates a new client with your authentication information
  that will be passed to all future methods

  ## Examples

      iex> CloudsightElixir.OAuth1Client.new(%{consumer_key: "abcd123", consumer_secret: "asdfasdf"})
      %CloudsightElixir.OAuth1Client{credentials: %OAuther.Credentials{consumer_key: "abcd123", consumer_secret: "asdfasdf"}, endpoint: "https://api.cloudsight.ai"}
  """
  @spec new(map) :: t
  def new(%{consumer_key: consumer_key, consumer_secret: consumer_secret, endpoint: endpoint}) do
    %__MODULE__{
      credentials: OAuther.credentials(consumer_key: consumer_key, consumer_secret: consumer_secret),
      endpoint: endpoint
    }
  end

  def new(%{consumer_key: consumer_key, consumer_secret: consumer_secret}) do
    %__MODULE__{
      credentials: OAuther.credentials(consumer_key: consumer_key, consumer_secret: consumer_secret),
    }
  end
end
