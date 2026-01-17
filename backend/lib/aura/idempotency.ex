defmodule Aura.Idempotency do
  @moduledoc """
  Helpers for idempotency handling and request hashing.
  """

  @hash_algorithm :sha256

  def hash_request(method, path, body) when is_binary(method) and is_binary(path) do
    normalized_body = normalize_body(body)
    payload = [String.upcase(method), path, normalized_body] |> Enum.join("|")

    @hash_algorithm
    |> :crypto.hash(payload)
    |> Base.encode16(case: :lower)
  end

  defp normalize_body(body) when is_binary(body), do: body
  defp normalize_body(body) when is_map(body) do
    body
    |> Jason.encode!(%{escape: :json, pretty: false, maps: :strict})
  end
  defp normalize_body(body), do: to_string(body)
end
