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
    plug(LoanmanagementsystemWeb.Plugs.SessionTimeout, timeout_after_seconds: 60000)
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :app do
    plug(:put_layout, {LoanmanagementsystemWeb.LayoutView, :app})
  end


  pipeline :employer_app do
    plug(:put_layout, {LoanmanagementsystemWeb.LayoutView, :employer_app})
  end

  pipeline :web_app do
    plug(:put_layout, {LoanmanagementsystemWeb.LayoutView, :web_app})
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
    pipe_through([:session, :web_app])

    get("/", SessionController, :username)
    get("/About-Us", WebsiteController, :about)
    get("/Servies", WebsiteController, :services)
    get("/Contact-Us", WebsiteController, :contact_us)
    get("/Our-Team", WebsiteController, :team)
    get("/Our-Portfolio", WebsiteController, :portfolio)
    get("/How-To-Apply", WebsiteController, :how_it_works)
    get("/Customer-Testimonial", WebsiteController, :testimonial)
    get("/Freqent-Asked-Questions", WebsiteController, :faq)
  end


  scope "/", LoanmanagementsystemWeb do
    pipe_through([:session, :no_layout])

    get("/User/Login", SessionController, :userlogin)

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


    # -----------------------------------Product Management----------------------------------------------------- #
    get("/Admin/view/all/products", ProductsController, :admin_all_products)
    get("/Admin/edit/products", ProductsController, :admin_edit_product)
    # post("/Admin/view/all/products", ProductsController, :admin_all_products)
    get("/Admin/view/all/products/view", ProductsController, :admin_view_add_product)
    get("/Admin/view/pending/products", ProductsController, :pending_products)
    get("/Admin/view/inactive/products", ProductsController, :inactive_products)
    get("/Admin/view/all/products/create", ProductsController, :admin_add_product)
    post("/Admin/view/all/products/create", ProductsController, :admin_add_product)
    get("/Admin/view/all/products/update", ProductsController, :admin_update_product)
    post("/Admin/view/all/products/update", ProductsController, :admin_update_product)
    get("/Admin/view/system/products/activate", ProductsController, :admin_activate_product)
    post("/Admin/view/system/products/activate", ProductsController, :admin_activate_product)
    get("/Admin/view/system/products/deactivate", ProductsController, :admin_deactivate_product)
    post("/Admin/view/system/products/deactivate", ProductsController, :admin_deactivate_product)
    post("/Admin/View/product/update", ProductsController, :admin_update_product_details)
    post("/products/items/view", ProductsController, :product_item_lookup)
    post("/Admin/products/selected/charge", ProductsController, :admin_charge_lookup)
    # -----------------------------------END Product Management----------------------------------------------------- #

    # -----------------------------------Loan Management----------------------------------------------------- #
    get("/Loan/Application", LoanController, :loans_application)
    get("/All/Customer/Loans", LoanController, :loans)
    get("/Credit/Management/Loan-Repayment", LoanController, :repayment_loans)
    get("/Credit/Management/Loan-Tracking", LoanController, :tracking_loans)
    get("/Credit/Management/Pending-Loans", LoanController, :pending_loans)
    get("/Credit/Management/Disbursed-Loans", LoanController, :disbursed_loans)
    get("/Credit/Management/Written-Off-Loan", LoanController, :written_off_loans)
    get("/Credit/Management/quick_advance_application", LoanController, :quick_advance_application_datatable)
    post("/Credit/Management/repayment_maintenance", LoanController, :loan_repayment_item_lookup)
    # -----------------------------------END Loan Management----------------------------------------------------- #

     # -----------------------------------CLient Management-----------------------------------------------------
     get("/admin/client/maintain/sme/maintainence", ClientManagementController, :employer_maintainence)
     get("/admin/employee/maintainence", ClientManagementController, :employee_maintainence)

    get(
      "/admin/client/maintain/employee/maintainence",
      ClientManagementController,
      :client_maintainence
    )

    get("/admin/client/maintain/add", ClientManagementController, :add_client)

    post("/admin/client/maintain/edit_client", ClientManagementController, :edit_client)
    get("/admin/client/maintain/edit_client", ClientManagementController, :edit_client)

    get(
      "/admin/client/maintain/employee/create/client",
      ClientManagementController,
      :create_client_user
    )

    post(
      "/admin/client/maintain/employee/create/client",
      ClientManagementController,
      :create_client_user
    )

    get("/admin/client/maintain/activate_client", ClientManagementController, :activate_client)
    post("/admin/client/maintain/activate_client", ClientManagementController, :activate_client)

    get(
      "/admin/client/maintain/deactivate_client",
      ClientManagementController,
      :deactivate_client
    )

    post(
      "/admin/client/maintain/deactivate_client",
      ClientManagementController,
      :deactivate_client
    )

    get(
      "/admin/client/maintain/mobile/money/argent/maintainence",
      ClientManagementController,
      :mobile_money_argents
    )

    post(
      "/admin/add/momo/argent/maintainence",
      ClientManagementController,
      :admin_create_momo_agent
    )

    get(
      "/admin/add/momo/argent/maintainence",
      ClientManagementController,
      :admin_create_momo_agent
    )

    post(
      "/admin/add/momo/merchant/maintainence",
      ClientManagementController,
      :admin_create_merchant
    )

    get(
      "/admin/add/momo/merchant/maintainence",
      ClientManagementController,
      :admin_create_merchant
    )

    get(
      "/admin/client/maintain/client/relationship/managers",
      ClientManagementController,
      :client_managers_relationship
    )

    get(
      "/admin/client/maintain/blacklisted/client",
      ClientManagementController,
      :blacklisted_clients
    )

    get(
      "/admin/client/maintain/fuel/importer/maintenance",
      ClientManagementController,
      :fuel_importer_maintenance
    )

    get(
      "/admin/client/maintain/merchant/maintenance",
      ClientManagementController,
      :merchant_maintenance
    )

    get(
      "/admin/client/maintain/sme/maintainence/create",
      ClientManagementController,
      :admin_employer_maintainence
    )

    post(
      "/admin/client/maintain/sme/maintainence/create",
      ClientManagementController,
      :admin_employer_maintainence
    )

    post(
      "/admin/view/client/relation/managers",
      ClientManagementController,
      :client_relationship_manager_item_lookup
    )

    get(
      "/admin/view/client/relation/managers",
      ClientManagementController,
      :client_relationship_manager_item_lookup
    )

    post(
      "/admin/change/client/relation/managers",
      ClientManagementController,
      :change_client_manager
    )

    get(
      "/admin/change/client/relation/managers",
      ClientManagementController,
      :change_client_manager
    )

    post(
      "/client/relation/managers/lookup",
      ClientManagementController,
      :client_manager_item_lookup
    )

    get(
      "/client/relation/managers/lookup",
      ClientManagementController,
      :client_manager_item_lookup
    )




    post("/client/relation/managers/bulk/lookup", OrganizationManagementController, :client_manager_item_lookup)

    get(
      "/client/relation/managers/bulk/lookup",
      OrganizationManagementController,
      :client_manager_item_lookup)

      # --------------------------------------------System Management-------------------------------------
    get(
      "/admin/change/management/system/management/user/management",
      SystemManagementController,
      :admin_user_maintenance
    )

    get(
      "/admin/change/management/role/maintainence",
      SystemManagementController,
      :role_maintianence
    )

    get(
      "/admin/change/management/role/maintainence/add_description",
      SystemManagementController,
      :add_description
    )

    post(
      "/admin/change/management/role/maintainence/add_description",
      SystemManagementController,
      :add_description
    )

    get(
      "/admin/change/management/role/maintainence/activate",
      SystemManagementController,
      :activate_role_description
    )

    post(
      "/admin/change/management/role/maintainence/activate",
      SystemManagementController,
      :activate_role_description
    )

    post(
      "/admin/change/management/role/maintainence/disable",
      SystemManagementController,
      :disable_role_description
    )

    post(
      "/admin/change/management/create/maker/checker",
      SystemManagementController,
      :configure_maker_checker
    )

    post(
      "/admin/change/management/edit/maker/checker",
      SystemManagementController,
      :edit_maker_checker
    )

    get(
      "/admin/change/management/charge/maintenance",
      SystemManagementController,
      :charge_maintenance
    )

    get(
      "/admin/change/management/commission/maintenance",
      SystemManagementController,
      :commission_maintenance
    )

    get(
      "/admin/change/management/department/maintainence",
      OrganizationManagementController,
      :admin_department
    )

    get(
      "/admin/change/management/role/permision/maintainence",
      SystemManagementController,
      :role_permision_maintianence
    )

    get(
      "/admin/change/management/country/maintainence",
      SystemManagementController,
      :countries
    )

    get(
      "/admin/change/management/province/maintainence",
      SystemManagementController,
      :province
    )

    get(
      "/admin/change/management/town/maintainence",
      SystemManagementController,
      :district
    )

    get(
      "/admin/change/management/maker/checker/configuration",
      SystemManagementController,
      :maker_checker_configuration
    )

    get(
      "/admin/change/management/report/maintainence",
      SystemManagementController,
      :report_maintianence
    )

    get(
      "/admin/change/management/global/configuration",
      SystemManagementController,
      :global_configurations
    )

    get(
      "/admin/change/management/account/number/generation",
      SystemManagementController,
      :account_number_generation
    )

    get(
      "/admin/change/management/external/service/configuration",
      SystemManagementController,
      :external_service_configuration
    )

    get("/admin/change/management/audit/trail", SystemManagementController, :audit_trail)

    # ---------------------------------------End of System Management---------------------------------------

  end

  scope "/", LoanmanagementsystemWeb do
    pipe_through([:browser, :employer_app])
    get("/Employer/Dashboard", PageController, :index)
    get("/Employer/dashboard", UserController, :employer_dashboard)
    get("/Employer/get/all/loans", EmployerController, :employer_employee_all_loans)
    get("/Employer/get/all/distursed/loans", EmployerController, :employer_employee_disbursed_loans)
    get("/Employer/get/all/pending/loans", EmployerController, :employer_employee_pending_loans)
    get("/Employer/get/all/rejected/loans", EmployerController, :employer_employee_rejected_loans)
    get("/Employer/apply/loans", EmployerController, :employer_employee_loan_products)
    get("/Employer/Admin/get/all/loans", EmployerController, :employer_all_loans)
    get("/Employer/Admin/get/all/distursed/loans", EmployerController, :employer_disbursed_loans)
    get("/Employer/Admin/get/all/pending/loans", EmployerController, :employer_pending_loans)
    get("/Employer/Admin/get/all/rejected/loans", EmployerController, :employer_rejected_loans)
    get("/Employer/all/staffs/loans", EmployerController, :staff_all_loans)
    post("/Employer/all/staffs/loans/handle/bulk/upload", EmployerController, :handle_staff_bulk_upload)
    get("/Employer/all/admins/loans", EmployerController, :company_all_loans)
    get("/Employer/reports/", EmployerController, :employer_transaction_reports)
    post("/Employer/create/staffs", EmployerController, :employer_create_employee)
    get("/Employer/create/staffs", EmployerController, :employer_create_employee)
    get("/Employer/all/staffs", EmployerController, :all_staffs)
    get("/Employer/all/admins", EmployerController, :user_mgt)
    get("/Employer/Admin/user/logs", EmployerController, :employer_user_logs)
    post("/Employer/view/system/employee/create", EmployerController, :employer_create_employee)
    get("/Employer/view/system/employee/create", EmployerController, :employer_create_employee)
    post("/Generate/Random/Password/employee", EmployerController, :generate_random_password)
    get("/Generate/Random/Password/employee", EmployerController, :generate_random_password)
    post("/Employer/update/staffs", EmployerController, :employer_update_employee)
    get("/Admin/Employer/activate/employee", EmployerController, :employer_activate_employee)
    post("/Admin/Employer/activate/employee", EmployerController, :employer_activate_employee)
    post("/Admin/Employer/deactivate/employee", EmployerController, :employer_deactivate_employee)
    get("/Admin/Employer/deactivate/employee", EmployerController, :employer_deactivate_employee)
    post("/Admin/Employer/Admin/employee", EmployerController, :employer_create_admin_employee)
    get("/Admin/Employer/Admin/employee", EmployerController, :employer_create_admin_employee)
    post("/Admin/Employer/deactivate/Admin/employee", EmployerController, :employer_deactivate_employee )
    get("/Employer/deactivate/Admin/employee", EmployerController, :employer_deactivate_employee)
    get("/Employer/activate/Admin/employee", EmployerController, :employer_activate_employee)
    post("/Employer/activate/Admin/employee", EmployerController, :employer_activate_employee)
    post("/Employer/get/all/employee/loans", EmployerController, :employer_employee_all_loans_list_item_lookup)
    post("/Employer/get/all/pending/employee/loans", EmployerController, :employer_employee_pending_loans_list_item_lookup)
    post("/Employer/get/all/rejected/employee/loans", EmployerController, :employer_employee_rejected_loans_list_item_lookup)
    post("/Employer/get/all/disbursed/employee/loans", EmployerController, :employer_employee_disbursed_loans_list_item_lookup)
    get("/Client/Upload/Loan/Documents", EmployerController ,:client_approval_details)

  end

  scope "/", LoanmanagementsystemWeb do
    pipe_through :browser

    # get "/", PageController, :index
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
