defmodule LoanSavingsSystem.NotificationsTest do
  use LoanSavingsSystem.DataCase

  alias LoanSavingsSystem.Notifications

  describe "tbl_sms" do
    alias LoanSavingsSystem.Notifications.Sms

    @valid_attrs %{mobile: "some mobile", msg: "some msg", msg_countmsg: "some msg_countmsg", status: "some status", type: "some type"}
    @update_attrs %{mobile: "some updated mobile", msg: "some updated msg", msg_countmsg: "some updated msg_countmsg", status: "some updated status", type: "some updated type"}
    @invalid_attrs %{mobile: nil, msg: nil, msg_countmsg: nil, status: nil, type: nil}

    def sms_fixture(attrs \\ %{}) do
      {:ok, sms} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Notifications.create_sms()

      sms
    end

    test "list_tbl_sms/0 returns all tbl_sms" do
      sms = sms_fixture()
      assert Notifications.list_tbl_sms() == [sms]
    end

    test "get_sms!/1 returns the sms with given id" do
      sms = sms_fixture()
      assert Notifications.get_sms!(sms.id) == sms
    end

    test "create_sms/1 with valid data creates a sms" do
      assert {:ok, %Sms{} = sms} = Notifications.create_sms(@valid_attrs)
      assert sms.mobile == "some mobile"
      assert sms.msg == "some msg"
      assert sms.msg_countmsg == "some msg_countmsg"
      assert sms.status == "some status"
      assert sms.type == "some type"
    end

    test "create_sms/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Notifications.create_sms(@invalid_attrs)
    end

    test "update_sms/2 with valid data updates the sms" do
      sms = sms_fixture()
      assert {:ok, %Sms{} = sms} = Notifications.update_sms(sms, @update_attrs)
      assert sms.mobile == "some updated mobile"
      assert sms.msg == "some updated msg"
      assert sms.msg_countmsg == "some updated msg_countmsg"
      assert sms.status == "some updated status"
      assert sms.type == "some updated type"
    end

    test "update_sms/2 with invalid data returns error changeset" do
      sms = sms_fixture()
      assert {:error, %Ecto.Changeset{}} = Notifications.update_sms(sms, @invalid_attrs)
      assert sms == Notifications.get_sms!(sms.id)
    end

    test "delete_sms/1 deletes the sms" do
      sms = sms_fixture()
      assert {:ok, %Sms{}} = Notifications.delete_sms(sms)
      assert_raise Ecto.NoResultsError, fn -> Notifications.get_sms!(sms.id) end
    end

    test "change_sms/1 returns a sms changeset" do
      sms = sms_fixture()
      assert %Ecto.Changeset{} = Notifications.change_sms(sms)
    end
  end

  describe "tbl_sms" do
    alias LoanSavingsSystem.Notifications.Sms

    @valid_attrs %{mobile: "some mobile", msg: "some msg", msg_countmsg: "some msg_countmsg", status: "some status", type: "some type"}
    @update_attrs %{mobile: "some updated mobile", msg: "some updated msg", msg_countmsg: "some updated msg_countmsg", status: "some updated status", type: "some updated type"}
    @invalid_attrs %{mobile: nil, msg: nil, msg_countmsg: nil, status: nil, type: nil}

    def sms_fixture(attrs \\ %{}) do
      {:ok, sms} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Notifications.create_sms()

      sms
    end

    test "list_tbl_sms/0 returns all tbl_sms" do
      sms = sms_fixture()
      assert Notifications.list_tbl_sms() == [sms]
    end

    test "get_sms!/1 returns the sms with given id" do
      sms = sms_fixture()
      assert Notifications.get_sms!(sms.id) == sms
    end

    test "create_sms/1 with valid data creates a sms" do
      assert {:ok, %Sms{} = sms} = Notifications.create_sms(@valid_attrs)
      assert sms.mobile == "some mobile"
      assert sms.msg == "some msg"
      assert sms.msg_countmsg == "some msg_countmsg"
      assert sms.status == "some status"
      assert sms.type == "some type"
    end

    test "create_sms/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Notifications.create_sms(@invalid_attrs)
    end

    test "update_sms/2 with valid data updates the sms" do
      sms = sms_fixture()
      assert {:ok, %Sms{} = sms} = Notifications.update_sms(sms, @update_attrs)
      assert sms.mobile == "some updated mobile"
      assert sms.msg == "some updated msg"
      assert sms.msg_countmsg == "some updated msg_countmsg"
      assert sms.status == "some updated status"
      assert sms.type == "some updated type"
    end

    test "update_sms/2 with invalid data returns error changeset" do
      sms = sms_fixture()
      assert {:error, %Ecto.Changeset{}} = Notifications.update_sms(sms, @invalid_attrs)
      assert sms == Notifications.get_sms!(sms.id)
    end

    test "delete_sms/1 deletes the sms" do
      sms = sms_fixture()
      assert {:ok, %Sms{}} = Notifications.delete_sms(sms)
      assert_raise Ecto.NoResultsError, fn -> Notifications.get_sms!(sms.id) end
    end

    test "change_sms/1 returns a sms changeset" do
      sms = sms_fixture()
      assert %Ecto.Changeset{} = Notifications.change_sms(sms)
    end
  end
end
