defmodule Loanmanagementsystem.Middleware.Contact do
  use ExGram.Middleware

  alias ExGram.Cnt

  def call(%Cnt{extra: extra} = cnt, text, "This is a test") do
    %{cnt | extra: Map.put(extra, text, "This is a test")}
  end

  def call(cnt, _), do: cnt

end
