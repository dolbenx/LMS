defmodule LoanSystem.AccountsTest do
  use LoanSystem.DataCase

  alias LoanSystem.Accounts

  describe "tbl_users" do
    alias LoanSystem.Accounts.User

    @valid_attrs %{age: 42, auto_password: "some auto_password", email: "some email", first_name: "some first_name", home_add: "some home_add", id_no: 42, id_type: "some id_type", last_name: "some last_name", password: "some password", phone: 42, sex: "some sex", status: 42, user_role: "some user_role", user_type: 42}
    @update_attrs %{age: 43, auto_password: "some updated auto_password", email: "some updated email", first_name: "some updated first_name", home_add: "some updated home_add", id_no: 43, id_type: "some updated id_type", last_name: "some updated last_name", password: "some updated password", phone: 43, sex: "some updated sex", status: 43, user_role: "some updated user_role", user_type: 43}
    @invalid_attrs %{age: nil, auto_password: nil, email: nil, first_name: nil, home_add: nil, id_no: nil, id_type: nil, last_name: nil, password: nil, phone: nil, sex: nil, status: nil, user_role: nil, user_type: nil}

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
      assert user.age == 42
      assert user.auto_password == "some auto_password"
      assert user.email == "some email"
      assert user.first_name == "some first_name"
      assert user.home_add == "some home_add"
      assert user.id_no == 42
      assert user.id_type == "some id_type"
      assert user.last_name == "some last_name"
      assert user.password == "some password"
      assert user.phone == 42
      assert user.sex == "some sex"
      assert user.status == 42
      assert user.user_role == "some user_role"
      assert user.user_type == 42
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.age == 43
      assert user.auto_password == "some updated auto_password"
      assert user.email == "some updated email"
      assert user.first_name == "some updated first_name"
      assert user.home_add == "some updated home_add"
      assert user.id_no == 43
      assert user.id_type == "some updated id_type"
      assert user.last_name == "some updated last_name"
      assert user.password == "some updated password"
      assert user.phone == 43
      assert user.sex == "some updated sex"
      assert user.status == 43
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

  describe "tbl_users" do
    alias LoanSystem.Accounts.User

    @valid_attrs %{age: 42, auto_password: "some auto_password", email: "some email", first_name: "some first_name", home_add: "some home_add", id_no: 42, id_type: "some id_type", last_name: "some last_name", password: "some password", phone: 42, sex: "some sex", status: 42, user_id: "some user_id", user_role: "some user_role", user_type: 42}
    @update_attrs %{age: 43, auto_password: "some updated auto_password", email: "some updated email", first_name: "some updated first_name", home_add: "some updated home_add", id_no: 43, id_type: "some updated id_type", last_name: "some updated last_name", password: "some updated password", phone: 43, sex: "some updated sex", status: 43, user_id: "some updated user_id", user_role: "some updated user_role", user_type: 43}
    @invalid_attrs %{age: nil, auto_password: nil, email: nil, first_name: nil, home_add: nil, id_no: nil, id_type: nil, last_name: nil, password: nil, phone: nil, sex: nil, status: nil, user_id: nil, user_role: nil, user_type: nil}

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
      assert user.age == 42
      assert user.auto_password == "some auto_password"
      assert user.email == "some email"
      assert user.first_name == "some first_name"
      assert user.home_add == "some home_add"
      assert user.id_no == 42
      assert user.id_type == "some id_type"
      assert user.last_name == "some last_name"
      assert user.password == "some password"
      assert user.phone == 42
      assert user.sex == "some sex"
      assert user.status == 42
      assert user.user_id == "some user_id"
      assert user.user_role == "some user_role"
      assert user.user_type == 42
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.age == 43
      assert user.auto_password == "some updated auto_password"
      assert user.email == "some updated email"
      assert user.first_name == "some updated first_name"
      assert user.home_add == "some updated home_add"
      assert user.id_no == 43
      assert user.id_type == "some updated id_type"
      assert user.last_name == "some updated last_name"
      assert user.password == "some updated password"
      assert user.phone == 43
      assert user.sex == "some updated sex"
      assert user.status == 43
      assert user.user_id == "some updated user_id"
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

  describe "tbl_old_password" do
    alias LoanSystem.Accounts.Old_password

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

  describe "tbl_users" do
    alias LoanSystem.Accounts.User

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
    alias LoanSystem.Accounts.User

    @valid_attrs %{created_by: "some created_by", role_description: "some role_description", role_name: "some role_name", user_id: "some user_id"}
    @update_attrs %{created_by: "some updated created_by", role_description: "some updated role_description", role_name: "some updated role_name", user_id: "some updated user_id"}
    @invalid_attrs %{created_by: nil, role_description: nil, role_name: nil, user_id: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_tbl_user_role/0 returns all tbl_user_role" do
      user = user_fixture()
      assert Accounts.list_tbl_user_role() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.created_by == "some created_by"
      assert user.role_description == "some role_description"
      assert user.role_name == "some role_name"
      assert user.user_id == "some user_id"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.created_by == "some updated created_by"
      assert user.role_description == "some updated role_description"
      assert user.role_name == "some updated role_name"
      assert user.user_id == "some updated user_id"
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
    alias LoanSystem.Accounts.UserRoles

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
end
