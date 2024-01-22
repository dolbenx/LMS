defmodule LoanSavingsSystem.ConfirmationNotificationTest do
  use LoanSavingsSystem.DataCase

  alias LoanSavingsSystem.ConfirmationNotification

  describe "tbl_confirmation_notification" do
    alias LoanSavingsSystem.ConfirmationNotification.ConfirmationLoanNotification

    @valid_attrs %{message: "some message", read: true, recipientUserID: 42, recipientUserRoleId: 42, sentByUserId: 42, sentByUserRoleId: 42}
    @update_attrs %{message: "some updated message", read: false, recipientUserID: 43, recipientUserRoleId: 43, sentByUserId: 43, sentByUserRoleId: 43}
    @invalid_attrs %{message: nil, read: nil, recipientUserID: nil, recipientUserRoleId: nil, sentByUserId: nil, sentByUserRoleId: nil}

    def confirmation_loan_notification_fixture(attrs \\ %{}) do
      {:ok, confirmation_loan_notification} =
        attrs
        |> Enum.into(@valid_attrs)
        |> ConfirmationNotification.create_confirmation_loan_notification()

      confirmation_loan_notification
    end

    test "list_tbl_confirmation_notification/0 returns all tbl_confirmation_notification" do
      confirmation_loan_notification = confirmation_loan_notification_fixture()
      assert ConfirmationNotification.list_tbl_confirmation_notification() == [confirmation_loan_notification]
    end

    test "get_confirmation_loan_notification!/1 returns the confirmation_loan_notification with given id" do
      confirmation_loan_notification = confirmation_loan_notification_fixture()
      assert ConfirmationNotification.get_confirmation_loan_notification!(confirmation_loan_notification.id) == confirmation_loan_notification
    end

    test "create_confirmation_loan_notification/1 with valid data creates a confirmation_loan_notification" do
      assert {:ok, %ConfirmationLoanNotification{} = confirmation_loan_notification} = ConfirmationNotification.create_confirmation_loan_notification(@valid_attrs)
      assert confirmation_loan_notification.message == "some message"
      assert confirmation_loan_notification.read == true
      assert confirmation_loan_notification.recipientUserID == 42
      assert confirmation_loan_notification.recipientUserRoleId == 42
      assert confirmation_loan_notification.sentByUserId == 42
      assert confirmation_loan_notification.sentByUserRoleId == 42
    end

    test "create_confirmation_loan_notification/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ConfirmationNotification.create_confirmation_loan_notification(@invalid_attrs)
    end

    test "update_confirmation_loan_notification/2 with valid data updates the confirmation_loan_notification" do
      confirmation_loan_notification = confirmation_loan_notification_fixture()
      assert {:ok, %ConfirmationLoanNotification{} = confirmation_loan_notification} = ConfirmationNotification.update_confirmation_loan_notification(confirmation_loan_notification, @update_attrs)
      assert confirmation_loan_notification.message == "some updated message"
      assert confirmation_loan_notification.read == false
      assert confirmation_loan_notification.recipientUserID == 43
      assert confirmation_loan_notification.recipientUserRoleId == 43
      assert confirmation_loan_notification.sentByUserId == 43
      assert confirmation_loan_notification.sentByUserRoleId == 43
    end

    test "update_confirmation_loan_notification/2 with invalid data returns error changeset" do
      confirmation_loan_notification = confirmation_loan_notification_fixture()
      assert {:error, %Ecto.Changeset{}} = ConfirmationNotification.update_confirmation_loan_notification(confirmation_loan_notification, @invalid_attrs)
      assert confirmation_loan_notification == ConfirmationNotification.get_confirmation_loan_notification!(confirmation_loan_notification.id)
    end

    test "delete_confirmation_loan_notification/1 deletes the confirmation_loan_notification" do
      confirmation_loan_notification = confirmation_loan_notification_fixture()
      assert {:ok, %ConfirmationLoanNotification{}} = ConfirmationNotification.delete_confirmation_loan_notification(confirmation_loan_notification)
      assert_raise Ecto.NoResultsError, fn -> ConfirmationNotification.get_confirmation_loan_notification!(confirmation_loan_notification.id) end
    end

    test "change_confirmation_loan_notification/1 returns a confirmation_loan_notification changeset" do
      confirmation_loan_notification = confirmation_loan_notification_fixture()
      assert %Ecto.Changeset{} = ConfirmationNotification.change_confirmation_loan_notification(confirmation_loan_notification)
    end
  end
end
