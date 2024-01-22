defmodule Loanmanagementsystem.Services.Api.Utils do
  import Ecto.Query, warn: false
  alias Loanmanagementsystem.Repo
  alias Loanmanagementsystem.Logs.UserLogs



  def from_struct(struct) do
    if struct == nil do
      nil
    else
      Map.from_struct(struct)
      |> Map.delete(:__meta__)

    end
  end

  def traverse_errors(errors) do
    for {key, {msg, _opts}} <- errors, do: "#{key} #{msg}"
  end

end
