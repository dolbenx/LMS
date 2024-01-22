defmodule LoanmanagementsystemWeb.Plugs.Session do
  import Plug.Conn
  use LoanmanagementsystemWeb, :controller

  def logged_in(conn, _request) do
  #  IO.inspect(conn, label: "PLUGGGGGGGGGGG")
    # case Map.has_key?(conn.assigns, :user) do
    #   false ->
    #     conn
    #     |> put_flash(:error, "Session Expired!")
    #     |> redirect(to: "/")
    #   true ->
    #     user = conn.assigns.user
    #     if user == :user_role do
    #       conn
    #       |> put_flash(:error, "Session Expired!")
    #       |> redirect(to: "/")
    #     else
    #       conn
    #     end
    # end
    # current_user_logged = get_session(conn, :current_user)
    current_user_logged = conn.private.plug_session["current_user_bio_data"]

    case current_user_logged do
      nil ->
        conn
        |> put_flash(:error, "Session Expired, Please Login.")
        |> redirect(to: LoanmanagementsystemWeb.Router.Helpers.session_path(conn, :username))
      _ ->
        conn
    end
  end

  # def api_auth(conn, _) do
  #   #    IO.inspect(conn, label: "1111111111111111 APIS")
  #   public_key = get_req_header(conn, "public-key") |> List.to_string()
  #   secret_key = get_req_header(conn, "secret-key") |> List.to_string()

  #   case Utils.get_api_auth(public_key, secret_key) do
  #     nil ->
  #       conn
  #       |> put_status(:unauthorized)
  #       |> json(%{data: [], status: false, message: "Unauthorized"})
  #       |> halt

  #     [] ->
  #       conn
  #       |> put_status(:unauthorized)
  #       |> json(%{data: [], status: false, message: "Unauthorized"})
  #       |> halt()

  #     _ ->
  #       conn
  #   end
  # end

  # def api_auth_method(conn, _) do
  #   #    IO.inspect(conn, label: "1111111111111111 APIS")
  #   method = conn.method

  #   case method do
  #     "POST" ->
  #       conn

  #     _ ->
  #       conn
  #       |> put_status(:unauthorized)
  #       |> json(%{data: [], status: false, message: "#{method} is not allowed!"})
  #       |> halt()
  #   end
  # end

  # def confirm(conn, _) do
  #   params = conn.query_params

  #   #    IO.inspect(params, label: "PARAMS")
  #   trans_uuid = params["trans_uuid"]

  #   case get_basic(trans_uuid) do
  #     nil ->
  #       conn
  #       |> put_flash(:error, "Something wrong happend!")
  #       |> redirect(to: "/Employee/dashboard")

  #     _ ->
  #       conn
  #   end
  # end

  # defp get_basic(key) do
  #   case Cachex.get(:lms, key) do
  #     {:ok, nil} -> nil
  #     {:ok, result} -> result
  #     {:error, _} -> nil
  #   end
  # end
end
