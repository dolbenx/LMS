defmodule LoanSavingsSystem.AccountsTest do
  use LoanSavingsSystem.DataCase

  alias LoanSavingsSystem.Accounts

  describe "tbl_users" do
    alias LoanSavingsSystem.Accounts.User

    @valid_attrs %{acc_inactive_reason: "some acc_inactive_reason", address: "some address", age: 42, auto_password: "some auto_password", created_by: "some created_by", creator_id: 42, email: "some email", first_name: "some first_name", id_no: "some id_no", id_type: "some id_type", last_modified_by: "some last_modified_by", last_name: "some last_name", loan_officer: 42, password: "some password", phone: "some phone", sex: "some sex", status: 42, title: "some title", user_role: "some user_role", user_type: 42}
    @update_attrs %{acc_inactive_reason: "some updated acc_inactive_reason", address: "some updated address", age: 43, auto_password: "some updated auto_password", created_by: "some updated created_by", creator_id: 43, email: "some updated email", first_name: "some updated first_name", id_no: "some updated id_no", id_type: "some updated id_type", last_modified_by: "some updated last_modified_by", last_name: "some updated last_name", loan_officer: 43, password: "some updated password", phone: "some updated phone", sex: "some updated sex", status: 43, title: "some updated title", user_role: "some updated user_role", user_type: 43}
    @invalid_attrs %{acc_inactive_reason: nil, address: nil, age: nil, auto_password: nil, created_by: nil, creator_id: nil, email: nil, first_name: nil, id_no: nil, id_type: nil, last_modified_by: nil, last_name: nil, loan_officer: nil, password: nil, phone: nil, sex: nil, status: nil, title: nil, user_role: nil, user_type: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_tbl_users/0 returns all tbl_users" do
      user = user_fixture()
      assert Accounts.list_tbl_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.acc_inactive_reason == "some acc_inactive_reason"
      assert user.address == "some address"
      assert user.age == 42
      assert user.auto_password == "some auto_password"
      assert user.created_by == "some created_by"
      assert user.creator_id == 42
      assert user.email == "some email"
      assert user.first_name == "some first_name"
      assert user.id_no == "some id_no"
      assert user.id_type == "some id_type"
      assert user.last_modified_by == "some last_modified_by"
      assert user.last_name == "some last_name"
      assert user.loan_officer == 42
      assert user.password == "some password"
      assert user.phone == "some phone"
      assert user.sex == "some sex"
      assert user.status == 42
      assert user.title == "some title"
      assert user.user_role == "some user_role"
      assert user.user_type == 42
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.acc_inactive_reason == "some updated acc_inactive_reason"
      assert user.address == "some updated address"
      assert user.age == 43
      assert user.auto_password == "some updated auto_password"
      assert user.created_by == "some updated created_by"
      assert user.creator_id == 43
      assert user.email == "some updated email"
      assert user.first_name == "some updated first_name"
      assert user.id_no == "some updated id_no"
      assert user.id_type == "some updated id_type"
      assert user.last_modified_by == "some updated last_modified_by"
      assert user.last_name == "some updated last_name"
      assert user.loan_officer == 43
      assert user.password == "some updated password"
      assert user.phone == "some updated phone"
      assert user.sex == "some updated sex"
      assert user.status == 43
      assert user.title == "some updated title"
      assert user.user_role == "some updated user_role"
      assert user.user_type == 43
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  describe "tbl_user_role" do
    alias LoanSavingsSystem.Accounts.UserRoles

    @valid_attrs %{created_by: "some created_by", role_description: "some role_description", role_name: "some role_name", user_id: "some user_id"}
    @update_attrs %{created_by: "some updated created_by", role_description: "some updated role_description", role_name: "some updated role_name", user_id: "some updated user_id"}
    @invalid_attrs %{created_by: nil, role_description: nil, role_name: nil, user_id: nil}

    def user_roles_fixture(attrs \\ %{}) do
      {:ok, user_roles} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user_roles()

      user_roles
    end

    test "list_tbl_user_role/0 returns all tbl_user_role" do
      user_roles = user_roles_fixture()
      assert Accounts.list_tbl_user_role() == [user_roles]
    end

    test "get_user_roles!/1 returns the user_roles with given id" do
      user_roles = user_roles_fixture()
      assert Accounts.get_user_roles!(user_roles.id) == user_roles
    end

    test "create_user_roles/1 with valid data creates a user_roles" do
      assert {:ok, %UserRoles{} = user_roles} = Accounts.create_user_roles(@valid_attrs)
      assert user_roles.created_by == "some created_by"
      assert user_roles.role_description == "some role_description"
      assert user_roles.role_name == "some role_name"
      assert user_roles.user_id == "some user_id"
    end

    test "create_user_roles/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user_roles(@invalid_attrs)
    end

    test "update_user_roles/2 with valid data updates the user_roles" do
      user_roles = user_roles_fixture()
      assert {:ok, %UserRoles{} = user_roles} = Accounts.update_user_roles(user_roles, @update_attrs)
      assert user_roles.created_by == "some updated created_by"
      assert user_roles.role_description == "some updated role_description"
      assert user_roles.role_name == "some updated role_name"
      assert user_roles.user_id == "some updated user_id"
    end

    test "update_user_roles/2 with invalid data returns error changeset" do
      user_roles = user_roles_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user_roles(user_roles, @invalid_attrs)
      assert user_roles == Accounts.get_user_roles!(user_roles.id)
    end

    test "delete_user_roles/1 deletes the user_roles" do
      user_roles = user_roles_fixture()
      assert {:ok, %UserRoles{}} = Accounts.delete_user_roles(user_roles)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user_roles!(user_roles.id) end
    end

    test "change_user_roles/1 returns a user_roles changeset" do
      user_roles = user_roles_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user_roles(user_roles)
    end
  end

  describe "tbl_old_password" do
    alias LoanSavingsSystem.Accounts.Old_password

    @valid_attrs %{date_created: "some date_created", email: "some email", password: "some password"}
    @update_attrs %{date_created: "some updated date_created", email: "some updated email", password: "some updated password"}
    @invalid_attrs %{date_created: nil, email: nil, password: nil}

    def old_password_fixture(attrs \\ %{}) do
      {:ok, old_password} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_old_password()

      old_password
    end

    test "list_tbl_old_password/0 returns all tbl_old_password" do
      old_password = old_password_fixture()
      assert Accounts.list_tbl_old_password() == [old_password]
    end

    test "get_old_password!/1 returns the old_password with given id" do
      old_password = old_password_fixture()
      assert Accounts.get_old_password!(old_password.id) == old_password
    end

    test "create_old_password/1 with valid data creates a old_password" do
      assert {:ok, %Old_password{} = old_password} = Accounts.create_old_password(@valid_attrs)
      assert old_password.date_created == "some date_created"
      assert old_password.email == "some email"
      assert old_password.password == "some password"
    end

    test "create_old_password/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_old_password(@invalid_attrs)
    end

    test "update_old_password/2 with valid data updates the old_password" do
      old_password = old_password_fixture()
      assert {:ok, %Old_password{} = old_password} = Accounts.update_old_password(old_password, @update_attrs)
      assert old_password.date_created == "some updated date_created"
      assert old_password.email == "some updated email"
      assert old_password.password == "some updated password"
    end

    test "update_old_password/2 with invalid data returns error changeset" do
      old_password = old_password_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_old_password(old_password, @invalid_attrs)
      assert old_password == Accounts.get_old_password!(old_password.id)
    end

    test "delete_old_password/1 deletes the old_password" do
      old_password = old_password_fixture()
      assert {:ok, %Old_password{}} = Accounts.delete_old_password(old_password)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_old_password!(old_password.id) end
    end

    test "change_old_password/1 returns a old_password changeset" do
      old_password = old_password_fixture()
      assert %Ecto.Changeset{} = Accounts.change_old_password(old_password)
    end
  end

  describe "password_fail_count" do
    alias LoanSavingsSystem.Accounts.User

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_password_fail_count/0 returns all password_fail_count" do
      user = user_fixture()
      assert Accounts.list_password_fail_count() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
<<<<<<< HEAD

  describe "tbl_account" do
    alias LoanSavingsSystem.Accounts.Account

    @valid_attrs %{account_no: "some account_no", account_type: "some account_type", acct_version: "some acct_version", client_id: "some client_id", currency: "some currency", currency_decimals: "some currency_decimals", date_closed: "some date_closed", deposit_type: "some deposit_type", derived_account_balance: "some derived_account_balance", external_id: "some external_id", min_balance_required: "some min_balance_required", product_id: "some product_id", status: "some status", tax_group_id: "some tax_group_id", total_charges: "some total_charges", total_deposits: "some total_deposits", total_interest_earned: "some total_interest_earned", total_interest_posted: "some total_interest_posted", total_penalties: "some total_penalties", total_tax: "some total_tax", total_withdrawals: "some total_withdrawals"}
    @update_attrs %{account_no: "some updated account_no", account_type: "some updated account_type", acct_version: "some updated acct_version", client_id: "some updated client_id", currency: "some updated currency", currency_decimals: "some updated currency_decimals", date_closed: "some updated date_closed", deposit_type: "some updated deposit_type", derived_account_balance: "some updated derived_account_balance", external_id: "some updated external_id", min_balance_required: "some updated min_balance_required", product_id: "some updated product_id", status: "some updated status", tax_group_id: "some updated tax_group_id", total_charges: "some updated total_charges", total_deposits: "some updated total_deposits", total_interest_earned: "some updated total_interest_earned", total_interest_posted: "some updated total_interest_posted", total_penalties: "some updated total_penalties", total_tax: "some updated total_tax", total_withdrawals: "some updated total_withdrawals"}
    @invalid_attrs %{account_no: nil, account_type: nil, acct_version: nil, client_id: nil, currency: nil, currency_decimals: nil, date_closed: nil, deposit_type: nil, derived_account_balance: nil, external_id: nil, min_balance_required: nil, product_id: nil, status: nil, tax_group_id: nil, total_charges: nil, total_deposits: nil, total_interest_earned: nil, total_interest_posted: nil, total_penalties: nil, total_tax: nil, total_withdrawals: nil}

    def account_fixture(attrs \\ %{}) do
      {:ok, account} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_account()

      account
    end

    test "list_tbl_account/0 returns all tbl_account" do
      account = account_fixture()
      assert Accounts.list_tbl_account() == [account]
    end

    test "get_account!/1 returns the account with given id" do
      account = account_fixture()
      assert Accounts.get_account!(account.id) == account
    end

    test "create_account/1 with valid data creates a account" do
      assert {:ok, %Account{} = account} = Accounts.create_account(@valid_attrs)
      assert account.account_no == "some account_no"
      assert account.account_type == "some account_type"
      assert account.acct_version == "some acct_version"
      assert account.client_id == "some client_id"
      assert account.currency == "some currency"
      assert account.currency_decimals == "some currency_decimals"
      assert account.date_closed == "some date_closed"
      assert account.deposit_type == "some deposit_type"
      assert account.derived_account_balance == "some derived_account_balance"
      assert account.external_id == "some external_id"
      assert account.min_balance_required == "some min_balance_required"
      assert account.product_id == "some product_id"
      assert account.status == "some status"
      assert account.tax_group_id == "some tax_group_id"
      assert account.total_charges == "some total_charges"
      assert account.total_deposits == "some total_deposits"
      assert account.total_interest_earned == "some total_interest_earned"
      assert account.total_interest_posted == "some total_interest_posted"
      assert account.total_penalties == "some total_penalties"
      assert account.total_tax == "some total_tax"
      assert account.total_withdrawals == "some total_withdrawals"
    end

    test "create_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_account(@invalid_attrs)
    end

    test "update_account/2 with valid data updates the account" do
      account = account_fixture()
      assert {:ok, %Account{} = account} = Accounts.update_account(account, @update_attrs)
      assert account.account_no == "some updated account_no"
      assert account.account_type == "some updated account_type"
      assert account.acct_version == "some updated acct_version"
      assert account.client_id == "some updated client_id"
      assert account.currency == "some updated currency"
      assert account.currency_decimals == "some updated currency_decimals"
      assert account.date_closed == "some updated date_closed"
      assert account.deposit_type == "some updated deposit_type"
      assert account.derived_account_balance == "some updated derived_account_balance"
      assert account.external_id == "some updated external_id"
      assert account.min_balance_required == "some updated min_balance_required"
      assert account.product_id == "some updated product_id"
      assert account.status == "some updated status"
      assert account.tax_group_id == "some updated tax_group_id"
      assert account.total_charges == "some updated total_charges"
      assert account.total_deposits == "some updated total_deposits"
      assert account.total_interest_earned == "some updated total_interest_earned"
      assert account.total_interest_posted == "some updated total_interest_posted"
      assert account.total_penalties == "some updated total_penalties"
      assert account.total_tax == "some updated total_tax"
      assert account.total_withdrawals == "some updated total_withdrawals"
    end

    test "update_account/2 with invalid data returns error changeset" do
      account = account_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_account(account, @invalid_attrs)
      assert account == Accounts.get_account!(account.id)
    end

    test "delete_account/1 deletes the account" do
      account = account_fixture()
      assert {:ok, %Account{}} = Accounts.delete_account(account)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_account!(account.id) end
    end

    test "change_account/1 returns a account changeset" do
      account = account_fixture()
      assert %Ecto.Changeset{} = Accounts.change_account(account)
    end
  end
=======
>>>>>>> UAT

  describe "tbl_accounts_product" do
    alias LoanSavingsSystem.Accounts.Accounts_product

    @valid_attrs %{account_id: "some account_id", annual_interest_percent: "some annual_interest_percent", client_id: "some client_id", currency: "some currency", customer_id: "some customer_id", divest_id: "some divest_id", divest_period_days: "some divest_period_days", expected_annual_interest_amount: "some expected_annual_interest_amount", fixed_period_days: "some fixed_period_days", product_id: "some product_id"}
    @update_attrs %{account_id: "some updated account_id", annual_interest_percent: "some updated annual_interest_percent", client_id: "some updated client_id", currency: "some updated currency", customer_id: "some updated customer_id", divest_id: "some updated divest_id", divest_period_days: "some updated divest_period_days", expected_annual_interest_amount: "some updated expected_annual_interest_amount", fixed_period_days: "some updated fixed_period_days", product_id: "some updated product_id"}
    @invalid_attrs %{account_id: nil, annual_interest_percent: nil, client_id: nil, currency: nil, customer_id: nil, divest_id: nil, divest_period_days: nil, expected_annual_interest_amount: nil, fixed_period_days: nil, product_id: nil}

    def accounts_product_fixture(attrs \\ %{}) do
      {:ok, accounts_product} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_accounts_product()

      accounts_product
    end

    test "list_tbl_accounts_product/0 returns all tbl_accounts_product" do
      accounts_product = accounts_product_fixture()
      assert Accounts.list_tbl_accounts_product() == [accounts_product]
    end

    test "get_accounts_product!/1 returns the accounts_product with given id" do
      accounts_product = accounts_product_fixture()
      assert Accounts.get_accounts_product!(accounts_product.id) == accounts_product
    end

    test "create_accounts_product/1 with valid data creates a accounts_product" do
      assert {:ok, %Accounts_product{} = accounts_product} = Accounts.create_accounts_product(@valid_attrs)
      assert accounts_product.account_id == "some account_id"
      assert accounts_product.annual_interest_percent == "some annual_interest_percent"
      assert accounts_product.client_id == "some client_id"
      assert accounts_product.currency == "some currency"
      assert accounts_product.customer_id == "some customer_id"
      assert accounts_product.divest_id == "some divest_id"
      assert accounts_product.divest_period_days == "some divest_period_days"
      assert accounts_product.expected_annual_interest_amount == "some expected_annual_interest_amount"
      assert accounts_product.fixed_period_days == "some fixed_period_days"
      assert accounts_product.product_id == "some product_id"
    end

    test "create_accounts_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_accounts_product(@invalid_attrs)
    end

    test "update_accounts_product/2 with valid data updates the accounts_product" do
      accounts_product = accounts_product_fixture()
      assert {:ok, %Accounts_product{} = accounts_product} = Accounts.update_accounts_product(accounts_product, @update_attrs)
      assert accounts_product.account_id == "some updated account_id"
      assert accounts_product.annual_interest_percent == "some updated annual_interest_percent"
      assert accounts_product.client_id == "some updated client_id"
      assert accounts_product.currency == "some updated currency"
      assert accounts_product.customer_id == "some updated customer_id"
      assert accounts_product.divest_id == "some updated divest_id"
      assert accounts_product.divest_period_days == "some updated divest_period_days"
      assert accounts_product.expected_annual_interest_amount == "some updated expected_annual_interest_amount"
      assert accounts_product.fixed_period_days == "some updated fixed_period_days"
      assert accounts_product.product_id == "some updated product_id"
    end

    test "update_accounts_product/2 with invalid data returns error changeset" do
      accounts_product = accounts_product_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_accounts_product(accounts_product, @invalid_attrs)
      assert accounts_product == Accounts.get_accounts_product!(accounts_product.id)
    end

    test "delete_accounts_product/1 deletes the accounts_product" do
      accounts_product = accounts_product_fixture()
      assert {:ok, %Accounts_product{}} = Accounts.delete_accounts_product(accounts_product)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_accounts_product!(accounts_product.id) end
    end

    test "change_accounts_product/1 returns a accounts_product changeset" do
      accounts_product = accounts_product_fixture()
      assert %Ecto.Changeset{} = Accounts.change_accounts_product(accounts_product)
    end
  end

  describe "tbl_old_password" do
    alias LoanSavingsSystem.Accounts.Old_password

    @valid_attrs %{date_created: "some date_created", email: "some email", password: "some password"}
    @update_attrs %{date_created: "some updated date_created", email: "some updated email", password: "some updated password"}
    @invalid_attrs %{date_created: nil, email: nil, password: nil}

    def old_password_fixture(attrs \\ %{}) do
      {:ok, old_password} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_old_password()

      old_password
    end

    test "list_tbl_old_password/0 returns all tbl_old_password" do
      old_password = old_password_fixture()
      assert Accounts.list_tbl_old_password() == [old_password]
    end

    test "get_old_password!/1 returns the old_password with given id" do
      old_password = old_password_fixture()
      assert Accounts.get_old_password!(old_password.id) == old_password
    end

    test "create_old_password/1 with valid data creates a old_password" do
      assert {:ok, %Old_password{} = old_password} = Accounts.create_old_password(@valid_attrs)
      assert old_password.date_created == "some date_created"
      assert old_password.email == "some email"
      assert old_password.password == "some password"
    end

    test "create_old_password/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_old_password(@invalid_attrs)
    end

    test "update_old_password/2 with valid data updates the old_password" do
      old_password = old_password_fixture()
      assert {:ok, %Old_password{} = old_password} = Accounts.update_old_password(old_password, @update_attrs)
      assert old_password.date_created == "some updated date_created"
      assert old_password.email == "some updated email"
      assert old_password.password == "some updated password"
    end

    test "update_old_password/2 with invalid data returns error changeset" do
      old_password = old_password_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_old_password(old_password, @invalid_attrs)
      assert old_password == Accounts.get_old_password!(old_password.id)
    end

    test "delete_old_password/1 deletes the old_password" do
      old_password = old_password_fixture()
      assert {:ok, %Old_password{}} = Accounts.delete_old_password(old_password)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_old_password!(old_password.id) end
    end

    test "change_old_password/1 returns a old_password changeset" do
      old_password = old_password_fixture()
      assert %Ecto.Changeset{} = Accounts.change_old_password(old_password)
    end
  end

  describe "tbl_account" do
    alias LoanSavingsSystem.Accounts.Account

    @valid_attrs %{account_no: "some account_no", account_type: "some account_type", acct_version: "some acct_version", client_id: "some client_id", currency: "some currency", currency_decimals: "some currency_decimals", date_closed: "some date_closed", deposit_type: "some deposit_type", derived_account_balance: "some derived_account_balance", external_id: "some external_id", min_balance_required: "some min_balance_required", product_id: "some product_id", status: "some status", tax_group_id: "some tax_group_id", total_charges: "some total_charges", total_deposits: "some total_deposits", total_interest_earned: "some total_interest_earned", total_interest_posted: "some total_interest_posted", total_penalties: "some total_penalties", total_tax: "some total_tax", total_withdrawals: "some total_withdrawals"}
    @update_attrs %{account_no: "some updated account_no", account_type: "some updated account_type", acct_version: "some updated acct_version", client_id: "some updated client_id", currency: "some updated currency", currency_decimals: "some updated currency_decimals", date_closed: "some updated date_closed", deposit_type: "some updated deposit_type", derived_account_balance: "some updated derived_account_balance", external_id: "some updated external_id", min_balance_required: "some updated min_balance_required", product_id: "some updated product_id", status: "some updated status", tax_group_id: "some updated tax_group_id", total_charges: "some updated total_charges", total_deposits: "some updated total_deposits", total_interest_earned: "some updated total_interest_earned", total_interest_posted: "some updated total_interest_posted", total_penalties: "some updated total_penalties", total_tax: "some updated total_tax", total_withdrawals: "some updated total_withdrawals"}
    @invalid_attrs %{account_no: nil, account_type: nil, acct_version: nil, client_id: nil, currency: nil, currency_decimals: nil, date_closed: nil, deposit_type: nil, derived_account_balance: nil, external_id: nil, min_balance_required: nil, product_id: nil, status: nil, tax_group_id: nil, total_charges: nil, total_deposits: nil, total_interest_earned: nil, total_interest_posted: nil, total_penalties: nil, total_tax: nil, total_withdrawals: nil}

    def account_fixture(attrs \\ %{}) do
      {:ok, account} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_account()

      account
    end

    test "list_tbl_account/0 returns all tbl_account" do
      account = account_fixture()
      assert Accounts.list_tbl_account() == [account]
    end

    test "get_account!/1 returns the account with given id" do
      account = account_fixture()
      assert Accounts.get_account!(account.id) == account
    end

    test "create_account/1 with valid data creates a account" do
      assert {:ok, %Account{} = account} = Accounts.create_account(@valid_attrs)
      assert account.account_no == "some account_no"
      assert account.account_type == "some account_type"
      assert account.acct_version == "some acct_version"
      assert account.client_id == "some client_id"
      assert account.currency == "some currency"
      assert account.currency_decimals == "some currency_decimals"
      assert account.date_closed == "some date_closed"
      assert account.deposit_type == "some deposit_type"
      assert account.derived_account_balance == "some derived_account_balance"
      assert account.external_id == "some external_id"
      assert account.min_balance_required == "some min_balance_required"
      assert account.product_id == "some product_id"
      assert account.status == "some status"
      assert account.tax_group_id == "some tax_group_id"
      assert account.total_charges == "some total_charges"
      assert account.total_deposits == "some total_deposits"
      assert account.total_interest_earned == "some total_interest_earned"
      assert account.total_interest_posted == "some total_interest_posted"
      assert account.total_penalties == "some total_penalties"
      assert account.total_tax == "some total_tax"
      assert account.total_withdrawals == "some total_withdrawals"
    end

    test "create_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_account(@invalid_attrs)
    end

    test "update_account/2 with valid data updates the account" do
      account = account_fixture()
      assert {:ok, %Account{} = account} = Accounts.update_account(account, @update_attrs)
      assert account.account_no == "some updated account_no"
      assert account.account_type == "some updated account_type"
      assert account.acct_version == "some updated acct_version"
      assert account.client_id == "some updated client_id"
      assert account.currency == "some updated currency"
      assert account.currency_decimals == "some updated currency_decimals"
      assert account.date_closed == "some updated date_closed"
      assert account.deposit_type == "some updated deposit_type"
      assert account.derived_account_balance == "some updated derived_account_balance"
      assert account.external_id == "some updated external_id"
      assert account.min_balance_required == "some updated min_balance_required"
      assert account.product_id == "some updated product_id"
      assert account.status == "some updated status"
      assert account.tax_group_id == "some updated tax_group_id"
      assert account.total_charges == "some updated total_charges"
      assert account.total_deposits == "some updated total_deposits"
      assert account.total_interest_earned == "some updated total_interest_earned"
      assert account.total_interest_posted == "some updated total_interest_posted"
      assert account.total_penalties == "some updated total_penalties"
      assert account.total_tax == "some updated total_tax"
      assert account.total_withdrawals == "some updated total_withdrawals"
    end

    test "update_account/2 with invalid data returns error changeset" do
      account = account_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_account(account, @invalid_attrs)
      assert account == Accounts.get_account!(account.id)
    end

    test "delete_account/1 deletes the account" do
      account = account_fixture()
      assert {:ok, %Account{}} = Accounts.delete_account(account)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_account!(account.id) end
    end

    test "change_account/1 returns a account changeset" do
      account = account_fixture()
      assert %Ecto.Changeset{} = Accounts.change_account(account)
    end
  end

  describe "tbl_accounts_product" do
    alias LoanSavingsSystem.Accounts.Accounts_product

    @valid_attrs %{account_id: "some account_id", annual_interest_percent: "some annual_interest_percent", client_id: "some client_id", currency: "some currency", customer_id: "some customer_id", divest_id: "some divest_id", divest_period_days: "some divest_period_days", expected_annual_interest_amount: "some expected_annual_interest_amount", fixed_period_days: "some fixed_period_days", product_id: "some product_id"}
    @update_attrs %{account_id: "some updated account_id", annual_interest_percent: "some updated annual_interest_percent", client_id: "some updated client_id", currency: "some updated currency", customer_id: "some updated customer_id", divest_id: "some updated divest_id", divest_period_days: "some updated divest_period_days", expected_annual_interest_amount: "some updated expected_annual_interest_amount", fixed_period_days: "some updated fixed_period_days", product_id: "some updated product_id"}
    @invalid_attrs %{account_id: nil, annual_interest_percent: nil, client_id: nil, currency: nil, customer_id: nil, divest_id: nil, divest_period_days: nil, expected_annual_interest_amount: nil, fixed_period_days: nil, product_id: nil}

    def accounts_product_fixture(attrs \\ %{}) do
      {:ok, accounts_product} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_accounts_product()

      accounts_product
    end

    test "list_tbl_accounts_product/0 returns all tbl_accounts_product" do
      accounts_product = accounts_product_fixture()
      assert Accounts.list_tbl_accounts_product() == [accounts_product]
    end

    test "get_accounts_product!/1 returns the accounts_product with given id" do
      accounts_product = accounts_product_fixture()
      assert Accounts.get_accounts_product!(accounts_product.id) == accounts_product
    end

    test "create_accounts_product/1 with valid data creates a accounts_product" do
      assert {:ok, %Accounts_product{} = accounts_product} = Accounts.create_accounts_product(@valid_attrs)
      assert accounts_product.account_id == "some account_id"
      assert accounts_product.annual_interest_percent == "some annual_interest_percent"
      assert accounts_product.client_id == "some client_id"
      assert accounts_product.currency == "some currency"
      assert accounts_product.customer_id == "some customer_id"
      assert accounts_product.divest_id == "some divest_id"
      assert accounts_product.divest_period_days == "some divest_period_days"
      assert accounts_product.expected_annual_interest_amount == "some expected_annual_interest_amount"
      assert accounts_product.fixed_period_days == "some fixed_period_days"
      assert accounts_product.product_id == "some product_id"
    end

    test "create_accounts_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_accounts_product(@invalid_attrs)
    end

    test "update_accounts_product/2 with valid data updates the accounts_product" do
      accounts_product = accounts_product_fixture()
      assert {:ok, %Accounts_product{} = accounts_product} = Accounts.update_accounts_product(accounts_product, @update_attrs)
      assert accounts_product.account_id == "some updated account_id"
      assert accounts_product.annual_interest_percent == "some updated annual_interest_percent"
      assert accounts_product.client_id == "some updated client_id"
      assert accounts_product.currency == "some updated currency"
      assert accounts_product.customer_id == "some updated customer_id"
      assert accounts_product.divest_id == "some updated divest_id"
      assert accounts_product.divest_period_days == "some updated divest_period_days"
      assert accounts_product.expected_annual_interest_amount == "some updated expected_annual_interest_amount"
      assert accounts_product.fixed_period_days == "some updated fixed_period_days"
      assert accounts_product.product_id == "some updated product_id"
    end

    test "update_accounts_product/2 with invalid data returns error changeset" do
      accounts_product = accounts_product_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_accounts_product(accounts_product, @invalid_attrs)
      assert accounts_product == Accounts.get_accounts_product!(accounts_product.id)
    end

    test "delete_accounts_product/1 deletes the accounts_product" do
      accounts_product = accounts_product_fixture()
      assert {:ok, %Accounts_product{}} = Accounts.delete_accounts_product(accounts_product)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_accounts_product!(accounts_product.id) end
    end

    test "change_accounts_product/1 returns a accounts_product changeset" do
      accounts_product = accounts_product_fixture()
      assert %Ecto.Changeset{} = Accounts.change_accounts_product(accounts_product)
    end
  end

  describe "tbl_users" do
    alias LoanSavingsSystem.Accounts.User

    @valid_attrs %{clientId: 42, createdByUserId: 42, password: "some password", status: "some status", username: "some username"}
    @update_attrs %{clientId: 43, createdByUserId: 43, password: "some updated password", status: "some updated status", username: "some updated username"}
    @invalid_attrs %{clientId: nil, createdByUserId: nil, password: nil, status: nil, username: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_tbl_users/0 returns all tbl_users" do
      user = user_fixture()
      assert Accounts.list_tbl_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.clientId == 42
      assert user.createdByUserId == 42
      assert user.password == "some password"
      assert user.status == "some status"
      assert user.username == "some username"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.clientId == 43
      assert user.createdByUserId == 43
      assert user.password == "some updated password"
      assert user.status == "some updated status"
      assert user.username == "some updated username"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  describe "tbl_user_roles" do
    alias LoanSavingsSystem.Accounts.UserRole

    @valid_attrs %{clientId: 42, roleType: "some roleType", status: "some status", userId: 42}
    @update_attrs %{clientId: 43, roleType: "some updated roleType", status: "some updated status", userId: 43}
    @invalid_attrs %{clientId: nil, roleType: nil, status: nil, userId: nil}

    def user_role_fixture(attrs \\ %{}) do
      {:ok, user_role} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user_role()

      user_role
    end

    test "list_tbl_user_roles/0 returns all tbl_user_roles" do
      user_role = user_role_fixture()
      assert Accounts.list_tbl_user_roles() == [user_role]
    end

    test "get_user_role!/1 returns the user_role with given id" do
      user_role = user_role_fixture()
      assert Accounts.get_user_role!(user_role.id) == user_role
    end

    test "create_user_role/1 with valid data creates a user_role" do
      assert {:ok, %UserRole{} = user_role} = Accounts.create_user_role(@valid_attrs)
      assert user_role.clientId == 42
      assert user_role.roleType == "some roleType"
      assert user_role.status == "some status"
      assert user_role.userId == 42
    end

    test "create_user_role/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user_role(@invalid_attrs)
    end

    test "update_user_role/2 with valid data updates the user_role" do
      user_role = user_role_fixture()
      assert {:ok, %UserRole{} = user_role} = Accounts.update_user_role(user_role, @update_attrs)
      assert user_role.clientId == 43
      assert user_role.roleType == "some updated roleType"
      assert user_role.status == "some updated status"
      assert user_role.userId == 43
    end

    test "update_user_role/2 with invalid data returns error changeset" do
      user_role = user_role_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user_role(user_role, @invalid_attrs)
      assert user_role == Accounts.get_user_role!(user_role.id)
    end

    test "delete_user_role/1 deletes the user_role" do
      user_role = user_role_fixture()
      assert {:ok, %UserRole{}} = Accounts.delete_user_role(user_role)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user_role!(user_role.id) end
    end

    test "change_user_role/1 returns a user_role changeset" do
      user_role = user_role_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user_role(user_role)
    end
  end

  describe "tbl_journal_entry" do
    alias LoanSavingsSystem.Accounts.JournalEntry

    @valid_attrs %{accountId: 42, amount: 120.5, clientId: 42, crGLAccountId: 42, currency: "some currency", currencyId: 42, drGLAccountId: 42, entryDate: ~N[2010-04-17 14:00:00], isReversed: true, isSystemEntry: true, productType: "some productType", reversedTransactionId: 42, transactionId: 42, userId: 42, userRoleId: 42}
    @update_attrs %{accountId: 43, amount: 456.7, clientId: 43, crGLAccountId: 43, currency: "some updated currency", currencyId: 43, drGLAccountId: 43, entryDate: ~N[2011-05-18 15:01:01], isReversed: false, isSystemEntry: false, productType: "some updated productType", reversedTransactionId: 43, transactionId: 43, userId: 43, userRoleId: 43}
    @invalid_attrs %{accountId: nil, amount: nil, clientId: nil, crGLAccountId: nil, currency: nil, currencyId: nil, drGLAccountId: nil, entryDate: nil, isReversed: nil, isSystemEntry: nil, productType: nil, reversedTransactionId: nil, transactionId: nil, userId: nil, userRoleId: nil}

    def journal_entry_fixture(attrs \\ %{}) do
      {:ok, journal_entry} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_journal_entry()

      journal_entry
    end

    test "list_tbl_journal_entry/0 returns all tbl_journal_entry" do
      journal_entry = journal_entry_fixture()
      assert Accounts.list_tbl_journal_entry() == [journal_entry]
    end

    test "get_journal_entry!/1 returns the journal_entry with given id" do
      journal_entry = journal_entry_fixture()
      assert Accounts.get_journal_entry!(journal_entry.id) == journal_entry
    end

    test "create_journal_entry/1 with valid data creates a journal_entry" do
      assert {:ok, %JournalEntry{} = journal_entry} = Accounts.create_journal_entry(@valid_attrs)
      assert journal_entry.accountId == 42
      assert journal_entry.amount == 120.5
      assert journal_entry.clientId == 42
      assert journal_entry.crGLAccountId == 42
      assert journal_entry.currency == "some currency"
      assert journal_entry.currencyId == 42
      assert journal_entry.drGLAccountId == 42
      assert journal_entry.entryDate == ~N[2010-04-17 14:00:00]
      assert journal_entry.isReversed == true
      assert journal_entry.isSystemEntry == true
      assert journal_entry.productType == "some productType"
      assert journal_entry.reversedTransactionId == 42
      assert journal_entry.transactionId == 42
      assert journal_entry.userId == 42
      assert journal_entry.userRoleId == 42
    end

    test "create_journal_entry/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_journal_entry(@invalid_attrs)
    end

    test "update_journal_entry/2 with valid data updates the journal_entry" do
      journal_entry = journal_entry_fixture()
      assert {:ok, %JournalEntry{} = journal_entry} = Accounts.update_journal_entry(journal_entry, @update_attrs)
      assert journal_entry.accountId == 43
      assert journal_entry.amount == 456.7
      assert journal_entry.clientId == 43
      assert journal_entry.crGLAccountId == 43
      assert journal_entry.currency == "some updated currency"
      assert journal_entry.currencyId == 43
      assert journal_entry.drGLAccountId == 43
      assert journal_entry.entryDate == ~N[2011-05-18 15:01:01]
      assert journal_entry.isReversed == false
      assert journal_entry.isSystemEntry == false
      assert journal_entry.productType == "some updated productType"
      assert journal_entry.reversedTransactionId == 43
      assert journal_entry.transactionId == 43
      assert journal_entry.userId == 43
      assert journal_entry.userRoleId == 43
    end

    test "update_journal_entry/2 with invalid data returns error changeset" do
      journal_entry = journal_entry_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_journal_entry(journal_entry, @invalid_attrs)
      assert journal_entry == Accounts.get_journal_entry!(journal_entry.id)
    end

    test "delete_journal_entry/1 deletes the journal_entry" do
      journal_entry = journal_entry_fixture()
      assert {:ok, %JournalEntry{}} = Accounts.delete_journal_entry(journal_entry)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_journal_entry!(journal_entry.id) end
    end

    test "change_journal_entry/1 returns a journal_entry changeset" do
      journal_entry = journal_entry_fixture()
      assert %Ecto.Changeset{} = Accounts.change_journal_entry(journal_entry)
    end
  end

  describe "tbl_gl_account" do
    alias LoanSavingsSystem.Accounts.GLAccount

    @valid_attrs %{accountName: "some accountName", accountNumber: "some accountNumber", accountSubType: "some accountSubType", accountType: "some accountType", clientId: 42, createdByUserId: 42}
    @update_attrs %{accountName: "some updated accountName", accountNumber: "some updated accountNumber", accountSubType: "some updated accountSubType", accountType: "some updated accountType", clientId: 43, createdByUserId: 43}
    @invalid_attrs %{accountName: nil, accountNumber: nil, accountSubType: nil, accountType: nil, clientId: nil, createdByUserId: nil}

    def gl_account_fixture(attrs \\ %{}) do
      {:ok, gl_account} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_gl_account()

      gl_account
    end

    test "list_tbl_gl_account/0 returns all tbl_gl_account" do
      gl_account = gl_account_fixture()
      assert Accounts.list_tbl_gl_account() == [gl_account]
    end

    test "get_gl_account!/1 returns the gl_account with given id" do
      gl_account = gl_account_fixture()
      assert Accounts.get_gl_account!(gl_account.id) == gl_account
    end

    test "create_gl_account/1 with valid data creates a gl_account" do
      assert {:ok, %GLAccount{} = gl_account} = Accounts.create_gl_account(@valid_attrs)
      assert gl_account.accountName == "some accountName"
      assert gl_account.accountNumber == "some accountNumber"
      assert gl_account.accountSubType == "some accountSubType"
      assert gl_account.accountType == "some accountType"
      assert gl_account.clientId == 42
      assert gl_account.createdByUserId == 42
    end

    test "create_gl_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_gl_account(@invalid_attrs)
    end

    test "update_gl_account/2 with valid data updates the gl_account" do
      gl_account = gl_account_fixture()
      assert {:ok, %GLAccount{} = gl_account} = Accounts.update_gl_account(gl_account, @update_attrs)
      assert gl_account.accountName == "some updated accountName"
      assert gl_account.accountNumber == "some updated accountNumber"
      assert gl_account.accountSubType == "some updated accountSubType"
      assert gl_account.accountType == "some updated accountType"
      assert gl_account.clientId == 43
      assert gl_account.createdByUserId == 43
    end

    test "update_gl_account/2 with invalid data returns error changeset" do
      gl_account = gl_account_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_gl_account(gl_account, @invalid_attrs)
      assert gl_account == Accounts.get_gl_account!(gl_account.id)
    end

    test "delete_gl_account/1 deletes the gl_account" do
      gl_account = gl_account_fixture()
      assert {:ok, %GLAccount{}} = Accounts.delete_gl_account(gl_account)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_gl_account!(gl_account.id) end
    end

    test "change_gl_account/1 returns a gl_account changeset" do
      gl_account = gl_account_fixture()
      assert %Ecto.Changeset{} = Accounts.change_gl_account(gl_account)
    end
  end

  describe "tbl_account" do
    alias LoanSavingsSystem.Accounts.Account

    @valid_attrs %{DateClosed: ~D[2010-04-17], accountNo: "some accountNo", accountType: "some accountType", accountVersion: 120.5, blockedByUserId: 42, blockedReason: "some blockedReason", clientId: 42, currencyDecimals: 42, currencyId: 42, currencyName: "some currencyName", deactivatedReason: "some deactivatedReason", derivedAccountBalance: 120.5, externalId: "some externalId", loanOfficerId: 42, productId: 42, status: "some status", totalCharges: 120.5, totalDeposits: 120.5, totalInterestEarned: 120.5, totalInterestPosted: 120.5, totalPenalties: 120.5, totalTax: 120.5, totalWithdrawals: 120.5, userId: 42}
    @update_attrs %{DateClosed: ~D[2011-05-18], accountNo: "some updated accountNo", accountType: "some updated accountType", accountVersion: 456.7, blockedByUserId: 43, blockedReason: "some updated blockedReason", clientId: 43, currencyDecimals: 43, currencyId: 43, currencyName: "some updated currencyName", deactivatedReason: "some updated deactivatedReason", derivedAccountBalance: 456.7, externalId: "some updated externalId", loanOfficerId: 43, productId: 43, status: "some updated status", totalCharges: 456.7, totalDeposits: 456.7, totalInterestEarned: 456.7, totalInterestPosted: 456.7, totalPenalties: 456.7, totalTax: 456.7, totalWithdrawals: 456.7, userId: 43}
    @invalid_attrs %{DateClosed: nil, accountNo: nil, accountType: nil, accountVersion: nil, blockedByUserId: nil, blockedReason: nil, clientId: nil, currencyDecimals: nil, currencyId: nil, currencyName: nil, deactivatedReason: nil, derivedAccountBalance: nil, externalId: nil, loanOfficerId: nil, productId: nil, status: nil, totalCharges: nil, totalDeposits: nil, totalInterestEarned: nil, totalInterestPosted: nil, totalPenalties: nil, totalTax: nil, totalWithdrawals: nil, userId: nil}

    def account_fixture(attrs \\ %{}) do
      {:ok, account} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_account()

      account
    end

    test "list_tbl_account/0 returns all tbl_account" do
      account = account_fixture()
      assert Accounts.list_tbl_account() == [account]
    end

    test "get_account!/1 returns the account with given id" do
      account = account_fixture()
      assert Accounts.get_account!(account.id) == account
    end

    test "create_account/1 with valid data creates a account" do
      assert {:ok, %Account{} = account} = Accounts.create_account(@valid_attrs)
      assert account.DateClosed == ~D[2010-04-17]
      assert account.accountNo == "some accountNo"
      assert account.accountType == "some accountType"
      assert account.accountVersion == 120.5
      assert account.blockedByUserId == 42
      assert account.blockedReason == "some blockedReason"
      assert account.clientId == 42
      assert account.currencyDecimals == 42
      assert account.currencyId == 42
      assert account.currencyName == "some currencyName"
      assert account.deactivatedReason == "some deactivatedReason"
      assert account.derivedAccountBalance == 120.5
      assert account.externalId == "some externalId"
      assert account.loanOfficerId == 42
      assert account.productId == 42
      assert account.status == "some status"
      assert account.totalCharges == 120.5
      assert account.totalDeposits == 120.5
      assert account.totalInterestEarned == 120.5
      assert account.totalInterestPosted == 120.5
      assert account.totalPenalties == 120.5
      assert account.totalTax == 120.5
      assert account.totalWithdrawals == 120.5
      assert account.userId == 42
    end

    test "create_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_account(@invalid_attrs)
    end

    test "update_account/2 with valid data updates the account" do
      account = account_fixture()
      assert {:ok, %Account{} = account} = Accounts.update_account(account, @update_attrs)
      assert account.DateClosed == ~D[2011-05-18]
      assert account.accountNo == "some updated accountNo"
      assert account.accountType == "some updated accountType"
      assert account.accountVersion == 456.7
      assert account.blockedByUserId == 43
      assert account.blockedReason == "some updated blockedReason"
      assert account.clientId == 43
      assert account.currencyDecimals == 43
      assert account.currencyId == 43
      assert account.currencyName == "some updated currencyName"
      assert account.deactivatedReason == "some updated deactivatedReason"
      assert account.derivedAccountBalance == 456.7
      assert account.externalId == "some updated externalId"
      assert account.loanOfficerId == 43
      assert account.productId == 43
      assert account.status == "some updated status"
      assert account.totalCharges == 456.7
      assert account.totalDeposits == 456.7
      assert account.totalInterestEarned == 456.7
      assert account.totalInterestPosted == 456.7
      assert account.totalPenalties == 456.7
      assert account.totalTax == 456.7
      assert account.totalWithdrawals == 456.7
      assert account.userId == 43
    end

    test "update_account/2 with invalid data returns error changeset" do
      account = account_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_account(account, @invalid_attrs)
      assert account == Accounts.get_account!(account.id)
    end

    test "delete_account/1 deletes the account" do
      account = account_fixture()
      assert {:ok, %Account{}} = Accounts.delete_account(account)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_account!(account.id) end
    end

    test "change_account/1 returns a account changeset" do
      account = account_fixture()
      assert %Ecto.Changeset{} = Accounts.change_account(account)
    end
  end

  describe "tbl_bank_staff_role" do
    alias LoanSavingsSystem.Accounts.BankStaffRole

    @valid_attrs %{permissions: "some permissions", roleName: "some roleName"}
    @update_attrs %{permissions: "some updated permissions", roleName: "some updated roleName"}
    @invalid_attrs %{permissions: nil, roleName: nil}

    def bank_staff_role_fixture(attrs \\ %{}) do
      {:ok, bank_staff_role} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_bank_staff_role()

      bank_staff_role
    end

    test "list_tbl_bank_staff_role/0 returns all tbl_bank_staff_role" do
      bank_staff_role = bank_staff_role_fixture()
      assert Accounts.list_tbl_bank_staff_role() == [bank_staff_role]
    end

    test "get_bank_staff_role!/1 returns the bank_staff_role with given id" do
      bank_staff_role = bank_staff_role_fixture()
      assert Accounts.get_bank_staff_role!(bank_staff_role.id) == bank_staff_role
    end

    test "create_bank_staff_role/1 with valid data creates a bank_staff_role" do
      assert {:ok, %BankStaffRole{} = bank_staff_role} = Accounts.create_bank_staff_role(@valid_attrs)
      assert bank_staff_role.permissions == "some permissions"
      assert bank_staff_role.roleName == "some roleName"
    end

    test "create_bank_staff_role/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_bank_staff_role(@invalid_attrs)
    end

    test "update_bank_staff_role/2 with valid data updates the bank_staff_role" do
      bank_staff_role = bank_staff_role_fixture()
      assert {:ok, %BankStaffRole{} = bank_staff_role} = Accounts.update_bank_staff_role(bank_staff_role, @update_attrs)
      assert bank_staff_role.permissions == "some updated permissions"
      assert bank_staff_role.roleName == "some updated roleName"
    end

    test "update_bank_staff_role/2 with invalid data returns error changeset" do
      bank_staff_role = bank_staff_role_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_bank_staff_role(bank_staff_role, @invalid_attrs)
      assert bank_staff_role == Accounts.get_bank_staff_role!(bank_staff_role.id)
    end

    test "delete_bank_staff_role/1 deletes the bank_staff_role" do
      bank_staff_role = bank_staff_role_fixture()
      assert {:ok, %BankStaffRole{}} = Accounts.delete_bank_staff_role(bank_staff_role)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_bank_staff_role!(bank_staff_role.id) end
    end

    test "change_bank_staff_role/1 returns a bank_staff_role changeset" do
      bank_staff_role = bank_staff_role_fixture()
      assert %Ecto.Changeset{} = Accounts.change_bank_staff_role(bank_staff_role)
    end
  end

  describe "tbl_security_questions" do
    alias LoanSavingsSystem.Accounts.SecurityQuestions

    @valid_attrs %{question: "some question", status: "some status"}
    @update_attrs %{question: "some updated question", status: "some updated status"}
    @invalid_attrs %{question: nil, status: nil}

    def security_questions_fixture(attrs \\ %{}) do
      {:ok, security_questions} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_security_questions()

      security_questions
    end

    test "list_tbl_security_questions/0 returns all tbl_security_questions" do
      security_questions = security_questions_fixture()
      assert Accounts.list_tbl_security_questions() == [security_questions]
    end

    test "get_security_questions!/1 returns the security_questions with given id" do
      security_questions = security_questions_fixture()
      assert Accounts.get_security_questions!(security_questions.id) == security_questions
    end

    test "create_security_questions/1 with valid data creates a security_questions" do
      assert {:ok, %SecurityQuestions{} = security_questions} = Accounts.create_security_questions(@valid_attrs)
      assert security_questions.question == "some question"
      assert security_questions.status == "some status"
    end

    test "create_security_questions/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_security_questions(@invalid_attrs)
    end

    test "update_security_questions/2 with valid data updates the security_questions" do
      security_questions = security_questions_fixture()
      assert {:ok, %SecurityQuestions{} = security_questions} = Accounts.update_security_questions(security_questions, @update_attrs)
      assert security_questions.question == "some updated question"
      assert security_questions.status == "some updated status"
    end

    test "update_security_questions/2 with invalid data returns error changeset" do
      security_questions = security_questions_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_security_questions(security_questions, @invalid_attrs)
      assert security_questions == Accounts.get_security_questions!(security_questions.id)
    end

    test "delete_security_questions/1 deletes the security_questions" do
      security_questions = security_questions_fixture()
      assert {:ok, %SecurityQuestions{}} = Accounts.delete_security_questions(security_questions)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_security_questions!(security_questions.id) end
    end

    test "change_security_questions/1 returns a security_questions changeset" do
      security_questions = security_questions_fixture()
      assert %Ecto.Changeset{} = Accounts.change_security_questions(security_questions)
    end
  end

  describe "tbl_roles" do
    alias LoanSavingsSystem.Accounts.Role

    @valid_attrs %{role_desc: "some role_desc", role_group: "some role_group", role_str: "some role_str", status: "some status"}
    @update_attrs %{role_desc: "some updated role_desc", role_group: "some updated role_group", role_str: "some updated role_str", status: "some updated status"}
    @invalid_attrs %{role_desc: nil, role_group: nil, role_str: nil, status: nil}

    def role_fixture(attrs \\ %{}) do
      {:ok, role} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_role()

      role
    end

    test "list_tbl_roles/0 returns all tbl_roles" do
      role = role_fixture()
      assert Accounts.list_tbl_roles() == [role]
    end

    test "get_role!/1 returns the role with given id" do
      role = role_fixture()
      assert Accounts.get_role!(role.id) == role
    end

    test "create_role/1 with valid data creates a role" do
      assert {:ok, %Role{} = role} = Accounts.create_role(@valid_attrs)
      assert role.role_desc == "some role_desc"
      assert role.role_group == "some role_group"
      assert role.role_str == "some role_str"
      assert role.status == "some status"
    end

    test "create_role/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_role(@invalid_attrs)
    end

    test "update_role/2 with valid data updates the role" do
      role = role_fixture()
      assert {:ok, %Role{} = role} = Accounts.update_role(role, @update_attrs)
      assert role.role_desc == "some updated role_desc"
      assert role.role_group == "some updated role_group"
      assert role.role_str == "some updated role_str"
      assert role.status == "some updated status"
    end

    test "update_role/2 with invalid data returns error changeset" do
      role = role_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_role(role, @invalid_attrs)
      assert role == Accounts.get_role!(role.id)
    end

    test "delete_role/1 deletes the role" do
      role = role_fixture()
      assert {:ok, %Role{}} = Accounts.delete_role(role)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_role!(role.id) end
    end

    test "change_role/1 returns a role changeset" do
      role = role_fixture()
      assert %Ecto.Changeset{} = Accounts.change_role(role)
    end
  end
end
