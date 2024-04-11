defmodule Loanmanagementsystem.AccountsTest do
  use Loanmanagementsystem.DataCase

  alias Loanmanagementsystem.Accounts

  describe "tbl_users" do
    alias Loanmanagementsystem.Accounts.User

    import Loanmanagementsystem.AccountsFixtures

    @invalid_attrs %{auto_password: nil, classification_id: nil, external_id: nil, is_admin: nil, is_employee: nil, is_employer: nil, is_offtaker: nil, is_rm: nil, is_sme: nil, password: nil, password_fail_count: nil, pin: nil, status: nil, username: nil}

    test "list_tbl_users/0 returns all tbl_users" do
      user = user_fixture()
      assert Accounts.list_tbl_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{auto_password: "some auto_password", classification_id: 42, external_id: 42, is_admin: true, is_employee: true, is_employer: true, is_offtaker: true, is_rm: true, is_sme: true, password: "some password", password_fail_count: 42, pin: "some pin", status: "some status", username: "some username"}

      assert {:ok, %User{} = user} = Accounts.create_user(valid_attrs)
      assert user.auto_password == "some auto_password"
      assert user.classification_id == 42
      assert user.external_id == 42
      assert user.is_admin == true
      assert user.is_employee == true
      assert user.is_employer == true
      assert user.is_offtaker == true
      assert user.is_rm == true
      assert user.is_sme == true
      assert user.password == "some password"
      assert user.password_fail_count == 42
      assert user.pin == "some pin"
      assert user.status == "some status"
      assert user.username == "some username"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{auto_password: "some updated auto_password", classification_id: 43, external_id: 43, is_admin: false, is_employee: false, is_employer: false, is_offtaker: false, is_rm: false, is_sme: false, password: "some updated password", password_fail_count: 43, pin: "some updated pin", status: "some updated status", username: "some updated username"}

      assert {:ok, %User{} = user} = Accounts.update_user(user, update_attrs)
      assert user.auto_password == "some updated auto_password"
      assert user.classification_id == 43
      assert user.external_id == 43
      assert user.is_admin == false
      assert user.is_employee == false
      assert user.is_employer == false
      assert user.is_offtaker == false
      assert user.is_rm == false
      assert user.is_sme == false
      assert user.password == "some updated password"
      assert user.password_fail_count == 43
      assert user.pin == "some updated pin"
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

  describe "tbl_user_bio_data" do
    alias Loanmanagementsystem.Accounts.UserBioData

    import Loanmanagementsystem.AccountsFixtures

    @invalid_attrs %{accept_conditions: nil, age: nil, date_of_birth: nil, email_address: nil, first_name: nil, gender: nil, id_number: nil, id_type: nil, last_name: nil, marital_status: nil, mobile_number: nil, nationality: nil, number_of_dependants: nil, other_name: nil, title: nil, user_id: nil}

    test "list_tbl_user_bio_data/0 returns all tbl_user_bio_data" do
      user_bio_data = user_bio_data_fixture()
      assert Accounts.list_tbl_user_bio_data() == [user_bio_data]
    end

    test "get_user_bio_data!/1 returns the user_bio_data with given id" do
      user_bio_data = user_bio_data_fixture()
      assert Accounts.get_user_bio_data!(user_bio_data.id) == user_bio_data
    end

    test "create_user_bio_data/1 with valid data creates a user_bio_data" do
      valid_attrs = %{accept_conditions: true, age: 42, date_of_birth: ~D[2024-03-24], email_address: "some email_address", first_name: "some first_name", gender: "some gender", id_number: "some id_number", id_type: "some id_type", last_name: "some last_name", marital_status: "some marital_status", mobile_number: "some mobile_number", nationality: "some nationality", number_of_dependants: 42, other_name: "some other_name", title: "some title", user_id: 42}

      assert {:ok, %UserBioData{} = user_bio_data} = Accounts.create_user_bio_data(valid_attrs)
      assert user_bio_data.accept_conditions == true
      assert user_bio_data.age == 42
      assert user_bio_data.date_of_birth == ~D[2024-03-24]
      assert user_bio_data.email_address == "some email_address"
      assert user_bio_data.first_name == "some first_name"
      assert user_bio_data.gender == "some gender"
      assert user_bio_data.id_number == "some id_number"
      assert user_bio_data.id_type == "some id_type"
      assert user_bio_data.last_name == "some last_name"
      assert user_bio_data.marital_status == "some marital_status"
      assert user_bio_data.mobile_number == "some mobile_number"
      assert user_bio_data.nationality == "some nationality"
      assert user_bio_data.number_of_dependants == 42
      assert user_bio_data.other_name == "some other_name"
      assert user_bio_data.title == "some title"
      assert user_bio_data.user_id == 42
    end

    test "create_user_bio_data/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user_bio_data(@invalid_attrs)
    end

    test "update_user_bio_data/2 with valid data updates the user_bio_data" do
      user_bio_data = user_bio_data_fixture()
      update_attrs = %{accept_conditions: false, age: 43, date_of_birth: ~D[2024-03-25], email_address: "some updated email_address", first_name: "some updated first_name", gender: "some updated gender", id_number: "some updated id_number", id_type: "some updated id_type", last_name: "some updated last_name", marital_status: "some updated marital_status", mobile_number: "some updated mobile_number", nationality: "some updated nationality", number_of_dependants: 43, other_name: "some updated other_name", title: "some updated title", user_id: 43}

      assert {:ok, %UserBioData{} = user_bio_data} = Accounts.update_user_bio_data(user_bio_data, update_attrs)
      assert user_bio_data.accept_conditions == false
      assert user_bio_data.age == 43
      assert user_bio_data.date_of_birth == ~D[2024-03-25]
      assert user_bio_data.email_address == "some updated email_address"
      assert user_bio_data.first_name == "some updated first_name"
      assert user_bio_data.gender == "some updated gender"
      assert user_bio_data.id_number == "some updated id_number"
      assert user_bio_data.id_type == "some updated id_type"
      assert user_bio_data.last_name == "some updated last_name"
      assert user_bio_data.marital_status == "some updated marital_status"
      assert user_bio_data.mobile_number == "some updated mobile_number"
      assert user_bio_data.nationality == "some updated nationality"
      assert user_bio_data.number_of_dependants == 43
      assert user_bio_data.other_name == "some updated other_name"
      assert user_bio_data.title == "some updated title"
      assert user_bio_data.user_id == 43
    end

    test "update_user_bio_data/2 with invalid data returns error changeset" do
      user_bio_data = user_bio_data_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user_bio_data(user_bio_data, @invalid_attrs)
      assert user_bio_data == Accounts.get_user_bio_data!(user_bio_data.id)
    end

    test "delete_user_bio_data/1 deletes the user_bio_data" do
      user_bio_data = user_bio_data_fixture()
      assert {:ok, %UserBioData{}} = Accounts.delete_user_bio_data(user_bio_data)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user_bio_data!(user_bio_data.id) end
    end

    test "change_user_bio_data/1 returns a user_bio_data changeset" do
      user_bio_data = user_bio_data_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user_bio_data(user_bio_data)
    end
  end

  describe "tbl_account" do
    alias Loanmanagementsystem.Accounts.Account

    import Loanmanagementsystem.AccountsFixtures

    @invalid_attrs %{account_number: nil, account_type: nil, available_balance: nil, current_balance: nil, external_id: nil, limit: nil, mobile_number: nil, status: nil, total_credited: nil, total_debited: nil, user_id: nil, user_role_id: nil}

    test "list_tbl_account/0 returns all tbl_account" do
      account = account_fixture()
      assert Accounts.list_tbl_account() == [account]
    end

    test "get_account!/1 returns the account with given id" do
      account = account_fixture()
      assert Accounts.get_account!(account.id) == account
    end

    test "create_account/1 with valid data creates a account" do
      valid_attrs = %{account_number: "some account_number", account_type: "some account_type", available_balance: 120.5, current_balance: 120.5, external_id: 42, limit: 120.5, mobile_number: "some mobile_number", status: "some status", total_credited: 120.5, total_debited: 120.5, user_id: 42, user_role_id: 42}

      assert {:ok, %Account{} = account} = Accounts.create_account(valid_attrs)
      assert account.account_number == "some account_number"
      assert account.account_type == "some account_type"
      assert account.available_balance == 120.5
      assert account.current_balance == 120.5
      assert account.external_id == 42
      assert account.limit == 120.5
      assert account.mobile_number == "some mobile_number"
      assert account.status == "some status"
      assert account.total_credited == 120.5
      assert account.total_debited == 120.5
      assert account.user_id == 42
      assert account.user_role_id == 42
    end

    test "create_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_account(@invalid_attrs)
    end

    test "update_account/2 with valid data updates the account" do
      account = account_fixture()
      update_attrs = %{account_number: "some updated account_number", account_type: "some updated account_type", available_balance: 456.7, current_balance: 456.7, external_id: 43, limit: 456.7, mobile_number: "some updated mobile_number", status: "some updated status", total_credited: 456.7, total_debited: 456.7, user_id: 43, user_role_id: 43}

      assert {:ok, %Account{} = account} = Accounts.update_account(account, update_attrs)
      assert account.account_number == "some updated account_number"
      assert account.account_type == "some updated account_type"
      assert account.available_balance == 456.7
      assert account.current_balance == 456.7
      assert account.external_id == 43
      assert account.limit == 456.7
      assert account.mobile_number == "some updated mobile_number"
      assert account.status == "some updated status"
      assert account.total_credited == 456.7
      assert account.total_debited == 456.7
      assert account.user_id == 43
      assert account.user_role_id == 43
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

  describe "tbl_user_roles" do
    alias Loanmanagementsystem.Accounts.UserRole

    import Loanmanagementsystem.AccountsFixtures

    @invalid_attrs %{auth_level: nil, permissions: nil, role_type: nil, session: nil, status: nil, user_id: nil}

    test "list_tbl_user_roles/0 returns all tbl_user_roles" do
      user_role = user_role_fixture()
      assert Accounts.list_tbl_user_roles() == [user_role]
    end

    test "get_user_role!/1 returns the user_role with given id" do
      user_role = user_role_fixture()
      assert Accounts.get_user_role!(user_role.id) == user_role
    end

    test "create_user_role/1 with valid data creates a user_role" do
      valid_attrs = %{auth_level: 42, permissions: "some permissions", role_type: "some role_type", session: "some session", status: "some status", user_id: 42}

      assert {:ok, %UserRole{} = user_role} = Accounts.create_user_role(valid_attrs)
      assert user_role.auth_level == 42
      assert user_role.permissions == "some permissions"
      assert user_role.role_type == "some role_type"
      assert user_role.session == "some session"
      assert user_role.status == "some status"
      assert user_role.user_id == 42
    end

    test "create_user_role/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user_role(@invalid_attrs)
    end

    test "update_user_role/2 with valid data updates the user_role" do
      user_role = user_role_fixture()
      update_attrs = %{auth_level: 43, permissions: "some updated permissions", role_type: "some updated role_type", session: "some updated session", status: "some updated status", user_id: 43}

      assert {:ok, %UserRole{} = user_role} = Accounts.update_user_role(user_role, update_attrs)
      assert user_role.auth_level == 43
      assert user_role.permissions == "some updated permissions"
      assert user_role.role_type == "some updated role_type"
      assert user_role.session == "some updated session"
      assert user_role.status == "some updated status"
      assert user_role.user_id == 43
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

  describe "tbl_roles" do
    alias Loanmanagementsystem.Accounts.Role

    import Loanmanagementsystem.AccountsFixtures

    @invalid_attrs %{role_desc: nil, role_group: nil, role_str: nil, status: nil}

    test "list_tbl_roles/0 returns all tbl_roles" do
      role = role_fixture()
      assert Accounts.list_tbl_roles() == [role]
    end

    test "get_role!/1 returns the role with given id" do
      role = role_fixture()
      assert Accounts.get_role!(role.id) == role
    end

    test "create_role/1 with valid data creates a role" do
      valid_attrs = %{role_desc: "some role_desc", role_group: "some role_group", role_str: "some role_str", status: "some status"}

      assert {:ok, %Role{} = role} = Accounts.create_role(valid_attrs)
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
      update_attrs = %{role_desc: "some updated role_desc", role_group: "some updated role_group", role_str: "some updated role_str", status: "some updated status"}

      assert {:ok, %Role{} = role} = Accounts.update_role(role, update_attrs)
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

  describe "tbl_next_of_kin" do
    alias Loanmanagementsystem.Accounts.NextOfKin

    import Loanmanagementsystem.AccountsFixtures

    @invalid_attrs %{kin_first_name: nil, kin_gender: nil, kin_id_number: nil, kin_last_name: nil, kin_mobile_number: nil, kin_other_name: nil, kin_personal_email: nil, kin_relationship: nil, kin_status: nil, user_id: nil}

    test "list_tbl_next_of_kin/0 returns all tbl_next_of_kin" do
      next_of_kin = next_of_kin_fixture()
      assert Accounts.list_tbl_next_of_kin() == [next_of_kin]
    end

    test "get_next_of_kin!/1 returns the next_of_kin with given id" do
      next_of_kin = next_of_kin_fixture()
      assert Accounts.get_next_of_kin!(next_of_kin.id) == next_of_kin
    end

    test "create_next_of_kin/1 with valid data creates a next_of_kin" do
      valid_attrs = %{kin_first_name: "some kin_first_name", kin_gender: "some kin_gender", kin_id_number: "some kin_id_number", kin_last_name: "some kin_last_name", kin_mobile_number: "some kin_mobile_number", kin_other_name: "some kin_other_name", kin_personal_email: "some kin_personal_email", kin_relationship: "some kin_relationship", kin_status: "some kin_status", user_id: 42}

      assert {:ok, %NextOfKin{} = next_of_kin} = Accounts.create_next_of_kin(valid_attrs)
      assert next_of_kin.kin_first_name == "some kin_first_name"
      assert next_of_kin.kin_gender == "some kin_gender"
      assert next_of_kin.kin_id_number == "some kin_id_number"
      assert next_of_kin.kin_last_name == "some kin_last_name"
      assert next_of_kin.kin_mobile_number == "some kin_mobile_number"
      assert next_of_kin.kin_other_name == "some kin_other_name"
      assert next_of_kin.kin_personal_email == "some kin_personal_email"
      assert next_of_kin.kin_relationship == "some kin_relationship"
      assert next_of_kin.kin_status == "some kin_status"
      assert next_of_kin.user_id == 42
    end

    test "create_next_of_kin/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_next_of_kin(@invalid_attrs)
    end

    test "update_next_of_kin/2 with valid data updates the next_of_kin" do
      next_of_kin = next_of_kin_fixture()
      update_attrs = %{kin_first_name: "some updated kin_first_name", kin_gender: "some updated kin_gender", kin_id_number: "some updated kin_id_number", kin_last_name: "some updated kin_last_name", kin_mobile_number: "some updated kin_mobile_number", kin_other_name: "some updated kin_other_name", kin_personal_email: "some updated kin_personal_email", kin_relationship: "some updated kin_relationship", kin_status: "some updated kin_status", user_id: 43}

      assert {:ok, %NextOfKin{} = next_of_kin} = Accounts.update_next_of_kin(next_of_kin, update_attrs)
      assert next_of_kin.kin_first_name == "some updated kin_first_name"
      assert next_of_kin.kin_gender == "some updated kin_gender"
      assert next_of_kin.kin_id_number == "some updated kin_id_number"
      assert next_of_kin.kin_last_name == "some updated kin_last_name"
      assert next_of_kin.kin_mobile_number == "some updated kin_mobile_number"
      assert next_of_kin.kin_other_name == "some updated kin_other_name"
      assert next_of_kin.kin_personal_email == "some updated kin_personal_email"
      assert next_of_kin.kin_relationship == "some updated kin_relationship"
      assert next_of_kin.kin_status == "some updated kin_status"
      assert next_of_kin.user_id == 43
    end

    test "update_next_of_kin/2 with invalid data returns error changeset" do
      next_of_kin = next_of_kin_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_next_of_kin(next_of_kin, @invalid_attrs)
      assert next_of_kin == Accounts.get_next_of_kin!(next_of_kin.id)
    end

    test "delete_next_of_kin/1 deletes the next_of_kin" do
      next_of_kin = next_of_kin_fixture()
      assert {:ok, %NextOfKin{}} = Accounts.delete_next_of_kin(next_of_kin)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_next_of_kin!(next_of_kin.id) end
    end

    test "change_next_of_kin/1 returns a next_of_kin changeset" do
      next_of_kin = next_of_kin_fixture()
      assert %Ecto.Changeset{} = Accounts.change_next_of_kin(next_of_kin)
    end
  end

  describe "tbl_address_details" do
    alias Loanmanagementsystem.Accounts.AddressDetails

    import Loanmanagementsystem.AccountsFixtures

    @invalid_attrs %{accomodation_status: nil, area: nil, country: nil, house_number: nil, province: nil, street_name: nil, town: nil, user_id: nil, years_at_current_address: nil}

    test "list_tbl_address_details/0 returns all tbl_address_details" do
      address_details = address_details_fixture()
      assert Accounts.list_tbl_address_details() == [address_details]
    end

    test "get_address_details!/1 returns the address_details with given id" do
      address_details = address_details_fixture()
      assert Accounts.get_address_details!(address_details.id) == address_details
    end

    test "create_address_details/1 with valid data creates a address_details" do
      valid_attrs = %{accomodation_status: "some accomodation_status", area: "some area", country: 42, house_number: "some house_number", province: 42, street_name: "some street_name", town: 42, user_id: 42, years_at_current_address: 42}

      assert {:ok, %AddressDetails{} = address_details} = Accounts.create_address_details(valid_attrs)
      assert address_details.accomodation_status == "some accomodation_status"
      assert address_details.area == "some area"
      assert address_details.country == 42
      assert address_details.house_number == "some house_number"
      assert address_details.province == 42
      assert address_details.street_name == "some street_name"
      assert address_details.town == 42
      assert address_details.user_id == 42
      assert address_details.years_at_current_address == 42
    end

    test "create_address_details/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_address_details(@invalid_attrs)
    end

    test "update_address_details/2 with valid data updates the address_details" do
      address_details = address_details_fixture()
      update_attrs = %{accomodation_status: "some updated accomodation_status", area: "some updated area", country: 43, house_number: "some updated house_number", province: 43, street_name: "some updated street_name", town: 43, user_id: 43, years_at_current_address: 43}

      assert {:ok, %AddressDetails{} = address_details} = Accounts.update_address_details(address_details, update_attrs)
      assert address_details.accomodation_status == "some updated accomodation_status"
      assert address_details.area == "some updated area"
      assert address_details.country == 43
      assert address_details.house_number == "some updated house_number"
      assert address_details.province == 43
      assert address_details.street_name == "some updated street_name"
      assert address_details.town == 43
      assert address_details.user_id == 43
      assert address_details.years_at_current_address == 43
    end

    test "update_address_details/2 with invalid data returns error changeset" do
      address_details = address_details_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_address_details(address_details, @invalid_attrs)
      assert address_details == Accounts.get_address_details!(address_details.id)
    end

    test "delete_address_details/1 deletes the address_details" do
      address_details = address_details_fixture()
      assert {:ok, %AddressDetails{}} = Accounts.delete_address_details(address_details)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_address_details!(address_details.id) end
    end

    test "change_address_details/1 returns a address_details changeset" do
      address_details = address_details_fixture()
      assert %Ecto.Changeset{} = Accounts.change_address_details(address_details)
    end
  end

  describe "tbl_user_tokens" do
    alias Loanmanagementsystem.Accounts.UserToken

    import Loanmanagementsystem.AccountsFixtures

    @invalid_attrs %{context: nil, login_timestamp: nil, sent_to: nil, token: nil, user_id: nil}

    test "list_tbl_user_tokens/0 returns all tbl_user_tokens" do
      user_token = user_token_fixture()
      assert Accounts.list_tbl_user_tokens() == [user_token]
    end

    test "get_user_token!/1 returns the user_token with given id" do
      user_token = user_token_fixture()
      assert Accounts.get_user_token!(user_token.id) == user_token
    end

    test "create_user_token/1 with valid data creates a user_token" do
      valid_attrs = %{context: "some context", login_timestamp: ~N[2024-03-24 10:46:00], sent_to: "some sent_to", token: "some token", user_id: 42}

      assert {:ok, %UserToken{} = user_token} = Accounts.create_user_token(valid_attrs)
      assert user_token.context == "some context"
      assert user_token.login_timestamp == ~N[2024-03-24 10:46:00]
      assert user_token.sent_to == "some sent_to"
      assert user_token.token == "some token"
      assert user_token.user_id == 42
    end

    test "create_user_token/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user_token(@invalid_attrs)
    end

    test "update_user_token/2 with valid data updates the user_token" do
      user_token = user_token_fixture()
      update_attrs = %{context: "some updated context", login_timestamp: ~N[2024-03-25 10:46:00], sent_to: "some updated sent_to", token: "some updated token", user_id: 43}

      assert {:ok, %UserToken{} = user_token} = Accounts.update_user_token(user_token, update_attrs)
      assert user_token.context == "some updated context"
      assert user_token.login_timestamp == ~N[2024-03-25 10:46:00]
      assert user_token.sent_to == "some updated sent_to"
      assert user_token.token == "some updated token"
      assert user_token.user_id == 43
    end

    test "update_user_token/2 with invalid data returns error changeset" do
      user_token = user_token_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user_token(user_token, @invalid_attrs)
      assert user_token == Accounts.get_user_token!(user_token.id)
    end

    test "delete_user_token/1 deletes the user_token" do
      user_token = user_token_fixture()
      assert {:ok, %UserToken{}} = Accounts.delete_user_token(user_token)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user_token!(user_token.id) end
    end

    test "change_user_token/1 returns a user_token changeset" do
      user_token = user_token_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user_token(user_token)
    end
  end
end
