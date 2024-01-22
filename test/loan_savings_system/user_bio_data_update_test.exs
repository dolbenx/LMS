defmodule LoanSavingsSystem.UserBioDataUpdateTest do
  use LoanSavingsSystem.DataCase

  alias LoanSavingsSystem.UserBioDataUpdate

  describe "tbl_user_bio_data_update" do
    alias LoanSavingsSystem.UserBioDataUpdate.UserBioDataUpdates

    @valid_attrs %{approvedByUserId: 42, status: "some status", userBioData: "some userBioData"}
    @update_attrs %{approvedByUserId: 43, status: "some updated status", userBioData: "some updated userBioData"}
    @invalid_attrs %{approvedByUserId: nil, status: nil, userBioData: nil}

    def user_bio_data_updates_fixture(attrs \\ %{}) do
      {:ok, user_bio_data_updates} =
        attrs
        |> Enum.into(@valid_attrs)
        |> UserBioDataUpdate.create_user_bio_data_updates()

      user_bio_data_updates
    end

    test "list_tbl_user_bio_data_update/0 returns all tbl_user_bio_data_update" do
      user_bio_data_updates = user_bio_data_updates_fixture()
      assert UserBioDataUpdate.list_tbl_user_bio_data_update() == [user_bio_data_updates]
    end

    test "get_user_bio_data_updates!/1 returns the user_bio_data_updates with given id" do
      user_bio_data_updates = user_bio_data_updates_fixture()
      assert UserBioDataUpdate.get_user_bio_data_updates!(user_bio_data_updates.id) == user_bio_data_updates
    end

    test "create_user_bio_data_updates/1 with valid data creates a user_bio_data_updates" do
      assert {:ok, %UserBioDataUpdates{} = user_bio_data_updates} = UserBioDataUpdate.create_user_bio_data_updates(@valid_attrs)
      assert user_bio_data_updates.approvedByUserId == 42
      assert user_bio_data_updates.status == "some status"
      assert user_bio_data_updates.userBioData == "some userBioData"
    end

    test "create_user_bio_data_updates/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UserBioDataUpdate.create_user_bio_data_updates(@invalid_attrs)
    end

    test "update_user_bio_data_updates/2 with valid data updates the user_bio_data_updates" do
      user_bio_data_updates = user_bio_data_updates_fixture()
      assert {:ok, %UserBioDataUpdates{} = user_bio_data_updates} = UserBioDataUpdate.update_user_bio_data_updates(user_bio_data_updates, @update_attrs)
      assert user_bio_data_updates.approvedByUserId == 43
      assert user_bio_data_updates.status == "some updated status"
      assert user_bio_data_updates.userBioData == "some updated userBioData"
    end

    test "update_user_bio_data_updates/2 with invalid data returns error changeset" do
      user_bio_data_updates = user_bio_data_updates_fixture()
      assert {:error, %Ecto.Changeset{}} = UserBioDataUpdate.update_user_bio_data_updates(user_bio_data_updates, @invalid_attrs)
      assert user_bio_data_updates == UserBioDataUpdate.get_user_bio_data_updates!(user_bio_data_updates.id)
    end

    test "delete_user_bio_data_updates/1 deletes the user_bio_data_updates" do
      user_bio_data_updates = user_bio_data_updates_fixture()
      assert {:ok, %UserBioDataUpdates{}} = UserBioDataUpdate.delete_user_bio_data_updates(user_bio_data_updates)
      assert_raise Ecto.NoResultsError, fn -> UserBioDataUpdate.get_user_bio_data_updates!(user_bio_data_updates.id) end
    end

    test "change_user_bio_data_updates/1 returns a user_bio_data_updates changeset" do
      user_bio_data_updates = user_bio_data_updates_fixture()
      assert %Ecto.Changeset{} = UserBioDataUpdate.change_user_bio_data_updates(user_bio_data_updates)
    end
  end
end
