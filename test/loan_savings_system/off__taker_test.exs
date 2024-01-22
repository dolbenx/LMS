defmodule LoanSavingsSystem.Off_TakerTest do
  use LoanSavingsSystem.DataCase

  alias LoanSavingsSystem.Off_Taker

  describe "tbl_off_taker" do
    alias LoanSavingsSystem.Off_Taker.Off_taker

    @valid_attrs %{address: "some address", email: "some email", name: "some name", off_taker_id: "some off_taker_id", status: "some status"}
    @update_attrs %{address: "some updated address", email: "some updated email", name: "some updated name", off_taker_id: "some updated off_taker_id", status: "some updated status"}
    @invalid_attrs %{address: nil, email: nil, name: nil, off_taker_id: nil, status: nil}

    def off_taker_fixture(attrs \\ %{}) do
      {:ok, off_taker} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Off_Taker.create_off_taker()

      off_taker
    end

    test "list_tbl_off_taker/0 returns all tbl_off_taker" do
      off_taker = off_taker_fixture()
      assert Off_Taker.list_tbl_off_taker() == [off_taker]
    end

    test "get_off_taker!/1 returns the off_taker with given id" do
      off_taker = off_taker_fixture()
      assert Off_Taker.get_off_taker!(off_taker.id) == off_taker
    end

    test "create_off_taker/1 with valid data creates a off_taker" do
      assert {:ok, %Off_taker{} = off_taker} = Off_Taker.create_off_taker(@valid_attrs)
      assert off_taker.address == "some address"
      assert off_taker.email == "some email"
      assert off_taker.name == "some name"
      assert off_taker.off_taker_id == "some off_taker_id"
      assert off_taker.status == "some status"
    end

    test "create_off_taker/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Off_Taker.create_off_taker(@invalid_attrs)
    end

    test "update_off_taker/2 with valid data updates the off_taker" do
      off_taker = off_taker_fixture()
      assert {:ok, %Off_taker{} = off_taker} = Off_Taker.update_off_taker(off_taker, @update_attrs)
      assert off_taker.address == "some updated address"
      assert off_taker.email == "some updated email"
      assert off_taker.name == "some updated name"
      assert off_taker.off_taker_id == "some updated off_taker_id"
      assert off_taker.status == "some updated status"
    end

    test "update_off_taker/2 with invalid data returns error changeset" do
      off_taker = off_taker_fixture()
      assert {:error, %Ecto.Changeset{}} = Off_Taker.update_off_taker(off_taker, @invalid_attrs)
      assert off_taker == Off_Taker.get_off_taker!(off_taker.id)
    end

    test "delete_off_taker/1 deletes the off_taker" do
      off_taker = off_taker_fixture()
      assert {:ok, %Off_taker{}} = Off_Taker.delete_off_taker(off_taker)
      assert_raise Ecto.NoResultsError, fn -> Off_Taker.get_off_taker!(off_taker.id) end
    end

    test "change_off_taker/1 returns a off_taker changeset" do
      off_taker = off_taker_fixture()
      assert %Ecto.Changeset{} = Off_Taker.change_off_taker(off_taker)
    end
  end

  describe "tbl_off_taker_staff" do
    alias LoanSavingsSystem.Off_Taker.Off_taker_staff

    @valid_attrs %{auto_password: "some auto_password", email: "some email", first_name: "some first_name", gender: "some gender", last_name: "some last_name", other_name: "some other_name", password: "some password", status: "some status", user_id: "some user_id"}
    @update_attrs %{auto_password: "some updated auto_password", email: "some updated email", first_name: "some updated first_name", gender: "some updated gender", last_name: "some updated last_name", other_name: "some updated other_name", password: "some updated password", status: "some updated status", user_id: "some updated user_id"}
    @invalid_attrs %{auto_password: nil, email: nil, first_name: nil, gender: nil, last_name: nil, other_name: nil, password: nil, status: nil, user_id: nil}

    def off_taker_staff_fixture(attrs \\ %{}) do
      {:ok, off_taker_staff} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Off_Taker.create_off_taker_staff()

      off_taker_staff
    end

    test "list_tbl_off_taker_staff/0 returns all tbl_off_taker_staff" do
      off_taker_staff = off_taker_staff_fixture()
      assert Off_Taker.list_tbl_off_taker_staff() == [off_taker_staff]
    end

    test "get_off_taker_staff!/1 returns the off_taker_staff with given id" do
      off_taker_staff = off_taker_staff_fixture()
      assert Off_Taker.get_off_taker_staff!(off_taker_staff.id) == off_taker_staff
    end

    test "create_off_taker_staff/1 with valid data creates a off_taker_staff" do
      assert {:ok, %Off_taker_staff{} = off_taker_staff} = Off_Taker.create_off_taker_staff(@valid_attrs)
      assert off_taker_staff.auto_password == "some auto_password"
      assert off_taker_staff.email == "some email"
      assert off_taker_staff.first_name == "some first_name"
      assert off_taker_staff.gender == "some gender"
      assert off_taker_staff.last_name == "some last_name"
      assert off_taker_staff.other_name == "some other_name"
      assert off_taker_staff.password == "some password"
      assert off_taker_staff.status == "some status"
      assert off_taker_staff.user_id == "some user_id"
    end

    test "create_off_taker_staff/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Off_Taker.create_off_taker_staff(@invalid_attrs)
    end

    test "update_off_taker_staff/2 with valid data updates the off_taker_staff" do
      off_taker_staff = off_taker_staff_fixture()
      assert {:ok, %Off_taker_staff{} = off_taker_staff} = Off_Taker.update_off_taker_staff(off_taker_staff, @update_attrs)
      assert off_taker_staff.auto_password == "some updated auto_password"
      assert off_taker_staff.email == "some updated email"
      assert off_taker_staff.first_name == "some updated first_name"
      assert off_taker_staff.gender == "some updated gender"
      assert off_taker_staff.last_name == "some updated last_name"
      assert off_taker_staff.other_name == "some updated other_name"
      assert off_taker_staff.password == "some updated password"
      assert off_taker_staff.status == "some updated status"
      assert off_taker_staff.user_id == "some updated user_id"
    end

    test "update_off_taker_staff/2 with invalid data returns error changeset" do
      off_taker_staff = off_taker_staff_fixture()
      assert {:error, %Ecto.Changeset{}} = Off_Taker.update_off_taker_staff(off_taker_staff, @invalid_attrs)
      assert off_taker_staff == Off_Taker.get_off_taker_staff!(off_taker_staff.id)
    end

    test "delete_off_taker_staff/1 deletes the off_taker_staff" do
      off_taker_staff = off_taker_staff_fixture()
      assert {:ok, %Off_taker_staff{}} = Off_Taker.delete_off_taker_staff(off_taker_staff)
      assert_raise Ecto.NoResultsError, fn -> Off_Taker.get_off_taker_staff!(off_taker_staff.id) end
    end

    test "change_off_taker_staff/1 returns a off_taker_staff changeset" do
      off_taker_staff = off_taker_staff_fixture()
      assert %Ecto.Changeset{} = Off_Taker.change_off_taker_staff(off_taker_staff)
    end
  end
end
