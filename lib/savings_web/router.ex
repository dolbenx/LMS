defmodule SavingsWeb.Router do
  use SavingsWeb, :router
  import SavingsWeb.Plugs.Session

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug(SavingsWeb.Plugs.SetUser)
    plug(SavingsWeb.Plugs.SessionTimeout, timeout_after_seconds: 3000)
  end

  pipeline :corsPlug do
    plug CORSPlug
  end

  pipeline :csrf do
    plug :protect_from_forgery
  end

  pipeline :guest do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :session do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :savings_admin_app do
    plug(:put_layout, {SavingsWeb.LayoutView, :savings_admin_app})
  end

  pipeline :no_layout do
    plug :put_layout, false
  end

  scope "/", SavingsWeb do
    pipe_through([:api, :no_layout])
    get("/emulator-ussd", UssdController, :index)
    get("/ussd", UssdController, :initiateUssd)
  end

  scope "/", SavingsWeb do
    pipe_through([:guest, :no_layout])

    get("/forgot-password", SessionController, :forgot_password)
    post("/forgot-password", SessionController, :post_forgot_password)
    post("/validate-otp", SessionController, :validate_otp)
    get("/new-user-set-password", SessionController, :new_user_set_password)
    post("/new_user_set_password", SessionController, :post_new_user_set_password)
  end

  scope "/", SavingsWeb do
    pipe_through([:session, :no_layout])

    get("/", SessionController, :username)
    post("/", SessionController, :get_username)
    get("/forgortFleetHub//password", UserController, :forgot_password)
    post("/confirmation/token", UserController, :token)
    get("/reset/FleetHub/password", UserController, :default_password)
    get "/Users/On/Leave", UserController, :users_on_leave
    post "/Activate/Leave/Account", UserController, :activate_user_on_leave
    post("/Login", SessionController, :create)
  end

  scope "/", SavingsWeb do
    pipe_through([:browser, :no_layout])

    get("/logout/current/user", SessionController, :signout)
    get "/Account/Disabled", SessionController, :error_405
    # post("/validate-otp", SessionController, :validate_otp)
    # get("/new-user-set-password", SessionController, :new_user_set_password)
    # post("/new_user_set_password", SessionController, :post_new_user_set_password)
    # get("/loan/apply-for-a-loan", LoanController, :loan_product_guest)
    get("/new-user-role-set-otp", SessionController, :get_login_validate_otp)
    post("/Recover/Password", SessionController, :recover_password)
    get("/Recover/Password/confirm-OTP", SessionController, :get_forgot_password_validate_otp)
    post("/Forgot-Password/validate-otp", SessionController, :forgot_password_validate_otp)

    get("/Forgot-Password/User/set/Password", SessionController, :forgot_password_user_set_password)

    post("/Forgot-Password/new_user_set_password", SessionController, :forgot_password_post_new_user_set_password)
  end

  scope "/", SavingsWeb do
    pipe_through([:browser, :savings_admin_app, :logged_in])

    get("/Savings/Dashboard", UserController, :savings_dashboard)
    get("/Savings/User/Logs", UserController, :user_logs)
    get("/Savings/USSD/Logs", UserController, :ussd_logs)
    post "/Savings/Create/User/Role", UserController, :create_roles
    get("/Savings/User/Management", UserController, :user_mgt)
    post("/Savings/User/Management/Update", UserController, :admin_edit_user)

    get("/Savings/Products", ProductController, :savings_product)
    post("/Reset/Password", UserController, :default_password)
    post("/Reset/User/Password", UserController, :reset_pwd)
    post("/Change/Password", UserController, :change_password)
    get("/Change/Password", UserController, :new_password)
    get("/Branch/Maintenance/", MaintenanceController, :branch_maintenance)
    post("/Admin/Create/Branch/", MaintenanceController, :create_branch)
    get("/Security/Questions/Maintenance/", MaintenanceController, :security_questions)
    post("/Add/Security/Questions/", MaintenanceController, :add_security_questions)
    post("/Update/Security/Questions/", MaintenanceController, :update_questions)
    post("/Disable/Security/Questions/", MaintenanceController, :question_disable)
    post("/Activate/Security/Questions/", MaintenanceController, :question_activate)
    get("/Currency/Maintenance/", MaintenanceController, :currency_maintenance)
    post("/Admin/Add/Currency/", MaintenanceController, :create_currency)
    post("/Admin/Update/Currency/", MaintenanceController, :update_currency)
    get("/Countries/Maintenance/", MaintenanceController, :countries_maintenance)
    get("/Charge/Maintenance/", MaintenanceController, :charge_maintenance)
    post("/Admin/Maintain/Charge/", MaintenanceController, :create_charge)
    get("/All/Customer/List/", CustomerController, :customer_list)
    post("/Lookup/Customer/List", CustomerController, :customer_item_lookup)
    get("/View/Customer/List", CustomerController, :view_customer)

    get("/System/User/Mgt", UserController, :user_mgt)
    post("/Create/System/User/", UserController, :create_user)
    post("/Admin/Deactivate/User", UserController, :deactivate_admin)
    get("/Admin/Deactivate/User", UserController, :deactivate_admin)
    post("/Admin/Activate/User", UserController, :activate_admin)
    get("/Admin/Activate/User", UserController, :activate_admin)

    post("/Generate/Random/Password", UserController, :generate_random_password)

    post "/Admin/Create/User", UserController, :create_user
    get("/Get/System/User/Roles", UserController, :user_roles)
    get("/edit/User/Roles", UserController, :edit_user_roles)
    get("/view/User/Roles", UserController, :view_user_roles)
    post("/update/user/role", UserController, :update)
    get("/update/user/role", UserController, :update)
    post("/Create/New/User/Roles", UserController, :create_user_role)
    get("/Create/New/User/Roles", UserController, :create_user_role)
    post("/change/user/role/status", UserController, :change_status)
    get("/change/user/role/status", UserController, :change_status)

    post("/admin/view/all/products/create", ProductController, :add_savings_product)
    get("/admin/view/all/products/create", ProductController, :add_savings_product)
    post("/Update/Savings/Products", ProductController, :update_savings_product)
    get("/Activate/Savings/Products", ProductController, :activate_savings_product)
    post("/Activate/Savings/Products", ProductController, :activate_savings_product)
    get("/Disable/Savings/Products", ProductController, :disable_savings_product)
    post("/Disable/Savings/Products", ProductController, :disable_savings_product)
    get("/Get/Calender/Maintenance/View", MaintenanceController, :calender_maintenance)
    post("/Admin/Create/Calender/", MaintenanceController, :create_calendar)
    post("/Admin/Update/Calender/", MaintenanceController, :update_calendar)

    get("/Savings/New-Flexcube-Account", FcubeGeneralLedgerController, :new)
    get("/Savings/New-Flexcube-Account/Create", FcubeGeneralLedgerController, :create_gl)
    post("/Savings/New-Flexcube-Account/Create", FcubeGeneralLedgerController, :create_gl)
    get("/Savings/New-Flexcube-Account/:accountId", FcubeGeneralLedgerController, :edit)
    post("/Savings/Update-Flexcube-Account", FcubeGeneralLedgerController, :edit)
    get("/Savings/Update-Flexcube-Account", FcubeGeneralLedgerController, :edit)
    get("/Savings/End-Of-Day-Configurations/FC", FcubeGeneralLedgerController, :get_configurations)

    get("/Savings/View-Flexcube-Accounts", FcubeGeneralLedgerController, :index)
    get("/Savings/View-Flexcube-Requests", FcubeGeneralLedgerController, :index)
    post("/Savings/Update/Flexcube/Account", FcubeGeneralLedgerController, :update_gl_account)
    get("/Savings/Update/Flexcube/Account", FcubeGeneralLedgerController, :update_gl_account)
    get("/Savings/Activate/Flexcube/Account", FcubeGeneralLedgerController, :enable_gl_account)
    post("/Savings/Activate/Flexcube/Account", FcubeGeneralLedgerController, :enable_gl_account)
    get("/Savings/Deactivate/Flexcube/Account", FcubeGeneralLedgerController, :disable_gl_account)
    post("/Savings/Deactivate/Flexcube/Account", FcubeGeneralLedgerController, :disable_gl_account)
    get("/Savings/End-Of-Day-Configurations", EndOfDayRunController, :create_end_of_day_configurations)
    post("/Savings/End-Of-Day-Configurations", EndOfDayRunController, :post_create_end_of_day_configurations)
    get("/Savings/End-Of-Day-History", EndOfDayRunController, :index)
    get("/Savings/End-Of-Day-History-Entries/:endofdayid", EndOfDayRunController, :end_of_day_entries)
    get("/Savings/Run-End-Of-Day", EndOfDayRunController, :new)
    post("/Savings/Run-End-Of-Day", EndOfDayRunController, :create)

    post("/change/customer/account/status", CustomerController, :change_status)


    get("/All/Customer/Txn/List/", TransactionController, :all_transactions)
    post("/Lookup/Customer/All/Txn/List", TransactionController, :customer_all_txn_item_lookup)
    get("/All/Customer/Fixed/Deposits/Txn/", TransactionController, :fixed_deposits)
    post("/Lookup/Customer/All/Fixed/Deposits/List", TransactionController, :customer_all_fixed_deposits_item_lookup)
    get("/All/Customer/Full/Withdraws/List/", TransactionController, :full_divestment_withdraws)
    post("/Lookup/Customer/All/Full/Withdraws/List", TransactionController, :customer_all_full_withdraws_item_lookup)
    get("/All/Customer/Partial/Withdraws/List/", TransactionController, :partial_divestment_withdraws)
    post("/Lookup/Customer/All/Partial/Withdraws/List", TransactionController, :customer_all_partial_withdraws_item_lookup)
    get("/All/Clients/Withdraws/List/", TransactionController, :all_withdrawals_transactions)
    post("/Customer/Lookup/Customer/Withdraws/List", TransactionController, :customer_all_Withdraws_txn_item_lookup)

    get("/Get/Customer/Report/Fixed/Deposits/List", ReportController, :fixed_deposit_reports)
    post("/Generate/Fixed/Deposit/Reports", ReportController, :fixed_deposit_item_lookup)

    get("/Get/Customer/Report/Divestment/List", ReportController, :divestment_reports)
    post("/Generate/Customer/Divestment/Reports", ReportController, :divestment_item_lookup)

    get("/Get/Customer/Report/List", ReportController, :customer_reports)
    post("/Generate/all/Customer/Reports", ReportController, :all_customer_item_lookup)

    get("/Get/Customer/Report/All/Transaction/List", ReportController, :transaction_reports)
    post("/Generate/Customer/transaction/Reports",ReportController, :all_customer_txn_item_lookup)

    get("/Liquidated/Reports", ReportController, :liqudated_reports)
    post("/Generate/all/Customer/Liquid/Reports", ReportController, :all_customer_liquid_item_lookup)

    get("/Deposit/Interest/Reports", ReportController, :deposit_reports_interest)
    post("/Deposit/Interest/Reports/lookup", ReportController, :all_customer_deposit_interest_item_lookup)

    get("/Deposit/Summury/Reports", ReportController, :deposits_reports_summury)
    post("/Deposit/Summury/Reports/lookup", ReportController, :all_customer_deposit_summary_item_lookup)
  end

  scope "/Download", SavingsWeb do
    pipe_through [:browser, :corsPlug, :csrf]

    get "/Excel/Customer/Export", ExportExcelController, :customer_view_excel
    get "/CSV/Customer/Export", ExportCsvController, :customer_view_csv
    get "/Customer/PDF", ExportPDFController, :customer_view_pdf

    get "/Excel/Tnx/Fixed-Deposits/Export", ExportExcelController, :tnx_fixed_deps_view_excel
    get "/CSV/Tnx/Fixed-Deposits/Export", ExportCsvController, :tnx_fixed_deps_view_csv
    get "/Tnx/Fixed-Deposits/PDF", ExportPDFController, :tnx_fixed_deps_view_pdf

    get "/Excel/Tnx/Partial/Divestment/Export", ExportExcelController, :partial_divestment_view_excel
    get "/CSV/Tnx/Partial/Divestment/Export", ExportCsvController, :partial_divestment_view_csv
    get "/Tnx/Partial/Divestment/PDF", ExportPDFController, :partial_divestments_view_pdf

    get "/Excel/Tnx/Full/Divestment/Export", ExportExcelController, :full_divestment_view_excel
    get "/CSV/Tnx/Full/Divestment/Export", ExportCsvController, :full_divestment_view_csv
    get "/Tnx/Full/Divestment/PDF", ExportPDFController, :full_divestments_view_pdf

    get "/Excel/Tnx/Mature/Withdraw/Export", ExportExcelController, :mature_withdraw_view_excel
    get "/CSV/Tnx/Mature/Withdraw/Export", ExportCsvController, :mature_withdraw_view_csv
    get "/Tnx/Mature/Withdraw/PDF", ExportPDFController, :mature_withdraw_view_pdf

    get "/Excel/Tnx/All/Transactions/Export", ExportExcelController, :all_transactions_view_excel
    get "/CSV/Tnx/All/Transactions/Export", ExportCsvController, :all_transactions_view_csv
    get "/Tnx/All/Transactions/PDF", ExportPDFController, :all_transactions_view_pdf


    get "/Excel/Report/Fixed-Deposits/Export", ExportExcelController, :report_fixed_deps_view_excel
    get "/CSV/Report/Fixed-Deposits/Export", ExportCsvController, :report_fixed_deps_view_csv
    get "/Report/Fixed-Deposits/PDF", ExportPDFController, :report_fixed_deps_view_pdf

    get "/Excel/Report/Deposit/Summury/Export", ExportExcelController, :report_deposit_summury_view_excel
    get "/CSV/Report/Deposit/Summury/Export", ExportCsvController, :report_deposit_summury_view_csv
    get "/Report/Deposit/Summury/PDF", ExportPDFController, :report_deposit_summury_view_pdf

    get "/Excel/Report/Deposit/Interest/Export", ExportExcelController, :report_deposit_interest_view_excel
    get "/CSV/Report/Deposit/Interest/Export", ExportCsvController, :report_deposit_interest_view_csv
    get "/Report/Deposit/Interest/PDF", ExportPDFController, :report_deposit_interest_view_pdf
  end

  # Other scopes may use custom stacks.
  # scope "/api", SavingsWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: SavingsWeb.Telemetry
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
