defmodule LoanmanagementsystemWeb.Router do
  use LoanmanagementsystemWeb, :router
  import LoanmanagementsystemWeb.Plugs.Session

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(LoanmanagementsystemWeb.Plugs.SetUser)
    plug(LoanmanagementsystemWeb.Plugs.SessionTimeout, timeout_after_seconds: 3600)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :user_auth_api do
    plug :accepts, ["json"]
    plug LoanmanagementsystemWeb.Plug.UserAuth
  end

  pipeline :app do
    # plug(LoanmanagementsystemWeb.Plugs.RequireAdminAccess)
    plug(:put_layout, {LoanmanagementsystemWeb.LayoutView, :app})
  end

  pipeline :employer_app do
    # plug(LoanmanagementsystemWeb.Plugs.RequireAdminAccess)
    plug(:put_layout, {LoanmanagementsystemWeb.LayoutView, :employer_app})
  end

  pipeline :employee_app do
    # plug(LoanmanagementsystemWeb.Plugs.RequireAdminAccess)
    plug(:put_layout, {LoanmanagementsystemWeb.LayoutView, :employee_app})
  end

  pipeline :individual_app do
    # plug(LoanmanagementsystemWeb.Plugs.RequireAdminAccess)
    plug(:put_layout, {LoanmanagementsystemWeb.LayoutView, :individual_app})
  end

  pipeline :sme_app do
    # plug(LoanmanagementsystemWeb.Plugs.RequireAdminAccess)
    plug(:put_layout, {LoanmanagementsystemWeb.LayoutView, :sme_app})
  end

  pipeline :offtaker_app do
    # plug(LoanmanagementsystemWeb.Plugs.RequireAdminAccess)
    plug(:put_layout, {LoanmanagementsystemWeb.LayoutView, :offtaker_app})
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

  # scope "/", LoanmanagementsystemWeb do
  #   pipe_through :browser

  #   get "/", SessionController, :username
  #   # get("/login", SessionController, :username)

  # end

  # scope "/", LoanmanagementsystemWeb do
  #   pipe_through([:session, :no_layout])
  #   # pipe_through :browser
  #   # get "/Dashboard", UserController, :dashboard
  #   get("/", SessionController, :username)
  #   post("/", SessionController, :get_username)
  #   get "/admin_login", SessionController, :admin_login
  #   post("/Login", SessionController, :create)
  # end

  scope "/", LoanmanagementsystemWeb do
    pipe_through([:session, :no_layout])

    get("/Login", SessionController, :username)
    get("/forgot-password", SessionController, :forgot_password)
    post("/forgot-password", SessionController, :post_forgot_password)
    post("/validate-otp", SessionController, :validate_otp)
    get("/new-user-set-password", SessionController, :new_user_set_password)
    post("/new_user_set_password", SessionController, :post_new_user_set_password)
    get("/Register", SessionController, :register)
    get("/Register/individual/create", UserController, :self_create_user)
    post("/Register/individual/create", UserController, :self_create_user)
    get("/Register/company/create", MaintenanceController, :self_create_company)
    post("/Register/company/create", MaintenanceController, :self_create_company)

    get("/Register/company/create/sme", MaintenanceController, :self_create_company_sme)
    post("/Register/company/create/sme", MaintenanceController, :self_create_company_sme)

    get("/Register/company/create/offtaker", MaintenanceController, :self_create_company_offtaker)
    post("/Register/company/create/offtaker", MaintenanceController, :self_create_company_offtaker)

    get("/user/change/password", UserController, :new_password)
    post("/user/change/password", UserController, :post_change_password)
    post("/Cutomer/self/Register/individual", UserController, :customer_self_registration)
    get("/Cutomer/self/Register/individual", UserController, :customer_self_registration)
    post("/user/password/reset", UserController, :reset_user_password)
    get("/user/password/reset", UserController, :reset_user_password)

  end

  scope "/", LoanmanagementsystemWeb do
    pipe_through([:session, :no_layout])
    # pipe_through :browser
    # get "/Dashboard", UserController, :dashboard
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
    pipe_through([:browser, :app, :logged_in])
    get("/Home", PageController, :index)
    get("/Admin/Dashboard", UserController, :admin_dashboard)
    get("/Admin/Maintain/Currency", MaintenanceController, :currency)
    get("/Admin/Maintain/Security-Questions", MaintenanceController, :security_questions)
    get("/Admin/Maintain/Company", CustomersController, :company)
    get("/Admin/Maintain/Offatker", CustomersController, :offtaker)
    post("/Admin/Maintain/Countries/Create", MaintenanceController, :admin_create_country)
    get("/Admin/Maintain/Countries/Create", MaintenanceController, :admin_create_country)
    get("/Admin/Maintain/Currency/Create", MaintenanceController, :admin_create_currency)
    post("/Admin/Maintain/Currency/Create", MaintenanceController, :admin_create_currency)
    get("/Admin/Maintain/Province/Create", MaintenanceController, :admin_create_province)
    post("/Admin/Maintain/Province/Create", MaintenanceController, :admin_create_province)
    get("/Admin/Maintain/District/Create", MaintenanceController, :admin_create_district)
    post("/Admin/Maintain/District/Create", MaintenanceController, :admin_create_district)

    get("/api/checkEmailExistence?email=", ClientManagementController, :checkmail)

    get("/User/Change/Password", UserController, :new_password)
    post("/User/Change/Password", UserController, :change_password)

    get(
      "/Admin/maintain/security_questions/create",
      MaintenanceController,
      :admin_create_security_questions
    )

    post(
      "/Admin/maintain/security_questions/create",
      MaintenanceController,
      :admin_create_security_questions
    )
    get("/Admin/Customer/report", ReportsController, :admin_view_all_customer)
    get("/Admin/maintain/company/create", MaintenanceController, :admin_create_company)
    post("/Admin/maintain/company/create", MaintenanceController, :admin_create_company)

    get("/Admin/maintain/offtaker/create", MaintenanceController, :admin_create_company_offtaker)
    post("/Admin/maintain/offtaker/create", MaintenanceController, :admin_create_company_offtaker)

    get("/Admin/maintain/sme/create", MaintenanceController, :admin_create_company_sme)
    post("/Admin/maintain/sme/create", MaintenanceController, :admin_create_company_sme)

    get("/Admin/maintain/msg/configure", MaintenanceController, :admin_maintian_message_configurations)

    # --------------------------------------------System Management-------------------------------------
    get(
      "/Admin/change/management/system/management/user/management",
      SystemManagementController,
      :admin_user_maintenance
    )

    get(
      "/Admin/change/management/role/maintainence",
      SystemManagementController,
      :role_maintianence
    )

    post("/Create/New/User/Roles", SystemManagementController, :create_user_role)
    get("/Create/New/User/Roles", SystemManagementController, :create_user_role)
    post("/Admin/edit/User/role", SystemManagementController, :edit_user_roles)
    get("/Admin/edit/User/role", SystemManagementController, :edit_user_roles)
    get("/Admin/view/User/role", SystemManagementController, :view_user_roles)
    post("/change/user/role/status", SystemManagementController, :change_status)
    get("/change/user/role/status", SystemManagementController, :change_status)
    post("/update/user/role", SystemManagementController, :update)
    get("/update/user/role", SystemManagementController, :update)

    get(
      "/Admin/change/management/role/maintainence/add_description",
      SystemManagementController,
      :add_description
    )

    post(
      "/Admin/change/management/role/maintainence/add_description",
      SystemManagementController,
      :add_description
    )

    get(
      "/Admin/change/management/role/maintainence/activate",
      SystemManagementController,
      :activate_role_description
    )

    post(
      "/Admin/change/management/role/maintainence/activate",
      SystemManagementController,
      :activate_role_description
    )

    post(
      "/Admin/change/management/role/maintainence/disable",
      SystemManagementController,
      :disable_role_description
    )

    post(
      "/Admin/change/management/create/maker/checker",
      SystemManagementController,
      :configure_maker_checker
    )

    post(
      "/Admin/change/management/edit/maker/checker",
      SystemManagementController,
      :edit_maker_checker
    )

    get(
      "/Admin/change/management/charge/maintenance",
      SystemManagementController,
      :charge_maintenance
    )

    post(
      "/Admin/change/management/add/charge/",
      SystemManagementController,
      :add_charge
    )

    get(
      "/Admin/change/management/add/charge/",
      SystemManagementController,
      :add_charge
    )

    post(
      "/Admin/change/management/update/charge/",
      SystemManagementController,
      :update_charge
    )

    get(
      "/Admin/change/management/commission/maintenance",
      SystemManagementController,
      :commission_maintenance
    )

    get(
      "/Admin/change/management/department/maintainence",
      OrganizationManagementController,
      :admin_department
    )

    get(
      "/Admin/change/management/role/permision/maintainence",
      SystemManagementController,
      :role_permision_maintianence
    )

    get(
      "/Admin/change/management/country/maintainence",
      SystemManagementController,
      :countries
    )

    post(
      "/Admin/change/management/country/bulk/upload",
      SystemManagementController,
      :handle__country_bulk_upload
    )

    get(
      "/Admin/change/management/province/maintainence",
      SystemManagementController,
      :province
    )

    get(
      "/Admin/change/management/town/maintainence",
      SystemManagementController,
      :district
    )

    get(
      "/Admin/change/management/maker/checker/configuration",
      SystemManagementController,
      :maker_checker_configuration
    )

    get(
      "/Admin/change/management/report/maintainence",
      SystemManagementController,
      :report_maintianence
    )

    get(
      "/Admin/change/management/global/configuration",
      SystemManagementController,
      :global_configurations
    )

    get(
      "/Admin/change/management/account/number/generation",
      SystemManagementController,
      :account_number_generation
    )

    get(
      "/Admin/change/management/external/service/configuration",
      SystemManagementController,
      :external_service_configuration
    )

    get("/Admin/change/management/audit/trail", SystemManagementController, :audit_trail)

    # ---------------------------------------End of System Management---------------------------------------

    # -----------------------------------------Start of Organization Mangement -----------------------------------------
    get(
      "/Admin/change/maintain/employee/maintainence",
      OrganizationManagementController,
      :change_mgt_employee_maintainence
    )

    get(
      "/Admin/change/maintain/employee/maintainence/make",
      OrganizationManagementController,
      :view_qfin_add_employee
    )

    get(
      "/Admin/maintenance/department/activate",
      OrganizationManagementController,
      :admin_activate_department
    )

    post(
      "/Admin/maintenance/department/activate",
      OrganizationManagementController,
      :admin_activate_department
    )

    get(
      "/Admin/change/management/currency/create",
      OrganizationManagementController,
      :admin_create_currency
    )

    post(
      "/Admin/change/management/currency/create",
      OrganizationManagementController,
      :admin_create_currency
    )

    get(
      "/Admin/maintenance/department/deactivate",
      OrganizationManagementController,
      :admin_deactivate_department
    )

    post(
      "/Admin/maintenance/department/deactivate",
      OrganizationManagementController,
      :admin_deactivate_department
    )

    get(
      "/Admin/maintenance/alert/deactivate",
      OrganizationManagementController,
      :admin_deactivate_alert_amintenance
    )

    post(
      "/Admin/maintenance/alert/deactivate",
      OrganizationManagementController,
      :admin_deactivate_alert_amintenance
    )

    get(
      "/Admin/maintenance/sms/activate",
      OrganizationManagementController,
      :admin_message_resend
    )

    post(
      "/Admin/maintenance/sms/activate",
      OrganizationManagementController,
      :admin_message_resend
    )

    get(
      "/Admin/maintenance/alert/activate",
      OrganizationManagementController,
      :admin_activate_alert_amintenance
    )

    post(
      "/Admin/maintenance/alert/activate",
      OrganizationManagementController,
      :admin_activate_alert_amintenance
    )

    get(
      "admin/change/management/operation/management/departments/create",
      OrganizationManagementController,
      :admin_add_department
    )

    post(
      "admin/change/management/operation/management/departments/create",
      OrganizationManagementController,
      :admin_add_department
    )

    get(
      "admin/change/management/operation/management/provisioning/criteria",
      OrganizationManagementController,
      :add_provisioning_criteria
    )

    post(
      "admin/change/management/operation/management/provisioning/criteria",
      OrganizationManagementController,
      :add_provisioning_criteria
    )

    get(
      "admin/change/management/operation/management/alert/maintain",
      OrganizationManagementController,
      :add_alert_maintenance
    )

    post(
      "admin/change/management/operation/management/alert/maintain",
      OrganizationManagementController,
      :add_alert_maintenance
    )

    get(
      "admin/change/management/operation/management/departments/update",
      OrganizationManagementController,
      :admin_update_department
    )

    post(
      "admin/change/management/operation/management/departments/update",
      OrganizationManagementController,
      :admin_update_department
    )

    get(
      "/Admin/change/management/holiday/maintainence",
      OrganizationManagementController,
      :holiday_maintianance
    )

    get(
      "/Admin/change/management/password/management",
      OrganizationManagementController,
      :password_maintianance
    )

    get(
      "/Admin/change/management/loan/provisioning/definition",
      OrganizationManagementController,
      :loan_provisioning_definition
    )

    get(
      "/Admin/change/management/currency/maintainence",
      OrganizationManagementController,
      :currency_maintianance
    )

    get(
      "/Admin/change/management/bulk/loan/reassignment",
      OrganizationManagementController,
      :bulk_loan_reassignment
    )

    get(
      "/Admin/change/management/bulk/loan/reassignment/by/crms",
      OrganizationManagementController,
      :admin_bulk_re_assignment
    )

    get(
      "/Admin/change/management/bulk/loan/reassignment/by/crm",
      OrganizationManagementController,
      :admin_client_crm_re_assignment_bulk
    )

    post(
      "/Admin/change/management/bulk/loan/reassignment/by/crm",
      OrganizationManagementController,
      :admin_client_crm_re_assignment_bulk
    )

    get(
      "/Admin/change/management/working/day/maintainence",
      OrganizationManagementController,
      :working_day_maintianance
    )

    get("/Admin/change/management/bulk/import", OrganizationManagementController, :bulk_import)

    get(
      "/Admin/change/management/payment/type/maintainence",
      OrganizationManagementController,
      :payment_type_maintianance
    )

    get(
      "/Admin/change/management/collection/maintainence",
      OrganizationManagementController,
      :collection_maintianance
    )

    get(
      "admin/change/management/operation/management/collection/create",
      OrganizationManagementController,
      :add_collection_type
    )

    post(
      "admin/change/management/operation/management/collection/create",
      OrganizationManagementController,
      :add_collection_type
    )

    get(
      "admin/change/management/operation/management/collection/update",
      OrganizationManagementController,
      :update_collection_type
    )

    post(
      "admin/change/management/operation/management/collection/update",
      OrganizationManagementController,
      :update_collection_type
    )

    get(
      "admin/change/management/operation/management/payment/create",
      OrganizationManagementController,
      :add_payment_type_maintianance
    )

    post(
      "admin/change/management/operation/management/payment/create",
      OrganizationManagementController,
      :add_payment_type_maintianance
    )

    get(
      "admin/change/management/operation/management/payment/update",
      OrganizationManagementController,
      :update_payment_type_maintianance
    )

    post(
      "admin/change/management/operation/management/payment/update",
      OrganizationManagementController,
      :update_payment_type_maintianance
    )

    get(
      "/Admin/organization/management/branch",
      OrganizationManagementController,
      :qfin_branch_maintianance
    )

    get(
      "/Admin/organization/management/branch/create",
      OrganizationManagementController,
      :admin_qfin_add_branch
    )

    post(
      "/Admin/organization/management/branch/create",
      OrganizationManagementController,
      :admin_qfin_add_branch
    )

    get(
      "/Admin/organization/management/branch/update",
      OrganizationManagementController,
      :admin_qfin_update_branch
    )

    post(
      "/Admin/organization/management/branch/update",
      OrganizationManagementController,
      :admin_qfin_update_branch
    )

    get(
      "/Admin/organization/management/employee/create",
      OrganizationManagementController,
      :admin_qfin_employees
    )

    post(
      "/Admin/organization/management/employee/create",
      OrganizationManagementController,
      :admin_qfin_employees
    )

    get(
      "/Admin/organization/management/employee/update",
      OrganizationManagementController,
      :admin_qfin_update_employee
    )

    post(
      "/Admin/organization/management/employee/update",
      OrganizationManagementController,
      :admin_qfin_update_employee
    )

    get(
      "/Admin/organization/management/branch/activate",
      OrganizationManagementController,
      :admin_ofin_activate_branch
    )

    post(
      "/Admin/organization/management/branch/activate",
      OrganizationManagementController,
      :admin_ofin_activate_branch
    )

    get(
      "/Admin/organization/management/branch/deactivate",
      OrganizationManagementController,
      :admin_ofin_deactivate_branch
    )

    post(
      "/Admin/organization/management/branch/deactivate",
      OrganizationManagementController,
      :admin_ofin_deactivate_branch
    )

    # --------------------------------------------------end of organization management-----------------------------------------

    get("/Admin/view/system/users", UserController, :user_mgt)
    get("/Admin/view/system/Admin/users", UserController, :administartion_user_mgt)
    get("/Admin/view/all/products", ProductsController, :admin_all_products)
    # post("/Admin/view/all/products", ProductsController, :admin_all_products)
    get("/Admin/view/all/products/view", ProductsController, :admin_view_add_product)
    get("/Admin/view/pending/products", ProductsController, :pending_products)
    get("/Admin/view/inactive/products", ProductsController, :inactive_products)
    get("/Admin/view/all/products/create", ProductsController, :admin_add_product)
    post("/Admin/view/all/products/create", ProductsController, :admin_add_product)
    get("/Admin/get/all/indivduals/view", CustomersController, :individuals)
    get("/Admin/get/all/smes/view", CustomersController, :smes)
    post("/Admin/view/system/users/create", UserController, :admin_create_user)
    get("/Admin/view/system/users/create", UserController, :admin_create_user)
    post("/product/over/counter/charge/lookup", ProductsController, :oct_product_charge_lookup)
    post("/Admin/view/system/Admin/users/create", UserController, :admin_create_adiministartive_user)
    get("/Admin/view/system/Admin/users/create", UserController,:admin_create_adiministartive_user)
    post("/Admin/change/management/province/bulk/upload",MaintenanceController, :handle__province_bulk_upload)
    get("/Admin/maintain/msg/configure/create", MaintenanceController, :admin_add_msg_configuration)
    post("/Admin/Maintain/msg/configure/create", MaintenanceController, :admin_add_msg_configuration)
    get("/Admin/maintain/msg/configure/update", MaintenanceController, :admin_update_msg_configuration)
    post("/Admin/maintain/msg/configure/update", MaintenanceController, :admin_update_msg_configuration)
    get("/Admin/maintain/msg/configure/activate", MaintenanceController, :admin_activate_msg_config)
    post("/Admin/maintain/msg/configure/activate", MaintenanceController, :admin_activate_msg_config)
    get("/Admin/maintain/msg/configure/deactivate", MaintenanceController, :admin_deactivate_msg_config)
    post("/Admin/maintain/msg/configure/deactivate", MaintenanceController, :admin_deactivate_msg_config)

    # get("/Admin/loans/all", MaintenanceController ,:loans)
    # get("/Admin/loans/pending", MaintenanceController ,:pending_loans)
    # get("/Admin/loans/tracking", MaintenanceController ,:tracking_loans)
    # get("/Admin/loans/disbursed", MaintenanceController ,:disbursed_loans)
    # get("/Admin/loans/outstanding", MaintenanceController ,:outstanding_loans)
    # get("/Admin/loans/returnedoff", MaintenanceController ,:return_off_loans)
    get("/Admin/maintenance/charges", MaintenanceController, :charges)

    get("/Admin/maintenance/charges/create", MaintenanceController, :add_charge)
    post("/Admin/maintenance/charges/create", MaintenanceController, :add_charge)

    get("/Admin/maintenance/charges/update", MaintenanceController, :update_charge)
    post("/Admin/maintenance/charges/update", MaintenanceController, :update_charge)

    post("/Admin/view/system/users/class", UserController, :admin_update_user_classification)
    get("/Admin/view/system/users/class", UserController, :admin_update_user_classification)


    get("/Admin/get/fixed/deposits/reports", ReportsController, :fixed_deposits_reports)
    get("/Admin/get/all/divestment/report", ReportsController, :divestment_reports)
    get("/Admin/get/all/transaction/report", ReportsController, :transaction_reports)
    get("/Admin/get/all/loans", ReportsController, :all_loans)
    get("/Admin/get/disbursed/loans", ReportsController, :disbursements)
    get("/Admin/get/daily/disbursments", ReportsController, :daily_disbursements)
    post("/Admin/get/daily/disbursments",ReportsController, :daily_disbursements_lookup)
    get("/Admin/get/outstanding/loan/balance",ReportsController ,:outstanding_loan_balance)
    get("/Admin/get/repayment/listing/",ReportsController ,:repayment_listing)
    get("/Admin/get/expected/repayment/",ReportsController ,:expected_repayment_report)
    get("/Admin/get/last/installment/overpayment",ReportsController, :last_installmemet_overpayment)
    post("/Admin/get/last/installment/overpayment",ReportsController, :last_installmemet_overpayment_lookup)
    post("/Admin/get/loans/lookup", ReportsController, :all_loans_item_lookup)
    post("/Admin/disbursed/loans/lookup", ReportsController, :disbursed_loans_item_lookup)
    post("/Admin/outstanding/loans/balance/lookup", ReportsController, :outstanding_loan_balance_item_lookup)
    post("/Admin/repayment/loans/listing/lookup", ReportsController, :repayment_listing_item_lookup)

    post("/Admin/get/expected/repayment", ReportsController, :expected_repayments_item_lookup)
    post("/Admin/get/customer/lookup", ReportsController, :all_customers_item_lookup)
    get("/Admin/get/repayment/writeoff",ReportsController, :repayment_from_writeoff)
    post("/Admin/get/repayment/writeoff",ReportsController, :repayment_from_writeoff_lookup)
    get("/Admin/get/writtenoff/loans/report",ReportsController, :written_off_loan_report)
    post("/Admin/get/writtenoff/loans/report",ReportsController, :written_off_loan_report_lookup)
    post("/writeoff/loans",LoanController, :writeoff_loan)
    get("/Admin/get/arrears/loans/report",ReportsController, :arrears_report)
    post("/Admin/get/arrears/loans/report",ReportsController, :arrears_loan_report_lookup)
    get("/Admin/get/cashflow/statement/report",ReportsController, :cashflow_statement)
    post("/Admin/get/cashflow/statement/report",ReportsController, :cashflow_statement_report_lookup)
    get("/Admin/get/finacial/position/report",ReportsController, :financial_position)
    get("/Admin/get/daily/deliquency/report", ReportsController, :daily_deliquency)
    post("/Admin/get/daily/deliquency/report", ReportsController, :daily_deliquency_lookup)
    post("/Admin/change/management/audit/trail", SystemManagementController, :user_activity_listing_item_lookup)



    get("/Admin/get/all/customer/report", ReportsController, :customer_reports)
    post("/balance/sheet/report", ReportsController, :balancesheet_lookup)
    get("/balance/sheet/report", ReportsController, :balance_sheet)
    get("/income/statement/report", ReportsController, :income_statement)
    post("/income/statement/report", ReportsController, :income_statement_lookup)
    get("/trial/balance/report", ReportsController, :trial_balance)
    post("/trial/balance/report", ReportsController, :trial_balance_lookup)
    get("/general/ledger/report", ReportsController, :general_ledger)
    post("/general/ledger/report", ReportsController, :general_ledger_lookup)

    get("/Admin/view/my/profile", UserController, :my_profile)
    get("/Admin/maintenance/branch", MaintenanceController, :loans_branch)
    get("/Admin/maintenance/bank", MaintenanceController, :bank)
    get("/Admin/maintenance/classification", MaintenanceController, :classification)
    get("/Admin/maintenance/classification/create", MaintenanceController, :create_classification)

    get("/Admin/active/loans/summary", ReportsController, :active_loans_summary)
    post("/active/loans/sol_brunch/report", ReportsController, :loan_sol_brunch_lookup)

    get("/Admin/active/loans/employer", ReportsController, :active_loans_employer)
    post("/active/loans/employer/report", ReportsController, :active_loans_employer_lookup)
    get("/Admin/all/customers/list", ReportsController, :all_individuals_employees)
    get("/admin/active/loans/emoney", ReportsController, :active_loans_emoney)
    post("/active/loans/e_money/report", ReportsController, :active_loans_emoney_lookup)

    get("/Admin/active/loans/corporate", ReportsController, :active_loans_corporate)
    post("/active/loans/corporate_buyer/report", ReportsController, :active_loans_corporate_buyer_lookup)

    get("/Admin/active/loans/product", ReportsController, :active_loans_product)
    post("/active/loans/product/report", ReportsController, :active_loans_product_lookup)

    get("/Admin/active/loans/relationship", ReportsController, :active_loans_relationship)

    get("/Admin/active/loans/installment", ReportsController, :active_loans_installment)

    get("/Admin/client/summary", ReportsController, :client_summary)
    post("/active/loans/client/summary/report", ReportsController, :loan_client_summary_lookup)

    get("/Admin/employer/collection/schedule", ReportsController, :employer_collection_schedule)
    post("/loans/employer/collection/report", ReportsController, :loans_employer_collection_lookup)

    get("/Admin/corporate/collection/schedule", ReportsController, :corporate_collection_schedule)
    post("/loans/corporate_buyer/collection/report", ReportsController, :loans_corporate_buyer_collection_lookup)

    get("/Admin/market/collection/schedule", ReportsController, :market_collection_schedule)

    get("/Admin/offtaker/information", ReportsController, :offtaker_information)
    post("/active/loans/off/taker/report", ReportsController, :loan_offtaker_lookup)

    get("/Admin/balance/outstanding", ReportsController, :balance_outstanding)
    post("/loans/outstanding/balance/report", ReportsController, :loan_balance_lookup)

    get("/Admin/written/off/loans", ReportsController, :written_off_loans)

    get("/Admin/loans/past/due", ReportsController, :loans_past_due)

    get("/Admin/awaiting/disbursement", ReportsController, :awaiting_disbursement)
    post("/active/loans/awaiting/disbursement/report", ReportsController, :loan_waiting_disbursement_lookup)

    get("/Admin/pending/approval", ReportsController, :pending_approval)
    post("/active/loans/pending/approval/report", ReportsController, :loan_pending_approval_lookup)

    get("/Admin/balance/outstanding/source/funds", ReportsController, :source_of_funds)

    get("/Admin/service/out_let", ReportsController, :service_out_let)

    get("/Admin/due_vs_collected/employer", ReportsController, :dv_employer)
    post("/loans/due/v_collected/report", ReportsController, :active_loans_dvc_employer_lookup)

    get("/Admin/due_vs_collected/e_money", ReportsController, :dv_emoney)
    post("/loans/due/v_collected/e_money/report", ReportsController, :active_loans_dvc_emoney_lookup)

    get("/Admin/due_vs_collected/corporate_buyer", ReportsController, :dv_corporate_buyer)
    post("/loans/due/v_collected/corporate_buyer/report", ReportsController, :active_loans_dvc_corporate_lookup)

    get("/Admin/due_vs_collected/relationship/manager", ReportsController, :dv_relationship_manager)

    get("/Admin/loan/classification", ReportsController, :loan_classification)
    post("/loans/classification/product/report", ReportsController, :loan_classification_product_lookup)

    get("/Admin/consultant/transaction/detaild", ReportsController, :consultant_transaction_detailed)

    get("/Admin/consultant/transaction/summary", ReportsController, :consultant_transaction_summary)

    get("/Admin/performance/summary", ReportsController, :performance_summary)

    get("/Admin/loan/aiging/report", ReportsController, :loan_aiging_report)

    get("/Admin/aiging/summary", ReportsController, :aiging_summary)

    get("/Admin/clossed/loans", ReportsController, :clossed_loans)

    get("/Admin/clossed/loan/summary/sol", ReportsController, :clossed_loan_summary_sol)

    get("/Admin/clossed/loan/summary/rm", ReportsController, :clossed_loan_summary_rm)

    get("/Admin/inactive/clients", ReportsController, :inactive_clients)
    get("/Admin/funds/movement", ReportsController, :funds_movement)
    get("/Admin/mfi/progress", ReportsController, :mfi_progress)
    get("/Admin/collection/summary", ReportsController, :collection_summary)

    get("/generate/client/loan/statement", PageController, :loan_statement)
    post("/generate/client/loan/statement", PageController, :loan_statement_lookup)
    get("/download/loan/statement/pdf/gnc", PageController, :loan_statementpdf_exp)

    post("/Admin/maintenance/classification/create", MaintenanceController, :create_classification)
    get("/Admin/maintenance/classification/update", MaintenanceController, :update_classification)
    post("/Admin/maintenance/classification/update", MaintenanceController, :update_classification)
    get("/Admin/maintenance/classification/activate", MaintenanceController,:admin_activate_classification)
    post("/Admin/maintenance/classification/activate",MaintenanceController, :admin_activate_classification)
    get("/Admin/maintenance/classification/deactivate", MaintenanceController, :admin_deactivate_classification)
    post("/Admin/maintenance/classification/deactivate", MaintenanceController, :admin_deactivate_classification)

    get("/Admin/maintenance/bank/create", MaintenanceController, :create_bank)
    post("/Admin/maintenance/bank/create", MaintenanceController, :create_bank)

    get("/Admin/maintenance/bank/update", MaintenanceController, :update_bank)
    post("/Admin/maintenance/bank/update", MaintenanceController, :update_bank)

    # get("/Admin/maintenance/bank/activate", MaintenanceController, :admin_activate_bank)
    post("/Admin/bank/maintenance/activate", MaintenanceController, :admin_activate_bank)
    # get("/Admin/maintenance/bank/deactivate", MaintenanceController, :admin_deactivate_bank)
    post("/Admin/bank/maintenance/deactivate", MaintenanceController, :admin_deactivate_bank)

    get("/Admin/maintenance/branch/activate", MaintenanceController, :admin_activate_branch)
    post("/Admin/maintenance/branch/activate", MaintenanceController, :admin_activate_branch)
    get("/Admin/maintenance/branch/deactivate", MaintenanceController, :admin_deactivate_branch)
    post("/Admin/maintenance/branch/deactivate", MaintenanceController, :admin_deactivate_branch)

    post("/Generate/Random/Password/user", UserController, :generate_random_password)
    get("/Generate/Random/Password/user", UserController, :generate_random_password)
    post("/Admin/maintain/countries/update", MaintenanceController, :admin_update_country)
    get("/Admin/maintain/countries/update", MaintenanceController, :admin_update_country)
    get("/Admin/maintain/province/update", MaintenanceController, :admin_update_province)
    post("/Admin/maintain/province/update", MaintenanceController, :admin_update_province)
    get("/Admin/over/counter/", CustomersController, :otc)
    get("/Admin/over/counter/list", CustomersController, :otc_logs)
    get("/Admin/over/counter/repayment", CustomersController, :admin_loan_repayment)
    post("/cutomer/over/counter/lookup", CustomersController, :oct_customer_lookup)
    post("/product/over/counter/lookup", CustomersController, :oct_product_lookup)
    post("/oct/loan/application/form", CustomersController, :oct_loan_application)
    get("/oct/loan/application/form", CustomersController, :oct_loan_application)
    get("/Admin/maintenance/branch/create", MaintenanceController, :admin_add_branch)
    post("/Admin/maintenance/branch/create", MaintenanceController, :admin_add_branch)
    get("/Admin/maintenance/branch/update", MaintenanceController, :admin_update_branch)
    post("/Admin/maintenance/branch/update", MaintenanceController, :admin_update_branch)

    get("/Admin/maintain/district/update", MaintenanceController, :admin_update_district)
    post("/Admin/maintain/district/update", MaintenanceController, :admin_update_district)
    get("/Admin/maintain/currency/update", MaintenanceController, :admin_update_currency)
    post("/Admin/maintain/currency/update", MaintenanceController, :admin_update_currency)

    get(
      "/Admin/maintain/security_questions/update",
      MaintenanceController,
      :admin_update_security_question
    )

    post(
      "/Admin/maintain/security_questions/update",
      MaintenanceController,
      :admin_update_security_question
    )

    get("/chart/of/accounts", ChartOfAccountsController, :chart_of_accounts)
    post("/chart/of/accounts", ChartOfAccountsController, :chart_of_accounts_item_lookup)

    post(
      "/chart/of/accounts/bulkupload",
      ChartOfAccountsController,
      :handle_chart_of_account_bulk_upload
    )

    post(
      "/create/general/ledger/account",
      ChartOfAccountsController,
      :create_general_ledger_account
    )

    post(
      "/authorise/general/ledger/account",
      ChartOfAccountsController,
      :authorise_general_ledger_account
    )

    post("/edit/general/ledger/account", ChartOfAccountsController, :edit_general_ledger_account)

    get("/jounal/entry", CoreTransactionController, :create_journal_entries_batch_no_screen)
    post("/create/batch/number", CoreTransactionController, :create_batch)
    get("/list/jounal/entries", CoreTransactionController, :journal_entries_datatable)
    get("/journal/entry/data/capture", CoreTransactionController, :journal_entry_data_capture)
    post("/post/double/entries", CoreTransactionController, :post_double_entries_in_trans_log)
    post("/close/batch", CoreTransactionController, :close_batch)
    post("/cancle/batch", CoreTransactionController, :cancle_batch)
    get("/recall/batch/entries", CoreTransactionController, :recall_batch_entries)
    post("/recall/batch", CoreTransactionController, :recall_batch)
    get("/reassign/batch/entries", CoreTransactionController, :reassign_batch)
    post("/last/batch/usr/lookup", CoreTransactionController, :last_batch_usr)
    post("/assign/batch/last/usr", CoreTransactionController, :change_last_btch_usr)
    get("/assign/batch/last/usr", CoreTransactionController, :change_last_btch_usr)
    get("/single/journal/entry/data/capture", CoreTransactionController, :journal_entry_single_data_entry)
    post "/account/number/lookup/details", CoreTransactionController, :account_number_lookup
    post "/post/single/journal/entry", CoreTransactionController, :post_single_entry_in_trans_log
    get("/journal/entry/bulkupload", CoreTransactionController, :journal_entry_bulkupload)
    post("/journal/entry/bulkupload", CoreTransactionController, :bulk_journalentry_upload)

    get(
      "/authorised/jounal/entries/batch",
      CoreTransactionController,
      :select_journal_entry_batch_to_authorise
    )

    get(
      "/authorise/jounal/entries",
      CoreTransactionController,
      :journal_entries_authorise_datatable
    )

    post("/authorize/batch", CoreTransactionController, :authorize_batch)
    post("/discard/batch", CoreTransactionController, :discard_batch)

    # get("/Change/password", UserController, :change_password)
    get("/Admin/view/system/users/update", UserController, :admin_update_user)
    post("/Admin/view/system/users/update", UserController, :admin_update_user)
    get("/Admin/view/system/users/activate", UserController, :admin_activate_user)
    post("/Admin/view/system/users/activate", UserController, :admin_activate_user)

    get(
      "/Admin/view/system/users/individual/activate",
      UserController,
      :admin_individual_activate_user
    )

    post(
      "/Admin/view/system/users/individual/activate",
      UserController,
      :admin_individual_activate_user
    )

    get(
      "/Admin/view/system/users/individual/deactivate",
      UserController,
      :admin_deactivate_user_individual
    )

    post(
      "/Admin/view/system/users/individual/deactivate",
      UserController,
      :admin_deactivate_user_individual
    )
    post("/Admin/users/change-status", UserController, :admin_change_user_status)
    get("/Admin/users/change-status", UserController, :admin_change_user_status)

    get("/Admin/view/system/users/deactivate", UserController, :admin_deactivate_user)
    post("/Admin/view/system/users/deactivate", UserController, :admin_deactivate_user)
    get("/Admin/view/all/products/update", ProductsController, :admin_update_product)
    post("/Admin/view/all/products/update", ProductsController, :admin_update_product)
    # get("/Admin/view/system/products/activate", ProductsController, :admin_activate_product)
    post("/Admin/system/products/activate", ProductsController, :admin_activate_product)
    # get("/Admin/view/system/products/deactivate", ProductsController, :admin_deactivate_product)
    post("/admin/system/products/deactivate", ProductsController, :admin_deactivate_product)

    # get("/Admin/view/system/company/activate", MaintenanceController, :admin_activate_company)
    post("/Admin/system/company/activate", MaintenanceController, :admin_activate_company)
    get("/Admin/view/system/company/deactivate", MaintenanceController, :admin_deactivate_company)

    post(
      "/Admin/view/system/company/deactivate",
      MaintenanceController,
      :admin_deactivate_company
    )

    post("/products/items/view", ProductsController, :product_item_lookup)
    post("/Admin/customer/loans/list", CustomersController, :customer_loan_item_lookup)
    post("/all/customer/loans/list", LoanController, :customer_loans_item_lookup)
    post("/client/write/off/loans/list", LoanController, :customer_loans_list_write_off)
    get("/client/write/off/loans/list", LoanController, :customer_loans_list_write_off)
    post("/Admin/write/off/client/loan", LoanController, :admin_write_off_loan)

    post(
      "/all/customer/loan/apraisals/list",
      CreditManagementController,
      :customer_loan_apraisals_item_lookup
    )

    post(
      "/Admin/change/management/district/bulk/upload",
      CreditManagementController,
      :handle__district_bulk_upload
    )

    post(
      "/all/customer/loan/user/list",
      OrganizationManagementController,
      :customer_loan_user_item_lookup
    )

    get(
      "/Admin/change/management/currency/update",
      OrganizationManagementController,
      :admin_update_currency
    )

    post(
      "/Admin/change/management/currency/update",
      OrganizationManagementController,
      :admin_update_currency
    )

    get(
      "/Admin/configure/sms",
      MaintenanceController,
      :admin_configure_sms
    )

    get(
      "/Admin/configure/sms/create",
      MaintenanceController,
      :admin_configure_add_sms
    )

    post(
      "/Admin/configure/sms/create",
      MaintenanceController,
      :admin_configure_add_sms
    )

    get(
      "/Admin/configure/sms/update",
      MaintenanceController,
      :admin_configure_update_sms
    )

    post(
      "/Admin/configure/sms/update",
      MaintenanceController,
      :admin_configure_update_sms
    )

    post("/Admin/pending/loans/list", LoanController, :customer_pending_item_lookup)
    post("/Admin/disbursed/loans/list", LoanController, :customer_disbursed_item_lookup)
    post("/Admin/products/selected/charge", ProductsController, :admin_charge_lookup)

    get("/Admin/loans/all", LoanController, :loans)
    get("/Admin/loans/pending", LoanController, :pending_loans)
    get("/Admin/loans/tracking", LoanController, :tracking_loans)
    get("/Admin/loans/disbursed", LoanController, :disbursed_loans)
    get("/Admin/loans/outstanding", LoanController, :outstanding_loans)
    get("/Admin/loans/returnedoff", LoanController, :return_off_loans)
    get("/Admin/quick/advance/loan/application", LoanController, :quick_advance_application)
    post("/Admin/quick/advance/loan/application", LoanController, :quick_advance_application)

    get("/Admin/select/loan/product", LoanController, :select_quick_advance)

    get("/Admin/get/quick/advance/otp", LoanController, :get_otp)
    post("/Admin/get/quick/advance/otp", LoanController, :get_otp)
    post("/send/loan/otp", LoanController, :send_otp)
    # get("/send/loan/otp", LoanController, :send_otp)
    get("/validate/loan/otp", LoanController, :otp_validation)
    post("/Admin/validate/loan/otp", LoanController, :validate_otp)
    get("/Admin/validate/loan/otp", LoanController, :validate_otp)



    get("/Admin/push/quick/advance/registration", LoanController, :quick_advanced_registration)
    post("/Admin/push/quick/advance/registration", LoanController, :quick_advanced_registration)

    get("/Admin/verify/quick/advance", SessionController, :otp_quick_advanced)

    get("/Admin/verify/quick/advance/otp", LoanController, :validate_quick_advance_otp)
    post("/Admin/verify/quick/advance/otp", LoanController, :validate_quick_advance_otp)



    post(
      "/create/universal/loan/application",
      LoanController,
      :create_universal_loan_application
    )
    get("/view/universal/loan/application", LoanController, :view_universal_loan_application)
    get("/edit/universal/loan/application", LoanController, :edit_universal_loan_application)
    post("/update/universal/loan/application", LoanController, :update_universal_loan_application)
    post("/update/reference/loan/application", LoanController, :update_loan_reference)
    post("/discard/reference/loan/application", LoanController, :discard_loan_reference)
    get("/discard/reference/loan/application", LoanController, :discard_loan_reference)
    post("/create/reference/loan/application", LoanController, :create_loan_reference)
    post("/update/collateral/loan/application", LoanController, :update_loan_collateral_details)
    post("/discard/collateral/loan/application", LoanController, :discard_loan_collateral)
    post("/create/collateral/loan/application", LoanController, :create_loan_collateral)
    get("/view/loan/application/pending/approval", LoanController, :view_before_approving_loan_application)
    get("/edit/loan/application/credit/analyst", LoanController, :edit_credit_analyst_loan_file_input)
    post("/credit/analyst/approve/loan/application", LoanController, :credit_analyst_loan_approval)
    get("/edit/rejected/universal/loan/application", LoanController, :edit_rejected_universal_loan_application)
    get("/pending/credit/manager/approval", LoanController, :credit_manager_approving_loan_application_view)
    post("/credit/manager/approve/loan/application", LoanController, :credit_manager_loan_approval)
    get("/pending/accounts/assistant/approval", LoanController, :accounts_assistant_approving_loan_application_view)
    post("/accounts/assistant/approve/loan/application", LoanController, :accounts_assistant_loan_approval)
    get("/pending/finance/manager/approval", LoanController, :finance_manager_approving_loan_application_view)
    post("/finance/manager/approve/loan/application", LoanController, :finance_manager_loan_approval)
    get("/pending/executive/committe/approval", LoanController, :executive_committe_approving_loan_application_view)
    post("/executive/committe/approve/loan/application", LoanController, :executive_committe_loan_approval)
    post("/create/instant/loan/application", LoanController, :create_instant_loan_application)
    post("/create/salarybacked/loan/application", LoanController, :create_salarybacked_loan_application)
    post("/update/salarybacked/loan/application", LoanController, :update_salarybacked_loan_application)
    get("/update/salarybacked/loan/application", LoanController, :update_salarybacked_loan_application)
    post("/update/credit/management/loan/application", LoanController, :update_credit_analyst_loan_application)
    get("/update/credit/management/loan/application", LoanController, :update_credit_analyst_loan_application)
    post("/upload/crb/report/credit/analyst", LoanController, :add_client_crb_documents)
    post("/update/instant/loan/application", LoanController, :update_instant_loan_application)
    get("/generate/loan/amortization", LoanController, :render_amortization)

    post("/loan/legal/documents", LoanController, :calculate_amortization)
    get("/loan/legal/documents", LoanController, :calculate_amortization)

    get("/pending/operations/application/approval", LoanController, :view_before_approving_loan_application_operations)

    post("/operations/loan/application/approval", LoanController, :operations_loan_approval)
    get("/operations/loan/application/approval", LoanController, :operations_loan_approval)

    post("/legal/loan/application/approval", LoanController, :legal_counsel_loan_approval)
    get("/legal/loan/application/approval", LoanController, :legal_counsel_loan_approval)

    get("/pending/legal/application/approval", LoanController, :legal_approving_loan_application_view)
    get("/pending/sales/application/approval", LoanController, :view_before_approving_loan_application_sales)

    post("/sales/loan/application/approval", LoanController, :sales_loan_approval)
    get("/sales/loan/application/approval", LoanController, :sales_loan_approval)












    post("/create/quick/loan/application", LoanController, :create_quick_loan_application)
    post("/create/float/advance/application", LoanController, :create_float_advance_application)
    post("/create/order/finance/application", LoanController, :create_order_finance_application)
    post("/create/trade/advance/application", LoanController, :create_trade_advance_application)

    post(
      "/create/invoice/discounting/application",
      LoanController,
      :create_invoice_discounting_application
    )

    # Activating a loan
    get("/Admin/loans/pending/disbursed", LoanController, :admin_disbursed_loan)
    post("/Admin/loans/pending/disbursed", LoanController, :admin_disbursed_loan)

    # writting off a loan pa status
    get("/Admin/loans/write-off", LoanController, :admin_write_off_loan)
    post("/Admin/loans/write-off", LoanController, :admin_write_off_loan)

    get("/Admin/audit/logs/user", MaintenanceController, :admin_user_logs)
    get("/Admin/audit/logs/ussd", MaintenanceController, :admin_ussd_logs)
    get("/Admin/audit/logs/email", MaintenanceController, :admin_email_logs)
    get("/Admin/audit/logs/sms", MaintenanceController, :admin_sms_logs)

    get(
      "/Customer/Relationship/Management/Leads",
      CustomerRelationshipManagementController,
      :leeds
    )

    get(
      "/Customer/Relationship/Management/Add_leads",
      CustomerRelationshipManagementController,
      :create_lead
    )

    post(
      "/Customer/Relationship/Management/Add_leads",
      CustomerRelationshipManagementController,
      :create_lead
    )

    post(
      "/Customer/Relationship/Management/activate_lead",
      CustomerRelationshipManagementController,
      :activate_lead
    )

    post(
      "/Customer/Relationship/Management/deactivate_lead",
      CustomerRelationshipManagementController,
      :deactivate_lead
    )

    get(
      "/Customer/Relationship/Management/update_lead",
      CustomerRelationshipManagementController,
      :update_lead
    )

    post(
      "/Customer/Relationship/Management/update_lead",
      CustomerRelationshipManagementController,
      :update_lead
    )

    post(
      "/Update/LeadCustomer/Relationship/Management/",
      CustomerRelationshipManagementController,
      :admin_update_lead
    )



    get(
      "/Customer/Relationship/Management",
      CustomerRelationshipManagementController,
      :customer_relation_management
    )

    get(
      "/Customer/Relationship/Management/proposal",
      CustomerRelationshipManagementController,
      :proposal
    )

    get(
      "/Customer/Relationship/Management/add_proposal",
      CustomerRelationshipManagementController,
      :add_proposal
    )

    post(
      "/Customer/Relationship/Management/add_proposal",
      CustomerRelationshipManagementController,
      :add_proposal
    )

    post(
      "/Customer/Relationship/Management/activate_proposal",
      CustomerRelationshipManagementController,
      :activate_proposal
    )

    post(
      "/Customer/Relationship/Management/deactivate_proposal",
      CustomerRelationshipManagementController,
      :deactivate_proposal
    )

    get(
      "/Customer/Relationship/Management/update_proposal",
      CustomerRelationshipManagementController,
      :update_proposal
    )

    post(
      "/Customer/Relationship/Management/update_proposal",
      CustomerRelationshipManagementController,
      :update_proposal
    )

    get(
      "/Customer/Relationship/Management/customer",
      CustomerRelationshipManagementController,
      :customer
    )

    get(
      "/Customer/Relationship/Management/contact",
      CustomerRelationshipManagementController,
      :contact
    )

    get(
      "/Customer/Relationship/Management/communication",
      CustomerRelationshipManagementController,
      :communication
    )

    get(
      "/Customer/Relationship/Management/appointment",
      CustomerRelationshipManagementController,
      :appointment
    )

    get(
      "/Customer/Relationship/Management/MOU/meeting_notes",
      CustomerRelationshipManagementController,
      :mou_meeting_notes
    )

    get(
      "/Customer/Relationship/Management/MOU/maintenance",
      CustomerRelationshipManagementController,
      :mou_maintenance
    )

    get(
      "/Customer/Relationship/Management/leeds_details",
      CustomerRelationshipManagementController,
      :leeds_details
    )

    get(
      "/Customer/Relationship/Management/sales_funnel",
      CustomerRelationshipManagementController,
      :sales_funnel
    )

    get(
      "/Customer/Relationship/Management/prospects_engaged",
      CustomerRelationshipManagementController,
      :prospects_engaged
    )

    get(
      "/Customer/Relationship/Management/innactive_customers",
      CustomerRelationshipManagementController,
      :innactive_customers
    )

    get(
      "/Customer/Relationship/Management/lead_owner_efficiency",
      CustomerRelationshipManagementController,
      :lead_owner_efficiency
    )

    get(
      "/Customer/Relationship/Management/customer_acquisition",
      CustomerRelationshipManagementController,
      :customer_acquisition
    )

    get(
      "/Customer/Relationship/Management/portfolio_analytics",
      CustomerRelationshipManagementController,
      :portfolio_analytics
    )

    get("/Admin/Client/Management/Employer-Maintenance", OfftakerManagementController, :employer_maintenance)

    get("/Admin/Management/create/employer_maintenance", OfftakerManagementController, :create_employer_maintenance)
    post("/Admin/Management/create/employer_maintenance", OfftakerManagementController, :create_employer_maintenance)
    get("/Admin/Create/Employer", OfftakerManagementController, :add_employer)
    post("/Admin/Create/Employer", OfftakerManagementController, :admin_create_employer_maintenance)
    post("/Admin/Management/update", OfftakerManagementController, :edit_company)


    get("/Admin/Client/Management/Create/SME", OfftakerManagementController, :create_sme_maintenance)
    post("/Admin/Client/Management/Create/SME", OfftakerManagementController, :create_sme_maintenance)
    get("/Admin/Client/Management/SME/Maintenance", OfftakerManagementController, :sme_maintenance)
    get("/Admin/Create/SME", OfftakerManagementController, :add_sme)
    post("/Admin/Create/SME", OfftakerManagementController, :add_sme)

    get("/Admin/Client/Management/Create/Offtaker", OfftakerManagementController, :create_offtaker_maintenance)
    post("/Admin/Client/Management/Create/Offtaker", OfftakerManagementController, :create_offtaker_maintenance)

    get("/Admin/Client/Management/Update/Offtaker", OfftakerManagementController, :update_offtaker_maintenance)
    post("/Admin/Client/Management/Update/Offtaker", OfftakerManagementController, :update_offtaker_maintenance)

    get("/Admin/Client/Management/Update/SME", OfftakerManagementController, :update_sme_maintenance)
    post("/Admin/Client/Management/Update/SME", OfftakerManagementController, :update_sme_maintenance)

    get("/Admin/Sme/view/document", OfftakerManagementController, :display_pdf)
    get("/Admin/Client/Management/Offtaker/Maintenance", OfftakerManagementController, :offtaker_maintenance)
    get("/Admin/Client/Management/Offtaker/Edit", OfftakerManagementController, :offtaker_edit_maintenance)
    get("/Admin/Client/Management/Employer/Edit", OfftakerManagementController, :employer_edit_maintenance)
    get("/Admin/Client/Management/SME/Edit", OfftakerManagementController, :sme_edit_maintenance)
    get("/Admin/Client/Management/Offtaker/View", OfftakerManagementController, :offtaker_view_maintenance)
    get("/Admin/Client/Management/Employer/View", OfftakerManagementController, :employer_view_maintenance)
    get("/Admin/Client/Management/SME/View", OfftakerManagementController, :sme_view_maintenance)
    get("/Admin/Client/Management/Offtaker/By/Id", OfftakerManagementController, :get_offtaker_by_company_id)
    get("/Admin/Client/Management/Employer/By/Id", OfftakerManagementController, :get_employer_by_company_id)
    get("/Admin/Client/Management/SME/By/Id", OfftakerManagementController, :get_sme_by_company_id)
    get("/Admin/Client/Management/360view", OfftakerManagementController, :cooperate_client_360_view)

    post("Admin/Client/Managemenet/SME/Update",OfftakerManagementController ,:admin_sme_update_user)
    get("/Admin/view/offtaker/users/change/status", OfftakerManagementController, :change_user_status)
    post("/Admin/view/offtaker/users/change/status", OfftakerManagementController, :change_user_status)

    get("/Admin/Client/Create/Offtaker", OfftakerManagementController, :add_offtaker)
    post("/Admin/Client/Create/Offtaker", OfftakerManagementController, :add_offtaker)

    get("/OffTaker/Management/corporate_buyer", OfftakerManagementController, :oil_marketing_company)
    get("/Credit/Management/employee_maintenance", OfftakerManagementController, :employee_maintenance)
    get("/Credit/Management/msme_maintenance", CreditManagementController, :msme_maintenance)
    get("/Credit/Management/client_transfer", CreditManagementController, :client_transfer)
    get("/Credit/Management/blacklist_client", CreditManagementController, :blacklist_client)

    get("/Credit/Management/quick_advance_application", LoanController, :quick_advance_application_datatable)
    post("/Credit/Management/quick_advance_application", LoanController, :quick_advance_loan_item_lookup)

    get("/Credit/Management/loan/application", LoanController, :universal_loan_application_capturing)
    get("/Credit/Management/quick_advance_application/view", LoanController, :view_loan_application)
    get("/Credit/Management/quick_advance_application/edit", LoanController, :edit_loan_application)

    post("/Credit/Management/reject/loan", LoanController, :reject_loan)
    get("/Credit/Management/approve/loan", LoanController, :approve_loan)
    post("/Credit/Management/approve/loan", LoanController, :approve_loan)
    post("/Credit/Management/repaid/loan", LoanController, :mark_has_repaid_loan)

    get("/Credit/Management/quick_loan_application",LoanController, :quick_loan_application_datatable)
    post("/Credit/Management/quick_loan_application", LoanController, :quick_loan_item_lookup)
    get("/Credit/Management/quick_loan_application/capturing", LoanController, :quick_loan_capturing)

    get("/Credit/Management/float_advance_application", LoanController, :float_advance_application_datatable)
    post("/Credit/Management/float_advance_application", LoanController, :float_advance_item_lookup)
    get("/Credit/Management/float_advance_application/capturing", LoanController, :float_advance_capturing)

    get("/Credit/Management/order_finance", LoanController, :order_finance_application_datatable)
    post("/Credit/Management/order_finance", LoanController, :order_finance_item_lookup)
    get("/Credit/Management/order_finance/capturing", LoanController, :order_finance_capturing)

    get("/Credit/Management/trade/advance", LoanController, :trade_advance_application_datatable)
    post("/Credit/Management/trade/advance", LoanController, :trade_advance_item_lookup)
    get("/Credit/Management/trade/advance/capturing", LoanController, :trade_advance_capturing)

    get(
      "/Credit/Management/invoice_discouting",
      LoanController,
      :invoice_discounting_application_datatable
    )

    post(
      "/Credit/Management/invoice_discouting",
      LoanController,
      :invoice_discounting_item_lookup
    )

    get(
      "/Credit/Management/invoice_discouting/capturing",
      LoanController,
      :invoice_discounting_capturing
    )

    get("/initiate/disbursement", LoanController, :payment_requisition_form)
    post("/create/loan/payment/requisition", LoanController, :create_loan_payment_requisition)
    post("/cfo/approve/loan/payment/requisition", LoanController, :cfo_approve_loan_payment_requisition)
    get("/cfo/loan/payment/requisition", LoanController, :cfo_payment_requisition_form)
    get("/ceo/loan/payment/requisition", LoanController, :ceo_payment_requisition_form)
    post("/upload/client/loan/documents", LoanController, :add_client_documents)
    post("/ceo/approve/loan/payment/requisition", LoanController, :ceo_approve_loan_payment_requisition)
    get("/Credit/Management/client/statement", LoanController, :loan_client_statement_datatable)
    post("/Credit/Management/client/statement", LoanController, :client_statement_item_lookup)
    post("/Credit/Management/reject/loan/application", LoanController, :reject_loan_application)
    get("/handle/loan/bulk/upload", LoanController, :loan_bulkupload)
    post("/handle/loan/bulk/upload", LoanController, :handle_loan_bulkupload)


    # -----------------------------------CLient Management-----------------------------------------------------
    get("/Credit/Management/clint_statements", CreditManagementController, :clint_statements)
    get("/Credit/Management/loan_appraisal", CreditManagementController, :loan_appraisal)
    post("/Credit/Management/loan_appraisal", CreditManagementController, :loan_appraisal_lookup)
    get("/Credit/Management/loan_approval_and_disbursements", CreditManagementController, :loan_approval_and_disbursements)
    get("/Credit/Management/loan_approval/user", CreditManagementController, :view_loan_apriasal)
    post("/Credit/Management/loan_approval_and_disbursements", CreditManagementController, :loan_approval_item_lookup)
    get("/admin/credit/management/loan_approval/update", CreditManagementController, :updating_loan_limit)
    post("/admin/credit/management/loan_approval/update", CreditManagementController, :updating_loan_limit)
    get("/Credit/Monitoring/loan_rescheduling", CreditMonitoringController, :loan_rescheduling)
    get("/Credit/Monitoring/loan/portifolio", CreditMonitoringController, :loan_portifolio)
    post("/Credit/Monitoring/loan/portifolio", CreditMonitoringController, :loan_portifolio_item_lookup)
    get("/Credit/Monitoring/loan/portfolio", CreditMonitoringController, :loan_portfolio)
    post("/Credit/Monitoring/loan/portfolio/items", CreditMonitoringController, :clients_loan_portfolio_item_lookup)
    get("/Credit/Monitoring/edit/loan_rescheduling", CreditMonitoringController, :edit_loan_details)
    post("/Credit/Monitoring/edit/loan_rescheduling", CreditMonitoringController, :edit_loan_details)
    get("/Credit/Monitoring/activate/loan_rescheduling", CreditMonitoringController, :activate_loan_reschedule)
    post("/Credit/Monitoring/activate/loan_rescheduling", CreditMonitoringController, :activate_loan_reschedule)
    get("/Credit/Monitoring/deactivate/loan_rescheduling", CreditMonitoringController, :deactivate_loan_reschedule)
    post("/Credit/Monitoring/deactivate/loan_rescheduling", CreditMonitoringController, :deactivate_loan_reschedule)
    get("/Credit/Monitoring/loan_write_offs", CreditMonitoringController, :loan_write_offs)
    get("/Credit/Management/debit_mandate_management", CreditManagementController, :debit_mandate_management)
    get("/Credit/Management/collection_schedule_generation", CreditManagementController, :collection_schedule_generation)
    get("/Credit/Management/repayment_maintenance", CreditManagementController, :repayment_maintenance)
    post("/Credit/Management/repayment_maintenance", CreditManagementController, :loan_repayment_item_lookup)

    # -----------------------------------CLient Management-----------------------------------------------------
    get("/Admin/Client/Maintain/SME/Maintainence", ClientManagementController, :employer_maintainence)
    get("/Admin/Client/Maintain/Employee/Maintainence", ClientManagementController, :client_maintainence)
    post("/Admin/Client/Maintain/Employee/Maintainence", ClientManagementController, :client_maintainence)
    get("/Admin/Client/Maintain/Add", ClientManagementController, :add_client)
    get("/Admin/Edit/Client/Employee", ClientManagementController, :edit_employee)
    get("/Admin/Client/Maintain/Individual", ClientManagementController, :edit_individual)
    get("/Admin/client/maintain/edit_client_employee", ClientManagementController, :edit_client_employee)
    post("/Admin/client/maintain/edit_client_employee", ClientManagementController, :edit_client_employee)
    get("/Admin/client/maintain/edit_client_individual", ClientManagementController, :edit_client_individual)
    post("/Admin/client/maintain/edit_client_individual", ClientManagementController, :edit_client_individual)
    get("/Admin/client/maintain/employee/create/client", ClientManagementController, :create_client_user)
    post("/Admin/client/maintain/employee/create/client", ClientManagementController, :create_client_user)
    # get("/Admin/client/maintain/activate_client", ClientManagementController, :activate_client)
    post("/admin/maintain/client/activate_client", ClientManagementController, :activate_client)
    # get("/Admin/client/maintain/deactivate_client", ClientManagementController, :deactivate_client)
    post("/admin/maintain/client/deactivate_client", ClientManagementController, :deactivate_client)
    get("/Admin/client/maintain/mobile/money/argent/maintainence", ClientManagementController, :mobile_money_argents)
    post("/Admin/add/momo/argent/maintainence", ClientManagementController, :admin_create_momo_agent)
    get("/Admin/add/momo/argent/maintainence", ClientManagementController, :admin_create_momo_agent)
    post("/Admin/add/momo/merchant/maintainence", ClientManagementController, :admin_create_merchant)
    get("/Admin/add/momo/merchant/maintainence", ClientManagementController, :admin_create_merchant)
    get("/Admin/client/maintain/client/relationship/managers", ClientManagementController, :client_managers_relationship)
    get("/Admin/client/maintain/blacklisted/client", ClientManagementController, :blacklisted_clients)
    get("/Admin/client/maintain/fuel/importer/maintenance", ClientManagementController, :fuel_importer_maintenance)
    get("/Admin/client/maintain/merchant/maintenance", ClientManagementController, :merchant_maintenance)
    get("/Admin/client/maintain/sme/maintainence/create", ClientManagementController, :admin_employer_maintainence)
    post("/Admin/client/maintain/sme/maintainence/create", ClientManagementController, :admin_employer_maintainence)
    post("/Admin/view/client/relation/managers", ClientManagementController, :client_relationship_manager_item_lookup)
    get("/Admin/view/client/relation/managers", ClientManagementController, :client_relationship_manager_item_lookup)
    post("/Admin/change/client/relation/managers", ClientManagementController, :change_client_manager)
    get("/Admin/change/client/relation/managers", ClientManagementController, :change_client_manager)
    post("/client/relation/managers/lookup", ClientManagementController, :client_manager_item_lookup)
    get("/client/relation/managers/lookup", ClientManagementController, :client_manager_item_lookup)
    post("/client/relation/managers/bulk/lookup", OrganizationManagementController, :client_manager_item_lookup)
    get("/client/relation/managers/bulk/lookup", OrganizationManagementController, :client_manager_item_lookup)
    get("/Admin/Client/360/view", ClientManagementController, :customer_360_view)
    get("/Admin/Client/Maintenance/Individual/maintainence", ClientManagementController, :individual_maintainence)
    post("/Admin/Client/Maintenance/Individual/maintainence", ClientManagementController, :individual_maintainence)
    get("/Admin/Client/Maintain/Add/Individual", ClientManagementController, :add_individual)
    get("/Admin/Client/Maintain/Individual/Client", ClientManagementController, :create_individual_user)
    post("/Admin/Client/Maintain/Individual/Client", ClientManagementController, :create_individual_user)
    get("/Admin/View/Individual/Details", ClientManagementController, :view_individual_details)
    post("/Admin/Client/employer/lookup", ClientManagementController, :employer_item_lookup)
    # get("/Admin/Company/Document/:path", ClientManagementController, :display_pdf)

    # get("/Admin/Loan/Individual/document/view", ClientManagementController,:get_individual_document_admin)
      get("/Admin/Loan/view/document", ClientManagementController, :display_pdf)
      post("/Admin/deactivate/client/document", ClientManagementController, :deactivate_client_document)
      post("/Admin/activate/client/document", ClientManagementController, :activate_client_document)
      get("/client/bulk/upload", ClientManagementController, :client_onboarding_upload)
      post("/client/bulk/upload", ClientManagementController, :handle_client_bulk_upload)
      post("/create/client/reference", ClientManagementController, :create_reference)
      post("/update/client/reference", ClientManagementController, :update_reference)
      get("/loan/bulk/upload/process", LoanbulkuploadController, :loan_application_upload)





    # -----------------------------------Financial Management------------------------
    get(
      "/Admin/financial/management/search/transaction",
      FinancialManagementController,
      :search_transaction
    )

    get(
      "/Admin/financial/management/frequent/posting",
      FinancialManagementController,
      :freqeunt_posting
    )

    get(
      "/Admin/financial/management/financial/activity/mapping",
      FinancialManagementController,
      :financial_activity_mapping
    )

    get(
      "/Admin/financial/management/fund/association",
      FinancialManagementController,
      :fund_association
    )

    get(
      "/Admin/financial/management/migrate/opening/balances",
      FinancialManagementController,
      :migrate_opening_balances
    )

    get("/Admin/financial/management/accruals", FinancialManagementController, :acruals)

    get(
      "/Admin/financial/management/provisioning/entries",
      FinancialManagementController,
      :provisioning_entries
    )

    get(
      "/Admin/financial/management/closing/entries",
      FinancialManagementController,
      :closing_entries
    )

    # -----------------------------------Organization Management------------------------
    get("/Admin/change/management/branch/maintainence", OrganizationManagementController, :branch_maintianance)
    post("/Admin/change/management/create/holiday", ChangeManagementController, :create_holiday)
    post("/Admin/change/management/approve/holiday", ChangeManagementController, :approve_holiday)
    post("/Admin/change/management/delete/holiday", ChangeManagementController, :delete_holiday)
    post("/Admin/change/management/update/holiday", ChangeManagementController, :update_holiday)

    get("/Admin/change/management/company/maintainence", ChangeManagementController, :company_maintainance)

    post(
      "/Admin/change/management/create/company",
      ChangeManagementController,
      :create_company_info
    )

    post(
      "/Admin/change/management/create/password/config",
      ChangeManagementController,
      :create_password_configuration
    )

    post(
      "/Admin/change/management/update/password/config",
      ChangeManagementController,
      :update_password_configuration
    )

    post(
      "/Admin/change/management/create/working/day/maintainence",
      ChangeManagementController,
      :create_working_days
    )

    post(
      "/Admin/change/management/update/working/day/maintainence",
      ChangeManagementController,
      :update_working_days
    )

    get("/Admin/change/management/alert/maintainence", OrganizationManagementController,:alert_maintianance)
    get("/Admin/change/management/sms/maintainence", OrganizationManagementController,:sms_maintainance)


    get(
      "/Admin/change/management/employee/maintainence",
      OrganizationManagementController,
      :employee_maintianence
    )

    # ---------------------------------Product Mangement-----------------------------------------
    get(
      "/Admin/change/management/tax/configuration",
      ChangeManagementController,
      :tax_configuration
    )

    get("/Admin/change/management/alert/template/maintainence", ChangeManagementController, :alert_template_maintainence)

    post("/Admin/Change/Management/Add/template/maintainence", ChangeManagementController, :admin_add_templete)
    get("/Admin/change/management/loyal/program/maintainence", ChangeManagementController, :loyal_program_maintainence)

    # ---------------------------------Branch Client Registration-----------------------------------------------------------

    get(
      "/Admin//branch/client/registration/step/final/address",
      BranchRegistrationController,
      :final_steps_of_registration
    )

    get(
      "/Admin//branch/client/registration/step/income/details",
      BranchRegistrationController,
      :branch_registration_income_details
    )

    get(
      "/Admin//branch/client/registration/step/bank/details",
      BranchRegistrationController,
      :branch_registration_bank_details
    )

    get(
      "/Admin/branch/client/registration",
      BranchRegistrationController,
      :customer_self_registration
    )

    post(
      "/Admin/branch/client/registration",
      BranchRegistrationController,
      :customer_self_registration
    )

    get(
      "/Admin/branch/client/registration/validate/otp",
      BranchRegistrationController,
      :otp_validation
    )

    get(
      "/Admin/branch/client/registration/validate/otp/post",
      BranchRegistrationController,
      :validate_otp
    )

    post(
      "/Admin/branch/client/registration/validate/otp/post",
      BranchRegistrationController,
      :validate_otp
    )

    get(
      "/Admin/branch/client/registration/step/two",
      BranchRegistrationController,
      :step_two_branch_registration
    )

    get(
      "/Admin/branch/registration/step/three",
      BranchRegistrationController,
      :step_three_user_registration
    )

    get(
      "/Admin/branch/client/registration/step/two/personal/details",
      BranchRegistrationController,
      :step_two_user_personal_details
    )

    post(
      "/Admin/branch/client/registration/step/two/personal/details",
      BranchRegistrationController,
      :step_two_user_personal_details
    )

    get(
      "/Admin/branch/client/registration/step/final/address/details",
      BranchRegistrationController,
      :admin_branch_registration_add_address_details
    )

    post(
      "/Admin/branch/client/registration/step/final/address/details",
      BranchRegistrationController,
      :admin_branch_registration_add_address_details
    )

    get(
      "/Admin/branch/client/registration/step/final/employment/details",
      BranchRegistrationController,
      :branch_registration_add_employment_details
    )

    post(
      "/Admin/branch/client/registration/step/final/employment/details",
      BranchRegistrationController,
      :branch_registration_add_employment_details
    )

    get(
      "/Admin/branch/client/registration/step/final/income/details",
      BranchRegistrationController,
      :branch_registration_income_details_addition
    )

    post(
      "/Admin/branch/client/registration/step/final/income/details",
      BranchRegistrationController,
      :branch_registration_income_details_addition
    )

    get(
      "/Admin//branch/client/registration/step/bank/details/create",
      BranchRegistrationController,
      :branch_registration_add_bank_details
    )

    post(
      "/Admin/branch/client/registration/step/bank/details/create",
      BranchRegistrationController,
      :branch_registration_add_bank_details
    )

    post(
      "/Admin/credit/operation/employee/lookup",
      ClientManagementController,
      :oct_company_lookup
    )

    get(
      "/Admin/branch/client/management/employer/employee/create",
      ClientManagementController,
      :admin_create_employer_employee
    )

    post(
      "/Admin/branch/client/management/employer/employee/create",
      ClientManagementController,
      :admin_create_employer_employee
    )

    get(
      "/Admin/admin/view/system/users/activate",
      ClientManagementController,
      :admin_activate_user
    )

    post(
      "/Admin/admin/view/system/users/activate",
      ClientManagementController,
      :admin_activate_user
    )

    get(
      "/Admin/admin/view/system/users/deactivate",
      ClientManagementController,
      :admin_deactivate_user
    )

    post(
      "/Admin/admin/view/system/users/deactivate",
      ClientManagementController,
      :admin_deactivate_user
    )

    get(
      "/Admin/credit/operations/client/management/msme/updae",
      ClientManagementController,
      :admin_update_employer_maintainence
    )

    post(
      "/Admin/credit/operations/client/management/msme/updae",
      ClientManagementController,
      :admin_update_employer_maintainence
    )
  end

  scope "/", LoanmanagementsystemWeb do
    pipe_through([:browser, :employer_app, :logged_in])
    get("/home/home", PageController, :index)

    get("/Employer/dashboard", UserController, :employer_dashboard)
    get("/Employer/get/all/loans", EmployerController, :employer_employee_all_loans)

    get("/Employer/get/all/distursed/loans", EmployerController,:employer_employee_disbursed_loans )

    get("/Employer/get/all/pending/loans", EmployerController, :employer_employee_pending_loans)
    get("/Employer/get/all/rejected/loans", EmployerController, :employer_employee_rejected_loans)
    get("/Employer/apply/loans", EmployerController, :employer_employee_loan_products)

    get("/Employer/Admin/get/all/loans", EmployerController, :employer_all_loans)
    get("/Employer/Admin/get/all/distursed/loans", EmployerController, :employer_disbursed_loans)
    get("/Employer/Admin/get/all/pending/loans", EmployerController, :employer_pending_loans)
    get("/Employer/Admin/get/all/rejected/loans", EmployerController, :employer_rejected_loans)

    get("/Employer/all/staffs/loans", EmployerController, :staff_all_loans)

    post("/Employer/all/staffs/loans/handle/bulk/upload",EmployerController,:handle_staff_bulk_upload)

    get("/Employer/all/admins/loans", EmployerController, :company_all_loans)
    get("/Employer/reports/", EmployerController, :employer_transaction_reports)

    post("/Employer/create/staffs", EmployerController, :employer_create_employee)
    get("/Employer/create/staffs", EmployerController, :employer_create_employee)
    get("/Employer/all/staffs", EmployerController, :all_staffs)
    get("/Employer/all/admins", EmployerController, :user_mgt)
    get("/Employer/Admin/user/logs", EmployerController, :employer_user_logs)
    # post("/employer/view/system/employee/create", EmployerController, :employer_create_employee)
    # get("/employer/view/system/employee/create", EmployerController, :employer_create_employee)
    post("/Generate/Random/Password/employee", EmployerController, :generate_random_password)
    get("/Generate/Random/Password/employee", EmployerController, :generate_random_password)

    post("/Employer/update/staffs", EmployerController, :employer_update_employee)
    get("/Employer/employer/activate/employee", EmployerController, :employer_activate_employee)
    post("/Employer/employer/activate/employee", EmployerController, :employer_activate_employee)
    post("/Admin/employer/deactivate/employee", EmployerController, :employer_deactivate_employee)
    get("/Admin/employer/deactivate/employee", EmployerController, :employer_deactivate_employee)
    post("/Admin/employer/Admin/employee", EmployerController, :employer_create_admin_employee)
    get("/Admin/employer/Admin/employee", EmployerController, :employer_create_admin_employee)

    post("/Admin/employer/deactivate/Admin/employee",EmployerController,:employer_deactivate_employee )

    get("/Admin/employer/deactivate/Admin/employee", EmployerController,:employer_deactivate_employee)

    post("/employer/get/all/employee/loans", EmployerController,:employer_employee_all_loans_list_item_lookup)

    post("/employer/get/all/pending/employee/loans", EmployerController, :employer_employee_pending_loans_list_item_lookup )

    post("/employer/get/all/rejected/employee/loans",EmployerController,:employer_employee_rejected_loans_list_item_lookup )

    post("/employer/get/all/transaction/employee/loans",EmployerController,:employer_employee_transaction_loans_list_item_lookup )

    post("/employer/get/all/disbursed/employee/loans", EmployerController,:employer_employee_disbursed_loans_list_item_lookup)
  end

  scope "/", LoanmanagementsystemWeb do
    pipe_through([:browser, :employee_app, :logged_in])

    get("/employee/dashboard", UserController, :employee_dashboard)
    get("/employee/get/all/loans", EmployeeController, :all_loans)


    get("/employee/get/loan/otp", EmployeeController, :get_otp)
    post("/employee/get/loan/otp", EmployeeController, :get_otp)
    post("/employee/send/loan/otp", EmployeeController, :send_otp)
    get("/employee/send/loan/otp", EmployeeController, :send_otp)
    get("/employee/validate/loan/otp", EmployeeController, :otp_validation)
    post("/employee/Admin/validate/loan/otp", EmployeeController, :validate_otp)
    get("/employee/Admin/validate/loan/otp", EmployeeController, :validate_otp)
    get("/Employee/Loan/Application", EmployeeController ,:employee_loan_application)

    get("/Employee/Loan/initiation", EmployeeController,:employee_loan_initiation)
    post("/Employee/Loan/initiation", EmployeeController,:employee_loan_initiation)


    get("/employee/get/all/distursed/loans", EmployeeController, :disbursed_loans)
    get("/employee/get/all/pending/loans", EmployeeController, :pending_loans)
    post("/employee/get/all/pending/loans/lookup",EmployeeController ,:pending_loans_item_lookup)

    post("/employee/get/all/tracking/loans/lookup",EmployeeController ,:tracking_loans_item_lookup)
    get("/employee/make/loan/payment", EmployeeController, :make_payment_view)
    get("/employee/make/loan/payment/view", EmployeeController, :make_payment_view_view)

    get("/employee/loan/tracker", EmployeeController, :loan_tracking)
    get("/employee/get/all/loans/products", EmployeeController, :loan_products)
    get("/employee/get/individual/loans/products", EmployeeController, :individual_loan_products)
    get("/employee/my/360/view", EmployeeController, :employee_profile)
    get("/employee/get/loans/mini/statement", EmployeeController, :employee_mini_statement)
    get("/employee/get/loans/all/statement", EmployeeController, :employee_full_statement)
    get("/my/loans/application", EmployeeController, :selected_loan_product)
    get("/employee/profile/update", EmployeeController, :employee_edit_my_profile_details)
    post("/employee/profile/update", EmployeeController, :employee_edit_my_profile_details)
    post("/submit/loan/application/", EmployeeController, :client_loan_application)
    get("/submit/loan/application/", EmployeeController, :client_loan_application)
    post("/update/my/details/", CustomersController, :update_user_data)
    get("/update/my/details/", CustomersController, :update_user_data)

    # get( "/employee/loan/application/quick_loan_application", EmployeeController,:quick_loan_application_employee)
    get(
      "/Employee/loan/application/quick_advance_application",
      EmployeeController,
      :quick_advance_application_employee
    )

    get(
      "/employee/loan/application/quick_loan_application",
      EmployeeController,
      :quick_loan_capturing
    )

    post(
      "/employee/loan/application/quick_loan_application/application",
      EmployeeController,
      :create_quick_loan_employee_application
    )

    get("/employee/loan/application/quick_loan_application/repayment", EmployeeController, :make_payements_employee)

    post(
      "/employee/loan/application/quick_loan_application/repayment",
      EmployeeController,
      :make_payements_employee
    )

    get("/employee/get/loan", EmployeeController, :sample)

    # Code Debugging starts here.

    get("/Admin/client/management/customer/category/", ClientManagementController, :customer_category )
  end

  scope "/", LoanmanagementsystemWeb do
    pipe_through([:browser, :individual_app, :logged_in])

    get("/Individual-Dashboard", UserController, :individual_dashboard)
    get("/Individual/Apply-For-Loan", IndividualController, :apply_for_loans)
    get("/Individual/Pending-Loans", IndividualController, :pending_loans)
    get("/Individual/Rejected-Loans", IndividualController, :rejected_loans)
    get("/Individual/Loan-Tracking", IndividualController, :loan_tracking)
    get("/Individual/Loan-Repayment", IndividualController, :repayment_loan)
    get("/Individual/Customer-360-View", IndividualController, :customer_360_view)
    get("/Individual/Mini-Statements", IndividualController, :mini_statements)
    # post("/Individual/Mini-Statements", ReportsController, :loan_statement_item_lookup)
    post("/Individual/Mini-Statements", ReportsController, :mini_statement_individuel_lookup)

    get("/Individual/Historic-Statements", IndividualController, :historic_statements)
    # post( "/Individual/Historic-Statements",ReportsController,:historic_loan_statement_item_lookup)
    post( "/Individual/Historic-Statements",ReportsController,:historical_statement_individuel_lookup)


    get("/download/loan/statement/pdf", ReportsController, :export_loan_statement_pdf)
    get("/Individual/Loan-Products", IndividualController, :loan_products)
    get("/Individual/Select/Loan", IndividualController, :select_loan_to_apply)
    get("/Individual/Loan-Products-Capturing", IndividualController, :loan_products_capturing)
    get("/Individual/Loan/Repayment", IndividualController, :loan_repayment_datatable)
    post("/Individual/Loan-Products/creation", IndividualController, :create_loan_application)

    post("/Individual/Loan/creation", IndividualController, :individual_instant_loan_application)


    get("/Create/Loan/Repayment", IndividualController, :create_loan_repayment_view)
    post("/Individual/Create/Loan/Repayment", IndividualController, :create_loan_repayment)
    post("/Individual/update/profile", IndividualController, :update_profile)
  end

  scope "/", LoanmanagementsystemWeb do
    pipe_through([:browser, :sme_app, :logged_in])

    get("/Sme-Dashboard", UserController, :sme_dashboard)

    get("/Sme/select/loan/product", SmeController, :select_loan)
    get("/Sme/apply/for/loans", SmeController, :sme_apply_for_loans)

    get("/Sme/view/pending/loans", SmeController, :sme_pending_loans)

    get("/Sme/repayment", SmeController, :sme_repayment)
    post("/Sme/repayment", SmeController, :sme_repayment)
    get("/Sme/repayment/make/repayment", SmeController, :make_repayment)
    post("/Sme/repayment/make/repayment", SmeController, :make_repayment)

    get("/Sme/loan/tracking", SmeController, :sme_loan_tracking)

    get("/Sme/Maintenance/off_taker", SmeController, :sme_off_taker)
    post("/Sme/Maintenance/off_taker", SmeController, :sme_offtaker_lookup)

    post("/Sme/Maintenance/off/taker", SmeController, :admin_register_offtaker)
    get("/Sme/Maintenance/off_taker/activate", SmeController, :sme_activate_offtaker)
    post("/Sme/Maintenance/off_taker/activate", SmeController, :sme_activate_offtaker)
    get("/Sme/Maintenance/off_taker/deactivate", SmeController, :sme_deactivate_offtaker)
    post("/Sme/Maintenance/off_taker/deactivate", SmeController, :sme_deactivate_offtaker)
    get("/Sme/Maintenance/off_taker/update", SmeController, :sme_update_offtaker)
    post("/Sme/Maintenance/off_taker/update", SmeController, :sme_update_offtaker)

    get("/Sme/sme/360/", SmeController, :sme_360)
    post("/Sme/update/360/profile/", SmeController, :sme_update_360_profile)
    get("/Sme/update/360/profile/", SmeController, :sme_update_360_profile)

    get("/Sme/Maintenance/company_documents", SmeController, :sme_company_documents)
    post("/Sme/Maintenance/company_documents/activate", SmeController, :sme_activate_document)
    get("/Sme/Maintenance/company_documents/activate", SmeController, :sme_activate_document)
    post("/Sme/Maintenance/company_documents/deactivate", SmeController, :sme_deactivate_document)
    get("/Sme/Maintenance/company_documents/deactivate", SmeController, :sme_deactivate_document)

    get("/Sme/Maintenance/upload/documents", SmeController, :run)
    post("/Sme/Maintenance/upload/documents", SmeController, :run)
    get("/Sme/view/document", SmeController, :display)

    get("/Sme/Maintenance/company_details", SmeController, :sme_company_details)
    post("/Sme/Maintenance/company_details/update", SmeController, :sme_update_company)
    get("/Sme/Maintenance/company_details/deactivate", SmeController, :sme_deactivate_company)
    post("/Sme/Maintenance/company_details/deactivate", SmeController, :sme_deactivate_company)
    get("/Sme/Maintenance/company_details/activate", SmeController, :sme_activate_company)
    post("/Sme/Maintenance/company_details/activate", SmeController, :sme_activate_company)

    get("/Sme/Maintenance/user_logs", SmeController, :sme_user_logs)

    get("/Sme/Maintenance/announcements", SmeController, :sme_announcements)

    get("/Sme/User/Management/user_profiles", SmeController, :sme_user_management)
    get("/Sme/User/Management/edit/user", SmeController, :admin_edit_user)
    post("/Sme/User/Management/edit/user", SmeController, :admin_edit_user)
    get("/Sme/view/system/users/activate", SmeController, :sme_activate_user)
    post("/Sme/view/system/users/activate", SmeController, :sme_activate_user)
    get("/Sme/view/system/users/deactivate", SmeController, :sme_deactivate_user)
    post("/Sme/view/system/users/deactivate", SmeController, :sme_deactivate_user)

    post("/Sme/User/Management/Admin/Create/User", SmeController, :create_user)

    get("/Sme/Reports/mini/statement", SmeController, :sme_mini_statement)
    post("/Sme/Reports/mini/statement", SmeController, :sme_statement_lookup)
    get("/Sme/Reports/mini/statement/activate", SmeController, :sme_activate_loan)
    post("/Sme/Reports/mini/statement/activate", SmeController, :sme_activate_loan)
    get("/Sme/Reports/mini/statement/deactivate", SmeController, :sme_deactivate_loan)
    post("/Sme/Reports/mini/statement/deactivate", SmeController, :sme_deactivate_loan)

    get("/Sme/Products/loan_products", SmeController, :sme_loan_product)
  end


  scope "/", LoanmanagementsystemWeb do
    pipe_through([:browser, :offtaker_app, :logged_in])
    get("/offtaker/dashboard", UserController, :offtaker_dashboard)

  end

  scope "/", LoanmanagementsystemWeb do
    pipe_through(:api)

    get("/ussd", UssdController, :initiateUssd)
    post("/ussd", UssdController, :initiateUssd)
    post("/mmoney/confirmation", UssdController, :handlePaymentConfirmation)
    post("/generate/pin", UssdController, :encrpt_pin)

    get("/Start/Bot", BotController, :initiateBot)
    get("/Customer/Bot/Balance", BotController, :handleAccountBalance)
  end

  scope "/", LoanmanagementsystemWeb do
    pipe_through([:browser, :no_layout])
    get("/emulator-ussd", UssdController, :index)
    get("/appusers", UssdController, :index)
  end

  scope "/", LoanmanagementsystemWeb.Api do
    pipe_through(:api)

    get("/Get/Ussd-users", UssdUsersController, :ussd_users)
    get("/Get/Application/Requirements", UssdUsersController, :application_requirements)
    post("/Add/Users", UssdUsersController, :loan_application)
  end

  scope "/Api", LoanmanagementsystemWeb do
    pipe_through :api
    match :*, "/V1/AuthenticationService/:service", AuthenticationController, :un_authentication


    pipe_through :user_auth_api
    match :*, "/V1/AuthenticationServices/:service", AuthenticationController, :authentication
    get "/list/products", ProductController, :list_loan_products
    get "/list/loans", LoanapiController, :list_all_customer_loans
    get "/loan/transaction", TransactionController, :list_customer_repayments
    post "/loan/application", LoanapiController, :loan_application
    get "/list/staff", LoanapiController, :list_company_staff
    post "/add/staff", LoanapiController, :list_company_staff




  end

  # Other scopes may use custom stacks. MIZ
  scope "/Api", LoanmanagementsystemWeb do
    pipe_through([:api, :user_auth_api])
    get("/V1/get/loans", LoanapiController, :get_loans_by_userid)
    get("/V1/get/loan/:loan_id", LoanapiController, :get_loan_by_loan_id)
    get("/V1/get/last/five/loans", LoanapiController, :get_last_five_loan_by_userid)
    get("/360/view/", LoanapiController ,:get_360_view_by_user_id)

    get("/mini/statement/", LoanapiController ,:get_mini_statement_by_user_id)
    get("/historical/statement/", LoanapiController ,:get_historical_statement_by_user_id)
    get("/Indivdual/Dashboard", LoanapiController ,:loan_counts_details)
    get("/get/customer/relationship/officer", LoanapiController ,:get_customer_relationship_officer)



    # Employee Api's
    get("/employee/dashboard", EmployeeApiController, :employee_dashboard)
    get("/employee/products", EmployeeApiController, :employee_loan_products)

    get("/employee/mini/statement", EmployeeApiController, :get_mini_statement_by_user_id)
    get("/employee/historical/statement", EmployeeApiController, :get_historical_statement_by_user_id)

    get("/employee/360/view", EmployeeApiController, :get_360_view_by_user_id)
  end

    # Other scopes may use custom stacks. MIZ







  #  END OF API'S

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
      pipe_through(:browser)
      live_dashboard("/dashboard", metrics: LoanmanagementsystemWeb.Telemetry)
    end
  end
end
