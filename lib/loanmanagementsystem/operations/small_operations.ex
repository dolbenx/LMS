defmodule Loanmanagementsystem.SmallOperations do
  import Ecto.Query, warn: false
  alias Loanmanagementsystem.Repo





  # Loanmanagementsystem.SmallOperations.change_datatype("12")
  def change_datatype(value) do
    if String.contains?(value, ".") do
      String.to_float(value)
    else
      String.to_integer(value)
    end
  end


end
