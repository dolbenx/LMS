defmodule Loanmanagementsystem.Security.ParamsValidator do
  import Plug.Conn
  alias Skooma

  def validate(params, schema) do
    params
    |> Skooma.valid?(schema)
    |> case do
      {:error, message} -> {:error, message}
      :ok -> :ok
    end
  end

  def validate(conn, params, schema) do
    params
    |> Skooma.valid?(schema)
    |> case do
      {:error, message} ->
        {:error, put_status(conn, :bad_request), %{message: message, success: false, status: 400}}

      :ok ->
        {:ok, conn}
    end
  end
end
