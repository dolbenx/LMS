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
    plug(LoanmanagementsystemWeb.Plugs.SessionTimeout, timeout_after_seconds: 300000)
  end

  pipeline :api do
    plug(:accepts, ["json"])
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

    get("/Login", SessionController, :new)
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

    post(
      "/Register/company/create/offtaker",
      MaintenanceController,
      :self_create_company_offtaker
    )

    get("/user/change/password", UserController, :new_password)

    post("/Cutomer/self/Register/individual", UserController, :customer_self_registration)
    get("/Cutomer/self/Register/individual", UserController, :customer_self_registration)
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
  end

  scope "/", LoanmanagementsystemWeb do
    pipe_through([:browser, :app, :logged_in])
    get("/home", PageController, :index)
    get("/admin/dashboard", UserController, :admin_dashboard)
    get("/admin/maintain/currency", MaintenanceController, :currency)
    get("/admin/maintain/security_questions", MaintenanceController, :security_questions)
    get("/admin/maintain/company", CustomersController, :company)
    get("/admin/maintain/offatker", CustomersController, :offtaker)
    post("/admin/maintain/countries/create", MaintenanceController, :admin_create_country)
    get("/admin/maintain/countries/create", MaintenanceController, :admin_create_country)
    get("/admin/maintain/currency/create", MaintenanceController, :admin_create_currency)
    post("/admin/maintain/currency/create", MaintenanceController, :admin_create_currency)
    get("/admin/maintain/province/create", MaintenanceController, :admin_create_province)
    post("/admin/maintain/province/create", MaintenanceController, :admin_create_province)
    get("/admin/maintain/district/create", MaintenanceController, :admin_create_district)
    post("/admin/maintain/district/create", MaintenanceController, :admin_create_district)

    get(
      "/admin/maintain/security_questions/create",
      MaintenanceController,
      :admin_create_security_questions
    )

    post(
      "/admin/maintain/security_questions/create",
      MaintenanceController,
      :admin_create_security_questions
    )

    get("/admin/maintain/company/create", MaintenanceController, :admin_create_company)
    post("/admin/maintain/company/create", MaintenanceController, :admin_create_company)

    get("/admin/maintain/offtaker/create", MaintenanceController, :admin_create_company_offtaker)
    post("/admin/maintain/offtaker/create", MaintenanceController, :admin_create_company_offtaker)

    get("/admin/maintain/sme/create", MaintenanceController, :admin_create_company_sme)
    post("/admin/maintain/sme/create", MaintenanceController, :admin_create_company_sme)

    get(
      "/admin/maintain/msg/configure",
      MaintenanceController,
      :admin_maintian_message_configurations
    )

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
      "/admin/system/management/documents",
      SystemManagementController,
      :documents
    )

    post(
      "/admin/system/management/maintainence/documents/activate",
      SystemManagementController,
      :activate_document
    )

    post(
      "/admin/system/management/maintainence/documents/deactivate",
      SystemManagementController,
      :deactivate_document
    )

    get(
      "/admin/system/management/maintainence/documents/view",
      SystemManagementController,
      :view_document
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

    post(
      "/admin/change/management/add/charge/",
      SystemManagementController,
      :add_charge
    )

    get(
      "/admin/change/management/add/charge/",
      SystemManagementController,
      :add_charge
    )

    post(
      "/admin/change/management/update/charge/",
      SystemManagementController,
      :update_charge
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

    post(
      "/admin/change/management/country/bulk/upload",
      SystemManagementController,
      :handle__country_bulk_upload
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

    # -----------------------------------------Start of Organization Mangement -----------------------------------------
    get(
      "/admin/change/maintain/employee/maintainence",
      OrganizationManagementController,
      :change_mgt_employee_maintainence
    )

    get(
      "/admin/change/maintain/employee/maintainence/make",
      OrganizationManagementController,
      :view_qfin_add_employee
    )

    get(
      "/admin/maintenance/department/activate",
      OrganizationManagementController,
      :admin_activate_department
    )

    post(
      "/admin/maintenance/department/activate",
      OrganizationManagementController,
      :admin_activate_department
    )

    get(
      "/admin/change/management/currency/create",
      OrganizationManagementController,
      :admin_create_currency
    )

    post(
      "/admin/change/management/currency/create",
      OrganizationManagementController,
      :admin_create_currency
    )

    get(
      "/admin/maintenance/department/deactivate",
      OrganizationManagementController,
      :admin_deactivate_department
    )

    post(
      "/admin/maintenance/department/deactivate",
      OrganizationManagementController,
      :admin_deactivate_department
    )

    get(
      "/admin/maintenance/alert/deactivate",
      OrganizationManagementController,
      :admin_deactivate_alert_amintenance
    )

    post(
      "/admin/maintenance/alert/deactivate",
      OrganizationManagementController,
      :admin_deactivate_alert_amintenance
    )

    get(
      "/admin/maintenance/alert/activate",
      OrganizationManagementController,
      :admin_activate_alert_amintenance
    )

    post(
      "/admin/maintenance/alert/activate",
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
      "/admin/change/management/holiday/maintainence",
      OrganizationManagementController,
      :holiday_maintianance
    )

    get(
      "/admin/change/management/password/management",
      OrganizationManagementController,
      :password_maintianance
    )

    get(
      "/admin/change/management/loan/provisioning/definition",
      OrganizationManagementController,
      :loan_provisioning_definition
    )

    get(
      "/admin/change/management/currency/maintainence",
      OrganizationManagementController,
      :currency_maintianance
    )

    get(
      "/admin/change/management/bulk/loan/reassignment",
      OrganizationManagementController,
      :bulk_loan_reassignment
    )

    get(
      "/admin/change/management/bulk/loan/reassignment/by/crms",
      OrganizationManagementController,
      :admin_bulk_re_assignment
    )

    get(
      "/admin/change/management/bulk/loan/reassignment/by/crm",
      OrganizationManagementController,
      :admin_client_crm_re_assignment_bulk
    )

    post(
      "/admin/change/management/bulk/loan/reassignment/by/crm",
      OrganizationManagementController,
      :admin_client_crm_re_assignment_bulk
    )

    get(
      "/admin/change/management/working/day/maintainence",
      OrganizationManagementController,
      :working_day_maintianance
    )

    get("/admin/change/management/bulk/import", OrganizationManagementController, :bulk_import)

    get(
      "/admin/change/management/payment/type/maintainence",
      OrganizationManagementController,
      :payment_type_maintianance
    )

    get(
      "/admin/change/management/collection/maintainence",
      OrganizationManagementController,
      :collection_maintianance
    )

    get(
      "/admin/change/management/operation/management/collection/create",
      OrganizationManagementController,
      :add_collection_type
    )

    post(
      "/admin/change/management/operation/management/collection/create",
      OrganizationManagementController,
      :add_collection_type
    )

    get(
      "/admin/change/management/operation/management/collection/update",
      OrganizationManagementController,
      :update_collection_type
    )

    post(
      "/admin/change/management/operation/management/collection/update",
      OrganizationManagementController,
      :update_collection_type
    )

    get(
      "/admin/change/management/operation/management/payment/create",
      OrganizationManagementController,
      :add_payment_type_maintianance
    )

    post(
      "/admin/change/management/operation/management/payment/create",
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
      "/admin/organization/management/branch",
      OrganizationManagementController,
      :qfin_branch_maintianance
    )

    get(
      "/admin/organization/management/branch/create",
      OrganizationManagementController,
      :admin_qfin_add_branch
    )

    post(
      "/admin/organization/management/branch/create",
      OrganizationManagementController,
      :admin_qfin_add_branch
    )

    get(
      "/admin/organization/management/branch/update",
      OrganizationManagementController,
      :admin_qfin_update_branch
    )

    post(
      "/admin/organization/management/branch/update",
      OrganizationManagementController,
      :admin_qfin_update_branch
    )

    get(
      "/admin/organization/management/employee/create",
      OrganizationManagementController,
      :admin_qfin_employees
    )

    post(
      "/admin/organization/management/employee/create",
      OrganizationManagementController,
      :admin_qfin_employees
    )

    get(
      "/admin/organization/management/employee/update",
      OrganizationManagementController,
      :admin_qfin_update_employee
    )

    post(
      "/admin/organization/management/employee/update",
      OrganizationManagementController,
      :admin_qfin_update_employee
    )

    get(
      "/admin/organization/management/branch/activate",
      OrganizationManagementController,
      :admin_ofin_activate_branch
    )

    post(
      "/admin/organization/management/branch/activate",
      OrganizationManagementController,
      :admin_ofin_activate_branch
    )

    get(
      "/admin/organization/management/branch/deactivate",
      OrganizationManagementController,
      :admin_ofin_deactivate_branch
    )

    post(
      "/admin/organization/management/branch/deactivate",
      OrganizationManagementController,
      :admin_ofin_deactivate_branch
    )

    # --------------------------------------------------end of organization management-----------------------------------------

    get("/admin/view/system/users", UserController, :user_mgt)
    get("/admin/view/system/admin/users", UserController, :administartion_user_mgt)
    get("/admin/view/all/products", ProductsController, :admin_all_products)
    # post("/admin/view/all/products", ProductsController, :admin_all_products)
    get("/admin/view/all/products/view", ProductsController, :admin_view_add_product)
    get("/admin/view/pending/products", ProductsController, :pending_products)
    get("/admin/view/inactive/products", ProductsController, :inactive_products)
    get("/admin/view/all/products/create", ProductsController, :admin_add_product)
    post("/admin/view/all/products/create", ProductsController, :admin_add_product)
    get("/admin/get/all/indivduals/view", CustomersController, :individuals)
    get("/admin/get/all/smes/view", CustomersController, :smes)
    post("/admin/view/system/users/create", UserController, :admin_create_user)
    get("/admin/view/system/users/create", UserController, :admin_create_user)
    post("/product/over/counter/charge/lookup", ProductsController, :oct_product_charge_lookup)

    post(
      "/admin/view/system/admin/users/create",
      UserController,
      :admin_create_adiministartive_user
    )

    get(
      "/admin/view/system/admin/users/create",
      UserController,
      :admin_create_adiministartive_user
    )

    post(
      "/admin/change/management/province/bulk/upload",
      MaintenanceController,
      :handle__province_bulk_upload
    )

    get(
      "/admin/maintain/msg/configure/create",
      MaintenanceController,
      :admin_add_msg_configuration
    )

    post(
      "/admin/maintain/msg/configure/create",
      MaintenanceController,
      :admin_add_msg_configuration
    )

    get(
      "/admin/maintain/msg/configure/update",
      MaintenanceController,
      :admin_update_msg_configuration
    )

    post(
      "/admin/maintain/msg/configure/update",
      MaintenanceController,
      :admin_update_msg_configuration
    )

    get(
      "/admin/maintain/msg/configure/activate",
      MaintenanceController,
      :admin_activate_msg_config
    )

    post(
      "/admin/maintain/msg/configure/activate",
      MaintenanceController,
      :admin_activate_msg_config
    )

    get(
      "/admin/maintain/msg/configure/deactivate",
      MaintenanceController,
      :admin_deactivate_msg_config
    )

    post(
      "/admin/maintain/msg/configure/deactivate",
      MaintenanceController,
      :admin_deactivate_msg_config
    )

    # get("/admin/loans/all", MaintenanceController ,:loans)
    # get("/admin/loans/pending", MaintenanceController ,:pending_loans)
    # get("/admin/loans/tracking", MaintenanceController ,:tracking_loans)
    # get("/admin/loans/disbursed", MaintenanceController ,:disbursed_loans)
    # get("/admin/loans/outstanding", MaintenanceController ,:outstanding_loans)
    # get("/admin/loans/returnedoff", MaintenanceController ,:return_off_loans)
    get("/admin/maintenance/charges", MaintenanceController, :charges)

    get("/admin/maintenance/charges/create", MaintenanceController, :add_charge)
    post("/admin/maintenance/charges/create", MaintenanceController, :add_charge)

    get("/admin/maintenance/charges/update", MaintenanceController, :update_charge)
    post("/admin/maintenance/charges/update", MaintenanceController, :update_charge)

    post("/admin/view/system/users/class", UserController, :admin_update_user_classification)
    get("/admin/view/system/users/class", UserController, :admin_update_user_classification)

    get("/admin/get/fixed/deposits/reports", ReportsController, :fixed_deposits_reports)
    get("/admin/get/all/divestment/report", ReportsController, :divestment_reports)
    get("/admin/get/all/transaction/report", ReportsController, :transaction_reports)
    get("/admin/get/all/customer/report", ReportsController, :customer_reports)
    get("/balance/sheet/report", ReportsController, :balance_sheet)
    post("/balance/sheet/report", ReportsController, :balancesheet_lookup)
    get("/income/statement/report", ReportsController, :income_statement)
    post("/income/statement/report", ReportsController, :income_statement_lookup)
    get("/trial/balance/report", ReportsController, :trial_balance)
    post("/trial/balance/report", ReportsController, :trial_balance_lookup)
    get("/general/ledger/report", ReportsController, :general_ledger)
    post("/general/ledger/report", ReportsController, :general_ledger_lookup)
    get("/admin/view/my/profile", UserController, :my_profile)
    get("/admin/maintenance/branch", MaintenanceController, :loans_branch)
    get("/admin/maintenance/bank", MaintenanceController, :bank)
    get("/admin/maintenance/classification", MaintenanceController, :classification)
    get("/admin/maintenance/classification/create", MaintenanceController, :create_classification)

    get("/admin/active/loans/summary", ReportsController, :active_loans_summary)
    post("/active/loans/sol_brunch/report", ReportsController, :loan_sol_brunch_lookup)

    get("/admin/active/loans/employer", ReportsController, :active_loans_employer)
    post("/active/loans/employer/report", ReportsController, :active_loans_employer_lookup)

    get("/admin/active/loans/emoney", ReportsController, :active_loans_emoney)
    post("/active/loans/e_money/report", ReportsController, :active_loans_emoney_lookup)

    get("/admin/active/loans/corporate", ReportsController, :active_loans_corporate)
    post("/active/loans/corporate_buyer/report", ReportsController, :active_loans_corporate_buyer_lookup)

    get("/admin/active/loans/product", ReportsController, :active_loans_product)
    post("/active/loans/product/report", ReportsController, :active_loans_product_lookup)

    get("/admin/active/loans/relationship", ReportsController, :active_loans_relationship)

    get("/admin/active/loans/installment", ReportsController, :active_loans_installment)

    get("/admin/client/summary", ReportsController, :client_summary)
    post("/active/loans/client/summary/report", ReportsController, :loan_client_summary_lookup)

    get("/admin/employer/collection/schedule", ReportsController, :employer_collection_schedule)
    post("/loans/employer/collection/report", ReportsController, :loans_employer_collection_lookup)

    get("/admin/corporate/collection/schedule", ReportsController, :corporate_collection_schedule)
    post("/loans/corporate_buyer/collection/report", ReportsController, :loans_corporate_buyer_collection_lookup)

    get("/admin/market/collection/schedule", ReportsController, :market_collection_schedule)

    get("/admin/offtaker/information", ReportsController, :offtaker_information)
    post("/active/loans/off/taker/report", ReportsController, :loan_offtaker_lookup)

    get("/admin/balance/outstanding", ReportsController, :balance_outstanding)
    post("/loans/outstanding/balance/report", ReportsController, :loan_balance_lookup)

    get("/admin/written/off/loans", ReportsController, :written_off_loans)

    get("/admin/loans/past/due", ReportsController, :loans_past_due)

    get("/admin/awaiting/disbursement", ReportsController, :awaiting_disbursement)
    post("/active/loans/awaiting/disbursement/report", ReportsController, :loan_waiting_disbursement_lookup)

    get("/admin/pending/approval", ReportsController, :pending_approval)
    post("/active/loans/pending/approval/report", ReportsController, :loan_pending_approval_lookup)

    get("/admin/balance/outstanding/source/funds", ReportsController, :source_of_funds)

    get("/admin/service/out_let", ReportsController, :service_out_let)

    get("/admin/due_vs_collected/employer", ReportsController, :dv_employer)
    post("/loans/due/v_collected/report", ReportsController, :active_loans_dvc_employer_lookup)

    get("/admin/due_vs_collected/e_money", ReportsController, :dv_emoney)
    post("/loans/due/v_collected/e_money/report", ReportsController, :active_loans_dvc_emoney_lookup)

    get("/admin/due_vs_collected/corporate_buyer", ReportsController, :dv_corporate_buyer)
    post("/loans/due/v_collected/corporate_buyer/report", ReportsController, :active_loans_dvc_corporate_lookup)

    get("/admin/due_vs_collected/relationship/manager", ReportsController, :dv_relationship_manager)

    get("/admin/loan/classification", ReportsController, :loan_classification)
    post("/loans/classification/product/report", ReportsController, :loan_classification_product_lookup)

    get("/admin/consultant/transaction/detaild", ReportsController, :consultant_transaction_detailed)

    get("/admin/consultant/transaction/summary", ReportsController, :consultant_transaction_summary)

    get("/admin/performance/summary", ReportsController, :performance_summary)

    get("/admin/loan/aiging/report", ReportsController, :loan_aiging_report)

    get("/admin/aiging/summary", ReportsController, :aiging_summary)

    get("/admin/clossed/loans", ReportsController, :clossed_loans)

    get("/admin/clossed/loan/summary/sol", ReportsController, :clossed_loan_summary_sol)

    get("/admin/clossed/loan/summary/rm", ReportsController, :clossed_loan_summary_rm)

    get("/admin/inactive/clients", ReportsController, :inactive_clients)
    get("/admin/funds/movement", ReportsController, :funds_movement)
    get("/admin/mfi/progress", ReportsController, :mfi_progress)
    get("/admin/collection/summary", ReportsController, :collection_summary)

    post(
      "/admin/maintenance/classification/create",
      MaintenanceController,
      :create_classification
    )

    get("/admin/maintenance/classification/update", MaintenanceController, :update_classification)

    post(
      "/admin/maintenance/classification/update",
      MaintenanceController,
      :update_classification
    )

    get(
      "/admin/maintenance/classification/activate",
      MaintenanceController,
      :admin_activate_classification
    )

    post(
      "/admin/maintenance/classification/activate",
      MaintenanceController,
      :admin_activate_classification
    )

    get(
      "/admin/maintenance/classification/deactivate",
      MaintenanceController,
      :admin_deactivate_classification
    )

    post(
      "/admin/maintenance/classification/deactivate",
      MaintenanceController,
      :admin_deactivate_classification
    )

    get("/admin/maintenance/bank/create", MaintenanceController, :create_bank)
    post("/admin/maintenance/bank/create", MaintenanceController, :create_bank)

    get("/admin/maintenance/bank/update", MaintenanceController, :update_bank)
    post("/admin/maintenance/bank/update", MaintenanceController, :update_bank)

    get("/admin/maintenance/bank/activate", MaintenanceController, :admin_activate_bank)
    post("/admin/maintenance/bank/activate", MaintenanceController, :admin_activate_bank)
    get("/admin/maintenance/bank/deactivate", MaintenanceController, :admin_deactivate_bank)
    post("/admin/maintenance/bank/deactivate", MaintenanceController, :admin_deactivate_bank)

    get("/admin/maintenance/branch/activate", MaintenanceController, :admin_activate_branch)
    post("/admin/maintenance/branch/activate", MaintenanceController, :admin_activate_branch)
    get("/admin/maintenance/branch/deactivate", MaintenanceController, :admin_deactivate_branch)
    post("/admin/maintenance/branch/deactivate", MaintenanceController, :admin_deactivate_branch)

    post("/Generate/Random/Password/user", UserController, :generate_random_password)
    get("/Generate/Random/Password/user", UserController, :generate_random_password)
    post("/admin/maintain/countries/update", MaintenanceController, :admin_update_country)
    get("/admin/maintain/countries/update", MaintenanceController, :admin_update_country)
    get("/admin/maintain/province/update", MaintenanceController, :admin_update_province)
    post("/admin/maintain/province/update", MaintenanceController, :admin_update_province)
    get("/admin/over/counter/", CustomersController, :otc)
    get("/admin/over/counter/list", CustomersController, :otc_logs)
    get("/admin/over/counter/repayment", CustomersController, :admin_loan_repayment)
    post("/cutomer/over/counter/lookup", CustomersController, :oct_customer_lookup)
    post("/product/over/counter/lookup", CustomersController, :oct_product_lookup)
    post("/oct/loan/application/form", CustomersController, :oct_loan_application)
    get("/oct/loan/application/form", CustomersController, :oct_loan_application)
    get("/admin/maintenance/branch/create", MaintenanceController, :admin_add_branch)
    post("/admin/maintenance/branch/create", MaintenanceController, :admin_add_branch)
    get("/admin/maintenance/branch/update", MaintenanceController, :admin_update_branch)
    post("/admin/maintenance/branch/update", MaintenanceController, :admin_update_branch)

    get("/admin/maintain/district/update", MaintenanceController, :admin_update_district)
    post("/admin/maintain/district/update", MaintenanceController, :admin_update_district)
    get("/admin/maintain/currency/update", MaintenanceController, :admin_update_currency)
    post("/admin/maintain/currency/update", MaintenanceController, :admin_update_currency)

    get(
      "/admin/maintain/security_questions/update",
      MaintenanceController,
      :admin_update_security_question
    )

    post(
      "/admin/maintain/security_questions/update",
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

    post("/user/user/change/password", UserController, :change_password)
    get("/Change/password", UserController, :change_password)
    get("/admin/view/system/users/update", UserController, :admin_update_user)
    post("/admin/view/system/users/update", UserController, :admin_update_user)
    get("/admin/view/system/users/activate", UserController, :admin_activate_user)
    post("/admin/view/system/users/activate", UserController, :admin_activate_user)

    get(
      "/admin/view/system/users/individual/activate",
      UserController,
      :admin_individual_activate_user
    )

    post(
      "/admin/view/system/users/individual/activate",
      UserController,
      :admin_individual_activate_user
    )

    get(
      "/admin/view/system/users/individual/deactivate",
      UserController,
      :admin_deactivate_user_individual
    )

    post(
      "/admin/view/system/users/individual/deactivate",
      UserController,
      :admin_deactivate_user_individual
    )

    get("/admin/view/system/users/deactivate", UserController, :admin_deactivate_user)
    post("/admin/view/system/users/deactivate", UserController, :admin_deactivate_user)
    get("/admin/view/all/products/update", ProductsController, :admin_update_product)
    post("/admin/view/all/products/update", ProductsController, :admin_update_product)
    get("/admin/view/system/products/activate", ProductsController, :admin_activate_product)
    post("/admin/view/system/products/activate", ProductsController, :admin_activate_product)
    get("/admin/view/system/products/deactivate", ProductsController, :admin_deactivate_product)
    post("/admin/view/system/products/deactivate", ProductsController, :admin_deactivate_product)

    get("/admin/view/system/company/activate", MaintenanceController, :admin_activate_company)
    post("/admin/view/system/company/activate", MaintenanceController, :admin_activate_company)
    get("/admin/view/system/company/deactivate", MaintenanceController, :admin_deactivate_company)

    post(
      "/admin/view/system/company/deactivate",
      MaintenanceController,
      :admin_deactivate_company
    )

    post("/products/items/view", ProductsController, :product_item_lookup)
    post("/admin/customer/loans/list", CustomersController, :customer_loan_item_lookup)
    post("/all/customer/loans/list", LoanController, :customer_loans_item_lookup)
    post("/client/write/off/loans/list", LoanController, :customer_loans_list_write_off)
    get("/client/write/off/loans/list", LoanController, :customer_loans_list_write_off)
    post("/admin/write/off/client/loan", LoanController, :admin_write_off_loan)

    post(
      "/all/customer/loan/apraisals/list",
      CreditManagementController,
      :customer_loan_apraisals_item_lookup
    )

    post(
      "/admin/change/management/district/bulk/upload",
      CreditManagementController,
      :handle__district_bulk_upload
    )

    post(
      "/all/customer/loan/user/list",
      OrganizationManagementController,
      :customer_loan_user_item_lookup
    )

    get(
      "/admin/change/management/currency/update",
      OrganizationManagementController,
      :admin_update_currency
    )

    post(
      "/admin/change/management/currency/update",
      OrganizationManagementController,
      :admin_update_currency
    )

    get(
      "/admin/configure/sms",
      MaintenanceController,
      :admin_configure_sms
    )

    get(
      "/admin/configure/sms/create",
      MaintenanceController,
      :admin_configure_add_sms
    )

    post(
      "/admin/configure/sms/create",
      MaintenanceController,
      :admin_configure_add_sms
    )

    get(
      "/admin/configure/sms/update",
      MaintenanceController,
      :admin_configure_update_sms
    )

    post(
      "/admin/configure/sms/update",
      MaintenanceController,
      :admin_configure_update_sms
    )

    post("/admin/pending/loans/list", LoanController, :customer_pending_item_lookup)
    post("/admin/disbursed/loans/list", LoanController, :customer_disbursed_item_lookup)
    post("/admin/products/selected/charge", ProductsController, :admin_charge_lookup)

    get("/admin/loans/all", LoanController, :loans)
    get("/admin/loans/pending", LoanController, :pending_loans)
    get("/admin/loans/tracking", LoanController, :tracking_loans)
    get("/admin/loans/disbursed", LoanController, :disbursed_loans)
    get("/admin/loans/outstanding", LoanController, :outstanding_loans)
    get("/admin/loans/returnedoff", LoanController, :return_off_loans)
    get("/admin/quick/advance/loan/application", LoanController, :quick_advance_application)
    post("/admin/quick/advance/loan/application", LoanController, :quick_advance_application)

    get("/admin/select/quick/advance/loan", LoanController, :select_quick_advance)

    get("/admin/get/quick/advance/otp", LoanController, :get_otp)
    post("/admin/get/quick/advance/otp", LoanController, :get_otp)
    post("/send/loan/otp", LoanController, :send_otp)
    get("/send/loan/otp", LoanController, :send_otp)
    get("/validate/loan/otp", LoanController, :otp_validation)
    post("/admin/validate/loan/otp", LoanController, :validate_otp)
    get("/admin/validate/loan/otp", LoanController, :validate_otp)



    get("/admin/push/quick/advance/registration", LoanController, :quick_advanced_registration)
    post("/admin/push/quick/advance/registration", LoanController, :quick_advanced_registration)

    get("/admin/verify/quick/advance", SessionController, :otp_quick_advanced)

    get("/admin/verify/quick/advance/otp", LoanController, :validate_quick_advance_otp)
    post("/admin/verify/quick/advance/otp", LoanController, :validate_quick_advance_otp)



    post(
      "/create/quick/advance/loan/application",
      LoanController,
      :create_quick_advance_loan_application
    )

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
    get("/admin/loans/pending/disbursed", LoanController, :admin_disbursed_loan)
    post("/admin/loans/pending/disbursed", LoanController, :admin_disbursed_loan)

    # writting off a loan pa status
    get("/admin/loans/write-off", LoanController, :admin_write_off_loan)
    post("/admin/loans/write-off", LoanController, :admin_write_off_loan)

    get("/admin/audit/logs/user", MaintenanceController, :admin_user_logs)
    get("/admin/audit/logs/ussd", MaintenanceController, :admin_ussd_logs)
    get("/admin/audit/logs/email", MaintenanceController, :admin_email_logs)
    get("/admin/audit/logs/sms", MaintenanceController, :admin_sms_logs)

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

    get(
      "/OffTaker/Management/employer_maintenance",
      OfftakerManagementController,
      :employer_maintenance
    )

    get(
      "/OffTaker/Management/create/employer_maintenance",
      OfftakerManagementController,
      :create_employer_maintenance
    )

    post(
      "/OffTaker/Management/create/employer_maintenance",
      OfftakerManagementController,
      :create_employer_maintenance
    )

    post("/OffTaker/Management/update", OfftakerManagementController, :edit_company)
    get("/OffTaker/Management/e_money", OfftakerManagementController, :e_money)
    post("/OffTaker/Management/create_user", OfftakerManagementController, :create_user_e_money)
    get("/OffTaker/Management/edit/user", OfftakerManagementController, :edit_e_money_user)
    post("/OffTaker/Management/edit/user", OfftakerManagementController, :edit_e_money_user)

    get(
      "/OffTaker/Management/activete/e_money_user",
      OfftakerManagementController,
      :activate_e_money_user
    )

    post(
      "/OffTaker/Management/activete/e_money_user",
      OfftakerManagementController,
      :activate_e_money_user
    )

    get(
      "/OffTaker/Management/deactivete/e_money_user",
      OfftakerManagementController,
      :deactivate_e_money_user
    )

    post(
      "/OffTaker/Management/deactivete/e_money_user",
      OfftakerManagementController,
      :deactivate_e_money_user
    )

    get(
      "/OffTaker/Management/corporate_buyer",
      OfftakerManagementController,
      :oil_marketing_company
    )

    post(
      "/OffTaker/Management/create_buyer",
      OfftakerManagementController,
      :create_oil_marketing_user
    )

    get(
      "/OffTaker/Management/edit_buyer/user",
      OfftakerManagementController,
      :edit_oil_marketing_user
    )

    post(
      "/OffTaker/Management/edit_buyer/user",
      OfftakerManagementController,
      :edit_oil_marketing_user
    )

    get(
      "/OffTaker/Management/activete/corporate_buyer",
      OfftakerManagementController,
      :activate_oil_marketing_user
    )

    post(
      "/OffTaker/Management/activete/corporate_buyer",
      OfftakerManagementController,
      :activate_oil_marketing_user
    )

    get(
      "/OffTaker/Management/deactivete/corporate_buyer",
      OfftakerManagementController,
      :activate_oil_marketing_user
    )

    post(
      "/OffTaker/Management/deactivete/corporate_buyer",
      OfftakerManagementController,
      :activate_oil_marketing_user
    )

    get(
      "/Credit/Management/employee_maintenance",
      CreditManagementController,
      :employee_maintenance
    )

    get("/Credit/Management/mobile_money_agent", CreditManagementController, :mobile_money_agent)
    get("/Credit/Management/msme_maintenance", CreditManagementController, :msme_maintenance)
    get("/Credit/Management/client_transfer", CreditManagementController, :client_transfer)
    get("/Credit/Management/blacklist_client", CreditManagementController, :blacklist_client)

    get(
      "/Credit/Management/quick_advance_application",
      LoanController,
      :quick_advance_application_datatable
    )

    post(
      "/Credit/Management/quick_advance_application",
      LoanController,
      :quick_advance_loan_item_lookup
    )

    get("/Credit/Management/quick_advance_application/capturing", LoanController, :quick_advanced_loan_capturing)
    get("/Credit/Management/quick_advance_application/view", LoanController, :view_loan_application)
    get("/Credit/Management/quick_advance_application/edit", LoanController, :edit_loan_application)

    post("/Credit/Management/reject/loan", LoanController, :reject_loan)
    get("/Credit/Management/approve/loan", LoanController, :approve_loan)
    post("/Credit/Management/approve/loan", LoanController, :approve_loan)

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

    get("/Credit/Management/client/statement", LoanController, :loan_client_statement_datatable)
    post("/Credit/Management/client/statement", LoanController, :client_statement_item_lookup)
    get("/Credit/Management/clint_statements", CreditManagementController, :clint_statements)
    get("/Credit/Management/loan_appraisal", CreditManagementController, :loan_appraisal)

    get(
      "/Credit/Management/loan_approval_and_disbursements",
      CreditManagementController,
      :loan_approval_and_disbursements
    )

    get(
      "/Credit/Management/loan_approval/user",
      CreditManagementController,
      :view_loan_apriasal
    )

    post(
      "/Credit/Management/loan_approval_and_disbursements",
      CreditManagementController,
      :loan_approval_item_lookup
    )

    get(
      "/admin/credit/management/loan_approval/update",
      CreditManagementController,
      :updating_loan_limit
    )

    post(
      "/admin/credit/management/loan_approval/update",
      CreditManagementController,
      :updating_loan_limit
    )

    get("/Credit/Monitoring/loan_rescheduling", CreditMonitoringController, :loan_rescheduling)
    get("/Credit/Monitoring/loan/portifolio", CreditMonitoringController, :loan_portifolio)

    post(
      "/Credit/Monitoring/loan/portifolio",
      CreditMonitoringController,
      :loan_portifolio_item_lookup
    )

    get("/Credit/Monitoring/loan/portfolio", CreditMonitoringController, :loan_portfolio)

    post(
      "/Credit/Monitoring/loan/portfolio/items",
      CreditMonitoringController,
      :clients_loan_portfolio_item_lookup
    )

    get(
      "/Credit/Monitoring/edit/loan_rescheduling",
      CreditMonitoringController,
      :edit_loan_details
    )

    post(
      "/Credit/Monitoring/edit/loan_rescheduling",
      CreditMonitoringController,
      :edit_loan_details
    )

    get(
      "/Credit/Monitoring/activate/loan_rescheduling",
      CreditMonitoringController,
      :activate_loan_reschedule
    )

    post(
      "/Credit/Monitoring/activate/loan_rescheduling",
      CreditMonitoringController,
      :activate_loan_reschedule
    )

    get(
      "/Credit/Monitoring/deactivate/loan_rescheduling",
      CreditMonitoringController,
      :deactivate_loan_reschedule
    )

    post(
      "/Credit/Monitoring/deactivate/loan_rescheduling",
      CreditMonitoringController,
      :deactivate_loan_reschedule
    )

    get("/Credit/Monitoring/loan_write_offs", CreditMonitoringController, :loan_write_offs)

    get(
      "/Credit/Management/debit_mandate_management",
      CreditManagementController,
      :debit_mandate_management
    )

    get(
      "/Credit/Management/collection_schedule_generation",
      CreditManagementController,
      :collection_schedule_generation
    )

    get(
      "/Credit/Management/repayment_maintenance",
      CreditManagementController,
      :repayment_maintenance
    )

    post(
      "/Credit/Management/repayment_maintenance",
      CreditManagementController,
      :loan_repayment_item_lookup
    )

    # -----------------------------------CLient Management-----------------------------------------------------
    get(
      "/admin/client/maintain/sme/maintainence",
      ClientManagementController,
      :employer_maintainence
    )

    get(
      "/admin/client/maintain/employee/maintainence",
      ClientManagementController,
      :client_maintainence
    )

    post(
      "/admin/client/maintain/employee/maintainence",
      ClientManagementController,
      :client_maintainence
    )

    get("/admin/client/maintain/add", ClientManagementController, :add_client)
    get("/admin/client/maintain/individual", ClientManagementController, :edit_individual)

    get(
      "/admin/client/maintain/edit_client_employee",
      ClientManagementController,
      :edit_client_employee
    )

    post(
      "/admin/client/maintain/edit_client_employee",
      ClientManagementController,
      :edit_client_employee
    )

    get(
      "/admin/client/maintain/edit_client_individual",
      ClientManagementController,
      :edit_client_individual
    )

    post(
      "/admin/client/maintain/edit_client_individual",
      ClientManagementController,
      :edit_client_individual
    )

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

    post(
      "/client/relation/managers/bulk/lookup",
      OrganizationManagementController,
      :client_manager_item_lookup
    )

    get(
      "/client/relation/managers/bulk/lookup",
      OrganizationManagementController,
      :client_manager_item_lookup
    )

    # -----------------------------------Financial Management------------------------
    get(
      "/admin/financial/management/search/transaction",
      FinancialManagementController,
      :search_transaction
    )

    get(
      "/admin/financial/management/frequent/posting",
      FinancialManagementController,
      :freqeunt_posting
    )

    get(
      "/admin/financial/management/financial/activity/mapping",
      FinancialManagementController,
      :financial_activity_mapping
    )

    get(
      "/admin/financial/management/fund/association",
      FinancialManagementController,
      :fund_association
    )

    get(
      "/admin/financial/management/migrate/opening/balances",
      FinancialManagementController,
      :migrate_opening_balances
    )

    get("/admin/financial/management/accruals", FinancialManagementController, :acruals)

    get(
      "/admin/financial/management/provisioning/entries",
      FinancialManagementController,
      :provisioning_entries
    )

    get(
      "/admin/financial/management/closing/entries",
      FinancialManagementController,
      :closing_entries
    )

    # -----------------------------------Organization Management------------------------
    get(
      "/admin/change/management/branch/maintainence",
      OrganizationManagementController,
      :branch_maintianance
    )

    post("/admin/change/management/create/holiday", ChangeManagementController, :create_holiday)
    post("/admin/change/management/approve/holiday", ChangeManagementController, :approve_holiday)
    post("/admin/change/management/delete/holiday", ChangeManagementController, :delete_holiday)
    post("/admin/change/management/update/holiday", ChangeManagementController, :update_holiday)

    get(
      "/admin/change/management/company/maintainence",
      ChangeManagementController,
      :company_maintainance
    )

    post(
      "/admin/change/management/create/company",
      ChangeManagementController,
      :create_company_info
    )

    post(
      "/admin/change/management/create/password/config",
      ChangeManagementController,
      :create_password_configuration
    )

    post(
      "/admin/change/management/update/password/config",
      ChangeManagementController,
      :update_password_configuration
    )

    post(
      "/admin/change/management/create/working/day/maintainence",
      ChangeManagementController,
      :create_working_days
    )

    post(
      "/admin/change/management/update/working/day/maintainence",
      ChangeManagementController,
      :update_working_days
    )

    get(
      "/admin/change/management/alert/maintainence",
      OrganizationManagementController,
      :alert_maintianance
    )

    get(
      "/admin/change/management/employee/maintainence",
      OrganizationManagementController,
      :employee_maintianence
    )

    # ---------------------------------Product Mangement-----------------------------------------
    get(
      "/admin/change/management/tax/configuration",
      ChangeManagementController,
      :tax_configuration
    )

    get(
      "/admin/change/management/alert/template/maintainence",
      ChangeManagementController,
      :alert_template_maintainence
    )

    post(
      "/Admin/Change/Management/Add/template/maintainence",
      ChangeManagementController,
      :admin_add_templete
    )

    get(
      "/admin/change/management/loyal/program/maintainence",
      ChangeManagementController,
      :loyal_program_maintainence
    )

    # ---------------------------------Branch Client Registration-----------------------------------------------------------

    get(
      "/admin//branch/client/registration/step/final/address",
      BranchRegistrationController,
      :final_steps_of_registration
    )

    get(
      "/admin//branch/client/registration/step/income/details",
      BranchRegistrationController,
      :branch_registration_income_details
    )

    get(
      "/admin//branch/client/registration/step/bank/details",
      BranchRegistrationController,
      :branch_registration_bank_details
    )

    get(
      "/admin/branch/client/registration",
      BranchRegistrationController,
      :customer_self_registration
    )

    post(
      "/admin/branch/client/registration",
      BranchRegistrationController,
      :customer_self_registration
    )

    get(
      "/admin/branch/client/registration/validate/otp",
      BranchRegistrationController,
      :otp_validation
    )

    get(
      "/admin/branch/client/registration/validate/otp/post",
      BranchRegistrationController,
      :validate_otp
    )

    post(
      "/admin/branch/client/registration/validate/otp/post",
      BranchRegistrationController,
      :validate_otp
    )

    get(
      "/admin/branch/client/registration/step/two",
      BranchRegistrationController,
      :step_two_branch_registration
    )

    get(
      "/admin/branch/registration/step/three",
      BranchRegistrationController,
      :step_three_user_registration
    )

    get(
      "/admin/branch/client/registration/step/two/personal/details",
      BranchRegistrationController,
      :step_two_user_personal_details
    )

    post(
      "/admin/branch/client/registration/step/two/personal/details",
      BranchRegistrationController,
      :step_two_user_personal_details
    )

    get(
      "/admin/branch/client/registration/step/final/address/details",
      BranchRegistrationController,
      :admin_branch_registration_add_address_details
    )

    post(
      "/admin/branch/client/registration/step/final/address/details",
      BranchRegistrationController,
      :admin_branch_registration_add_address_details
    )

    get(
      "/admin/branch/client/registration/step/final/employment/details",
      BranchRegistrationController,
      :branch_registration_add_employment_details
    )

    post(
      "/admin/branch/client/registration/step/final/employment/details",
      BranchRegistrationController,
      :branch_registration_add_employment_details
    )

    get(
      "/admin/branch/client/registration/step/final/income/details",
      BranchRegistrationController,
      :branch_registration_income_details_addition
    )

    post(
      "/admin/branch/client/registration/step/final/income/details",
      BranchRegistrationController,
      :branch_registration_income_details_addition
    )

    get(
      "/admin//branch/client/registration/step/bank/details/create",
      BranchRegistrationController,
      :branch_registration_add_bank_details
    )

    post(
      "/admin/branch/client/registration/step/bank/details/create",
      BranchRegistrationController,
      :branch_registration_add_bank_details
    )

    post(
      "/admin/credit/operation/employee/lookup",
      ClientManagementController,
      :oct_company_lookup
    )

    get(
      "/admin/branch/client/management/employer/employee/create",
      ClientManagementController,
      :admin_create_employer_employee
    )

    post(
      "/admin/branch/client/management/employer/employee/create",
      ClientManagementController,
      :admin_create_employer_employee
    )

    get(
      "/admin/admin/view/system/users/activate",
      ClientManagementController,
      :admin_activate_user
    )

    post(
      "/admin/admin/view/system/users/activate",
      ClientManagementController,
      :admin_activate_user
    )

    get(
      "/admin/admin/view/system/users/deactivate",
      ClientManagementController,
      :admin_deactivate_user
    )

    post(
      "/admin/admin/view/system/users/deactivate",
      ClientManagementController,
      :admin_deactivate_user
    )

    get(
      "/admin/credit/operations/client/management/msme/updae",
      ClientManagementController,
      :admin_update_employer_maintainence
    )

    post(
      "/admin/credit/operations/client/management/msme/updae",
      ClientManagementController,
      :admin_update_employer_maintainence
    )


    get("/Tickets/Change-Request", TicketsController, :change_request)
    get("/Tickets/Complaints", TicketsController, :complaints)
    get("/Tickets/Incidents", TicketsController, :incidents)
    get("/Tickets/Service-Request", TicketsController, :service_request)
  end

  scope "/", LoanmanagementsystemWeb do
    pipe_through([:browser, :employer_app, :logged_in])
    get("/home/home", PageController, :index)

    get("/employer/dashboard", UserController, :employer_dashboard)
    get("/employer/get/all/loans", EmployerController, :employer_employee_all_loans)

    get(
      "/employer/get/all/distursed/loans",
      EmployerController,
      :employer_employee_disbursed_loans
    )

    get("/employer/get/all/pending/loans", EmployerController, :employer_employee_pending_loans)
    get("/employer/get/all/rejected/loans", EmployerController, :employer_employee_rejected_loans)
    get("/employer/apply/loans", EmployerController, :employer_employee_loan_products)

    get("/employer/admin/get/all/loans", EmployerController, :employer_all_loans)
    get("/employer/admin/get/all/distursed/loans", EmployerController, :employer_disbursed_loans)
    get("/employer/admin/get/all/pending/loans", EmployerController, :employer_pending_loans)
    get("/employer/admin/get/all/rejected/loans", EmployerController, :employer_rejected_loans)

    get("/employer/all/staffs/loans", EmployerController, :staff_all_loans)

    post(
      "/employer/all/staffs/loans/handle/bulk/upload",
      EmployerController,
      :handle_staff_bulk_upload
    )

    get("/employer/all/admins/loans", EmployerController, :company_all_loans)
    get("/employer/reports/", EmployerController, :employer_transaction_reports)

    post("/employer/create/staffs", EmployerController, :employer_create_employee)
    get("/employer/create/staffs", EmployerController, :employer_create_employee)
    get("/employer/all/staffs", EmployerController, :all_staffs)
    get("/employer/all/admins", EmployerController, :user_mgt)
    get("/employer/admin/user/logs", EmployerController, :employer_user_logs)
    post("/employer/view/system/employee/create", EmployerController, :employer_create_employee)
    get("/employer/view/system/employee/create", EmployerController, :employer_create_employee)
    post("/Generate/Random/Password/employee", EmployerController, :generate_random_password)
    get("/Generate/Random/Password/employee", EmployerController, :generate_random_password)

    post("/employer/update/staffs", EmployerController, :employer_update_employee)
    get("/admin/employer/activate/employee", EmployerController, :employer_activate_employee)
    post("/admin/employer/activate/employee", EmployerController, :employer_activate_employee)
    post("/admin/employer/deactivate/employee", EmployerController, :employer_deactivate_employee)
    get("/admin/employer/deactivate/employee", EmployerController, :employer_deactivate_employee)
    post("/admin/employer/admin/employee", EmployerController, :employer_create_admin_employee)
    get("/admin/employer/admin/employee", EmployerController, :employer_create_admin_employee)

    post(
      "/admin/employer/deactivate/admin/employee",
      EmployerController,
      :employer_deactivate_employee
    )

    get(
      "/admin/employer/deactivate/admin/employee",
      EmployerController,
      :employer_deactivate_employee
    )

    post(
      "/employer/get/all/employee/loans",
      EmployerController,
      :employer_employee_all_loans_list_item_lookup
    )

    post(
      "/employer/get/all/pending/employee/loans",
      EmployerController,
      :employer_employee_pending_loans_list_item_lookup
    )

    post(
      "/employer/get/all/rejected/employee/loans",
      EmployerController,
      :employer_employee_rejected_loans_list_item_lookup
    )

    post("/employer/get/all/disbursed/employee/loans", EmployerController, :employer_employee_disbursed_loans_list_item_lookup)


  end

  scope "/", LoanmanagementsystemWeb do
    pipe_through([:browser, :employee_app, :logged_in])

    get("/Emploee-Dashboard", UserController, :employee_dashboard)
    get("/employee/get/all/loans", EmployeeController, :all_loans)


    get("/employee/get/loan/otp", EmployeeController, :get_otp)
    post("/employee/get/loan/otp", EmployeeController, :get_otp)
    post("/employee/send/loan/otp", EmployeeController, :send_otp)
    get("/employee/send/loan/otp", EmployeeController, :send_otp)
    get("/employee/validate/loan/otp", EmployeeController, :otp_validation)
    post("/employee/admin/validate/loan/otp", EmployeeController, :validate_otp)
    get("/employee/admin/validate/loan/otp", EmployeeController, :validate_otp)



    get("/employee/get/all/distursed/loans", EmployeeController, :disbursed_loans)
    get("/employee/get/all/pending/loans", EmployeeController, :pending_loans)
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

    get(
      "/employee/loan/application/quick_loan_application/repayment",
      EmployeeController,
      :make_payements_employee
    )

    post(
      "/employee/loan/application/quick_loan_application/repayment",
      EmployeeController,
      :make_payements_employee
    )

    get("/employee/get/loan", EmployeeController, :sample)

    # Code Debugging starts here.

    get("/admin/client/management/customer/category/", ClientManagementController, :customer_category )
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
    post("/Individual/Mini-Statements", ReportsController, :loan_statement_item_lookup)
    get("/Individual/Historic-Statements", IndividualController, :historic_statements)

    post(
      "/Individual/Historic-Statements",
      ReportsController,
      :historic_loan_statement_item_lookup
    )

    get("/download/loan/statement/pdf", ReportsController, :export_loan_statement_pdf)
    get("/Individual/Loan-Products", IndividualController, :loan_products)
    get("/Individual/Select/Loan", IndividualController, :select_loan_to_apply)
    get("/Individual/Loan-Products-Capturing", IndividualController, :loan_products_capturing)
    get("/Individual/Loan/Repayment", IndividualController, :loan_repayment_datatable)
    post("/Individual/Loan-Products/creation", IndividualController, :create_loan_application)
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

    post("/Get/Coorperate/Customer", BevuraCoorperateController, :get_customer_lookup)
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
      pipe_through(:browser)
      live_dashboard("/dashboard", metrics: LoanmanagementsystemWeb.Telemetry)
    end
  end
end
