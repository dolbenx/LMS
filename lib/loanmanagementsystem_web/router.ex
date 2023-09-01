defmodule LoanmanagementsystemWeb.Router do
  use LoanmanagementsystemWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {LoanmanagementsystemWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug(LoanmanagementsystemWeb.Plugs.SetUser)
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :app do
    plug(:put_layout, {LoanmanagementsystemWeb.LayoutView, :app})
  end

  pipeline :session do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:put_secure_browser_headers)
  end

  pipeline :no_layout do
    plug(:put_layout, false)
  end

  scope "/", LoanmanagementsystemWeb do
    pipe_through([:session, :no_layout])

    get("/", SessionController, :username)
    post("/", SessionController, :get_username)
    get("/admin_login", SessionController, :admin_login)
    post("/Login", SessionController, :create)
    get("/logout/current/user", SessionController, :signout)
    get("/Account/Disabled", SessionController, :error_405)
    get("/phone/number/verification", SessionController, :otp_validation)
    post("/user/phone/number/verification", SessionController, :validate_otp)
    get("/user/phone/number/verification", SessionController, :validate_otp)


    get("/new-user-role-set-otp", SessionController, :get_login_validate_otp)
    post("/Recover/Password", SessionController, :recover_password)
    get("/Recover/Password/confirm-OTP", SessionController, :get_forgot_password_validate_otp)
    post("/Forgot-Password/validate-otp", SessionController, :forgot_password_validate_otp)
    get("/Forgot-Password/User/set/Password", SessionController, :forgot_password_user_set_password)
    post("/Forgot-Password/new_user_set_password", SessionController, :forgot_password_post_new_user_set_password)

    get("/New/User/Change-Password", SessionController, :new_password)
    post("/New/User/Change-Password", SessionController, :new_password)
    get("/New/Change-Password", SessionController, :change_password)
  end

  scope "/", LoanmanagementsystemWeb do
    pipe_through([:browser, :app])
    get("/Home", PageController, :index)
    get("/Admin/Dashboard", UserController, :admin_dashboard)
  end

  scope "/", LoanmanagementsystemWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", LoanmanagementsystemWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: LoanmanagementsystemWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
