defmodule CloudsightElixir.Client do
  defstruct api_key: nil, endpoint: "https://api.cloudsight.ai"

  @type api_key :: binary
  @type t :: %__MODULE__{api_key: api_key, endpoint: binary}

  @spec new(api_key) :: t
  @doc ~S"""
  Creates a new client with your authentication information
  that will be passed to all future methods

  ## Examples

      iex> CloudsightElixir.Client.new("test_api")
      %CloudsightElixir.Client{api_key: "test_api", endpoint: "https://api.cloudsight.ai"}

  """
  def new(api_key),  do: %__MODULE__{api_key: api_key}
  def new(api_key, endpoint), do: %__MODULE__{api_key: api_key, endpoint: endpoint}
end
