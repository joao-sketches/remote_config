defmodule RemoteConfig do
  use Application

  def start(_,_) do
    configs = "../credentials.json"
    |> File.read!
    |> Poison.decode!
    |> ConfigBucket.start_link
  end


  defmodule ConfigBucket do

    @bckt __MODULE__

    def start_link(configs) do
      Agent.start_link(fn -> configs end)
    end

    @doc """
    Gets a value from the `bucket` by `key`.
    on the vault this would call the vault server
    """
    def get(key) do
      Agent.get(@bckt ,&Map.get(&1, key))
    end

  end
end
