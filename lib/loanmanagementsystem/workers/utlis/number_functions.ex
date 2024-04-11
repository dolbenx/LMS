defmodule Loanmanagementsystem.Workers.Utlis.NumberFunctions do


  def convert_to_int(alpha) do
    {nun, _} = Integer.parse(alpha)
    nun
  end

  def convert_to_float(alpha) do
    case String.trim(alpha) do
      "" ->
        %{Message: "Float Needed"}

      _else ->
        {nun, _} = Float.parse(alpha)
        nun
    end
  end

  def convert_to_float1(alpha) do
    {nun, _} = Float.parse(alpha)
    nun
  end

  def convert_to_boolean(alpha) do
    target = alpha |> String.downcase()

    cond do
      target == "true" || target == "yes" || target == "on" -> true
      target == "false" || target == "no" || target == "off" -> false
      true -> nil
    end
  end

end
