defmodule LoanmanagementsystemWeb.Router do
  use LoanmanagementsystemWeb, :router
  import LoanmanagementsystemWeb.Plugs.{SessionConn, UserAuthenticate}

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_secure_browser_headers
    plug LoanmanagementsystemWeb.Plugs.BrowserCookie
    plug :put_client_ip
    plug :fetch_current_user

  end

  pipeline :root do
    plug :put_root_layout, {LoanmanagementsystemWeb.LayoutView, :root}
  end

  pipeline :app do
    plug :put_root_layout, {LoanmanagementsystemWeb.LayoutView, :app}
  end

  pipeline :login_user do
    plug(:put_root_layout, {LoanmanagementsystemWeb.LayoutView, :login_user})
  end

  pipeline :auth do
    plug LoanmanagementsystemWeb.Plugs.RequireAuth
    plug LoanmanagementsystemWeb.Plugs.EnforcePasswordPolicy
  end


  pipeline :csrf do
    plug :protect_from_forgery
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

   # ------------- BEGIN ROUTES -------------- #
   scope "/", LoanmanagementsystemWeb do
    pipe_through([:browser, :csrf, :login_user])

    post "/login", SessionController, :login
    get("/signout", SessionController, :signout)


    scope "/", SessionLive do
      live "/", Index, :index
      live "/new", Index, :new

      live_session :resets, on_mount: LoanmanagementsystemWeb.UserLiveAuth do
        live "/change/password", Reset, :index
      end
    end
  end

  live_session :admins, on_mount: LoanmanagementsystemWeb.UserLiveAuth do
    # =================== ADMIN ==================
    scope "/Admin", LoanmanagementsystemWeb.Admin do
      pipe_through([:browser, :root, :csrf, :auth])

      # =========== USER MANAGEMENT =========
      live "/Dashboard", DashboardLive.Index, :index
      # get "/Dashboard/Stats", ReportController, :dash_stats
    end

    # =========== USER MANAGEMENT =========
    scope "/admin/users", LoanmanagementsystemWeb.Admin.UserLive do
      live "/management", Index, :index
      live "/new", Index, :new
      live "/:id/edit", Index, :edit
      live "/:id/view", Index, :view
    end

    scope "/settings", LoanmanagementsystemWeb.Admin.SettingsLive do
      live "/Titles", Titles, :index
      live "/Add-Title", Titles, :new
      live "/:id/Edit-Title", Titles, :edit
    end


    scope "/settings", LoanmanagementsystemWeb.Admin.SettingsLive do
      live "/Countries", Countries, :index
      live "/Add-Country", Countries, :new
      live "/:id/Edit-Country", Countries, :edit
    end

    scope "/settings", LoanmanagementsystemWeb.Admin.SettingsLive do
      live "/Province", Provinces, :index
      live "/Add-Province", Provinces, :new
      live "/:id/Edit-Province", Provinces, :edit
    end

    scope "/settings", LoanmanagementsystemWeb.Admin.SettingsLive do
      live "/District", Districts, :index
      live "/Add-District", Districts, :new
      live "/:id/Edit-District", Districts, :edit
    end

    scope "/settings", LoanmanagementsystemWeb.Admin.SettingsLive do
      live "/Currency", Currencies, :index
      live "/Add-Currency", Currencies, :new
      live "/:id/Edit-Currency", Currencies, :edit
    end

    scope "/settings", LoanmanagementsystemWeb.Admin.SettingsLive do
      live "/Bank", Banks, :index
      live "/Add-Bank", Banks, :new
      live "/:id/Edit-Bank", Banks, :edit
    end

    scope "/settings", LoanmanagementsystemWeb.Admin.SettingsLive do
      live "/Branch", Branches, :index
      live "/Add-Branch", Branches, :new
      live "/:id/Edit-Branch", Branches, :edit
    end


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
