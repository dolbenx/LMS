defmodule LoanmanagementsystemWeb.UserSocket do
  use Phoenix.Socket

  channel "user_session:*", LoanmanagementsystemWeb.UserChannel

  def join("user_session:" <> _user_id, _message, socket) do
    {:ok, socket}
  end

  def connect(%{"token" => token}, socket, _connect_info) do
    # max_age: 1209600 is equivalent to two weeks in seconds
    case Phoenix.Token.verify(socket, "user socket", token, max_age: 1_209_600) do
      {:ok, user_id} -> {:ok, assign(socket, :user, user_id)}
      {:error, _reason} -> :error
    end
  end

  @impl true
  def connect(_params, socket, _connect_info) do
    {:ok, socket}
  end


  @impl true
  def id(_socket), do: nil
end
