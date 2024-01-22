defmodule Loanmanagementsystem.MerchantsTest do
  use Loanmanagementsystem.DataCase

  alias Loanmanagementsystem.Merchants

  describe "tbl_merchant" do
    alias Loanmanagementsystem.Merchants.Merchant

    @valid_attrs %{
      approval_trail: "some approval_trail",
      authLevel: 42,
      bankId: 42,
      businessName: "some businessName",
      businessNature: "some businessNature",
      companyAccountNumber: "some companyAccountNumber",
      companyName: "some companyName",
      companyPhone: "some companyPhone",
      companyRegistrationDate: ~D[2010-04-17],
      contactEmail: "some contactEmail",
      createdByUserId: 42,
      createdByUserRoleId: 42,
      merchantType: "some merchantType",
      registrationNumber: "some registrationNumber",
      status: "some status",
      taxno: "some taxno"
    }
    @update_attrs %{
      approval_trail: "some updated approval_trail",
      authLevel: 43,
      bankId: 43,
      businessName: "some updated businessName",
      businessNature: "some updated businessNature",
      companyAccountNumber: "some updated companyAccountNumber",
      companyName: "some updated companyName",
      companyPhone: "some updated companyPhone",
      companyRegistrationDate: ~D[2011-05-18],
      contactEmail: "some updated contactEmail",
      createdByUserId: 43,
      createdByUserRoleId: 43,
      merchantType: "some updated merchantType",
      registrationNumber: "some updated registrationNumber",
      status: "some updated status",
      taxno: "some updated taxno"
    }
    @invalid_attrs %{
      approval_trail: nil,
      authLevel: nil,
      bankId: nil,
      businessName: nil,
      businessNature: nil,
      companyAccountNumber: nil,
      companyName: nil,
      companyPhone: nil,
      companyRegistrationDate: nil,
      contactEmail: nil,
      createdByUserId: nil,
      createdByUserRoleId: nil,
      merchantType: nil,
      registrationNumber: nil,
      status: nil,
      taxno: nil
    }

    def merchant_fixture(attrs \\ %{}) do
      {:ok, merchant} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Merchants.create_merchant()

      merchant
    end

    test "list_tbl_merchant/0 returns all tbl_merchant" do
      merchant = merchant_fixture()
      assert Merchants.list_tbl_merchant() == [merchant]
    end

    test "get_merchant!/1 returns the merchant with given id" do
      merchant = merchant_fixture()
      assert Merchants.get_merchant!(merchant.id) == merchant
    end

    test "create_merchant/1 with valid data creates a merchant" do
      assert {:ok, %Merchant{} = merchant} = Merchants.create_merchant(@valid_attrs)
      assert merchant.approval_trail == "some approval_trail"
      assert merchant.authLevel == 42
      assert merchant.bankId == 42
      assert merchant.businessName == "some businessName"
      assert merchant.businessNature == "some businessNature"
      assert merchant.companyAccountNumber == "some companyAccountNumber"
      assert merchant.companyName == "some companyName"
      assert merchant.companyPhone == "some companyPhone"
      assert merchant.companyRegistrationDate == ~D[2010-04-17]
      assert merchant.contactEmail == "some contactEmail"
      assert merchant.createdByUserId == 42
      assert merchant.createdByUserRoleId == 42
      assert merchant.merchantType == "some merchantType"
      assert merchant.registrationNumber == "some registrationNumber"
      assert merchant.status == "some status"
      assert merchant.taxno == "some taxno"
    end

    test "create_merchant/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Merchants.create_merchant(@invalid_attrs)
    end

    test "update_merchant/2 with valid data updates the merchant" do
      merchant = merchant_fixture()
      assert {:ok, %Merchant{} = merchant} = Merchants.update_merchant(merchant, @update_attrs)
      assert merchant.approval_trail == "some updated approval_trail"
      assert merchant.authLevel == 43
      assert merchant.bankId == 43
      assert merchant.businessName == "some updated businessName"
      assert merchant.businessNature == "some updated businessNature"
      assert merchant.companyAccountNumber == "some updated companyAccountNumber"
      assert merchant.companyName == "some updated companyName"
      assert merchant.companyPhone == "some updated companyPhone"
      assert merchant.companyRegistrationDate == ~D[2011-05-18]
      assert merchant.contactEmail == "some updated contactEmail"
      assert merchant.createdByUserId == 43
      assert merchant.createdByUserRoleId == 43
      assert merchant.merchantType == "some updated merchantType"
      assert merchant.registrationNumber == "some updated registrationNumber"
      assert merchant.status == "some updated status"
      assert merchant.taxno == "some updated taxno"
    end

    test "update_merchant/2 with invalid data returns error changeset" do
      merchant = merchant_fixture()
      assert {:error, %Ecto.Changeset{}} = Merchants.update_merchant(merchant, @invalid_attrs)
      assert merchant == Merchants.get_merchant!(merchant.id)
    end

    test "delete_merchant/1 deletes the merchant" do
      merchant = merchant_fixture()
      assert {:ok, %Merchant{}} = Merchants.delete_merchant(merchant)
      assert_raise Ecto.NoResultsError, fn -> Merchants.get_merchant!(merchant.id) end
    end

    test "change_merchant/1 returns a merchant changeset" do
      merchant = merchant_fixture()
      assert %Ecto.Changeset{} = Merchants.change_merchant(merchant)
    end
  end

  describe "tbl_merchant_dir" do
    alias Loanmanagementsystem.Merchants.Merchant_director

    @valid_attrs %{
      directorIdType: "some directorIdType",
      directorIdentificationnNumber: "some directorIdentificationnNumber",
      emailAddress: "some emailAddress",
      firstName: "some firstName",
      lastName: "some lastName",
      merchantId: "some merchantId",
      merchantType: "some merchantType",
      mobileNumber: "some mobileNumber",
      otherName: "some otherName",
      status: "some status"
    }
    @update_attrs %{
      directorIdType: "some updated directorIdType",
      directorIdentificationnNumber: "some updated directorIdentificationnNumber",
      emailAddress: "some updated emailAddress",
      firstName: "some updated firstName",
      lastName: "some updated lastName",
      merchantId: "some updated merchantId",
      merchantType: "some updated merchantType",
      mobileNumber: "some updated mobileNumber",
      otherName: "some updated otherName",
      status: "some updated status"
    }
    @invalid_attrs %{
      directorIdType: nil,
      directorIdentificationnNumber: nil,
      emailAddress: nil,
      firstName: nil,
      lastName: nil,
      merchantId: nil,
      merchantType: nil,
      mobileNumber: nil,
      otherName: nil,
      status: nil
    }

    def merchant_director_fixture(attrs \\ %{}) do
      {:ok, merchant_director} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Merchants.create_merchant_director()

      merchant_director
    end

    test "list_tbl_merchant_dir/0 returns all tbl_merchant_dir" do
      merchant_director = merchant_director_fixture()
      assert Merchants.list_tbl_merchant_dir() == [merchant_director]
    end

    test "get_merchant_director!/1 returns the merchant_director with given id" do
      merchant_director = merchant_director_fixture()
      assert Merchants.get_merchant_director!(merchant_director.id) == merchant_director
    end

    test "create_merchant_director/1 with valid data creates a merchant_director" do
      assert {:ok, %Merchant_director{} = merchant_director} =
               Merchants.create_merchant_director(@valid_attrs)

      assert merchant_director.directorIdType == "some directorIdType"

      assert merchant_director.directorIdentificationnNumber ==
               "some directorIdentificationnNumber"

      assert merchant_director.emailAddress == "some emailAddress"
      assert merchant_director.firstName == "some firstName"
      assert merchant_director.lastName == "some lastName"
      assert merchant_director.merchantId == "some merchantId"
      assert merchant_director.merchantType == "some merchantType"
      assert merchant_director.mobileNumber == "some mobileNumber"
      assert merchant_director.otherName == "some otherName"
      assert merchant_director.status == "some status"
    end

    test "create_merchant_director/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Merchants.create_merchant_director(@invalid_attrs)
    end

    test "update_merchant_director/2 with valid data updates the merchant_director" do
      merchant_director = merchant_director_fixture()

      assert {:ok, %Merchant_director{} = merchant_director} =
               Merchants.update_merchant_director(merchant_director, @update_attrs)

      assert merchant_director.directorIdType == "some updated directorIdType"

      assert merchant_director.directorIdentificationnNumber ==
               "some updated directorIdentificationnNumber"

      assert merchant_director.emailAddress == "some updated emailAddress"
      assert merchant_director.firstName == "some updated firstName"
      assert merchant_director.lastName == "some updated lastName"
      assert merchant_director.merchantId == "some updated merchantId"
      assert merchant_director.merchantType == "some updated merchantType"
      assert merchant_director.mobileNumber == "some updated mobileNumber"
      assert merchant_director.otherName == "some updated otherName"
      assert merchant_director.status == "some updated status"
    end

    test "update_merchant_director/2 with invalid data returns error changeset" do
      merchant_director = merchant_director_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Merchants.update_merchant_director(merchant_director, @invalid_attrs)

      assert merchant_director == Merchants.get_merchant_director!(merchant_director.id)
    end

    test "delete_merchant_director/1 deletes the merchant_director" do
      merchant_director = merchant_director_fixture()
      assert {:ok, %Merchant_director{}} = Merchants.delete_merchant_director(merchant_director)

      assert_raise Ecto.NoResultsError, fn ->
        Merchants.get_merchant_director!(merchant_director.id)
      end
    end

    test "change_merchant_director/1 returns a merchant_director changeset" do
      merchant_director = merchant_director_fixture()
      assert %Ecto.Changeset{} = Merchants.change_merchant_director(merchant_director)
    end
  end

  describe "tbl_merchant_device" do
    alias Loanmanagementsystem.Merchants.Merchants_device

    @valid_attrs %{
      deviceAgentLine: "some deviceAgentLine",
      deviceIMEI: "some deviceIMEI",
      deviceModel: "some deviceModel",
      deviceName: "some deviceName",
      deviceType: "some deviceType",
      merchantId: 42
    }
    @update_attrs %{
      deviceAgentLine: "some updated deviceAgentLine",
      deviceIMEI: "some updated deviceIMEI",
      deviceModel: "some updated deviceModel",
      deviceName: "some updated deviceName",
      deviceType: "some updated deviceType",
      merchantId: 43
    }
    @invalid_attrs %{
      deviceAgentLine: nil,
      deviceIMEI: nil,
      deviceModel: nil,
      deviceName: nil,
      deviceType: nil,
      merchantId: nil
    }

    def merchants_device_fixture(attrs \\ %{}) do
      {:ok, merchants_device} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Merchants.create_merchants_device()

      merchants_device
    end

    test "list_tbl_merchant_device/0 returns all tbl_merchant_device" do
      merchants_device = merchants_device_fixture()
      assert Merchants.list_tbl_merchant_device() == [merchants_device]
    end

    test "get_merchants_device!/1 returns the merchants_device with given id" do
      merchants_device = merchants_device_fixture()
      assert Merchants.get_merchants_device!(merchants_device.id) == merchants_device
    end

    test "create_merchants_device/1 with valid data creates a merchants_device" do
      assert {:ok, %Merchants_device{} = merchants_device} =
               Merchants.create_merchants_device(@valid_attrs)

      assert merchants_device.deviceAgentLine == "some deviceAgentLine"
      assert merchants_device.deviceIMEI == "some deviceIMEI"
      assert merchants_device.deviceModel == "some deviceModel"
      assert merchants_device.deviceName == "some deviceName"
      assert merchants_device.deviceType == "some deviceType"
      assert merchants_device.merchantId == 42
    end

    test "create_merchants_device/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Merchants.create_merchants_device(@invalid_attrs)
    end

    test "update_merchants_device/2 with valid data updates the merchants_device" do
      merchants_device = merchants_device_fixture()

      assert {:ok, %Merchants_device{} = merchants_device} =
               Merchants.update_merchants_device(merchants_device, @update_attrs)

      assert merchants_device.deviceAgentLine == "some updated deviceAgentLine"
      assert merchants_device.deviceIMEI == "some updated deviceIMEI"
      assert merchants_device.deviceModel == "some updated deviceModel"
      assert merchants_device.deviceName == "some updated deviceName"
      assert merchants_device.deviceType == "some updated deviceType"
      assert merchants_device.merchantId == 43
    end

    test "update_merchants_device/2 with invalid data returns error changeset" do
      merchants_device = merchants_device_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Merchants.update_merchants_device(merchants_device, @invalid_attrs)

      assert merchants_device == Merchants.get_merchants_device!(merchants_device.id)
    end

    test "delete_merchants_device/1 deletes the merchants_device" do
      merchants_device = merchants_device_fixture()
      assert {:ok, %Merchants_device{}} = Merchants.delete_merchants_device(merchants_device)

      assert_raise Ecto.NoResultsError, fn ->
        Merchants.get_merchants_device!(merchants_device.id)
      end
    end

    test "change_merchants_device/1 returns a merchants_device changeset" do
      merchants_device = merchants_device_fixture()
      assert %Ecto.Changeset{} = Merchants.change_merchants_device(merchants_device)
    end
  end

  describe "tbl_merchant_and_agent_doc" do
    alias Loanmanagementsystem.Merchants.Merchants_document

    @valid_attrs %{
      companyID: 42,
      docName: "some docName",
      docType: "some docType",
      path: "some path",
      status: "some status",
      taxNo: "some taxNo",
      userID: 42
    }
    @update_attrs %{
      companyID: 43,
      docName: "some updated docName",
      docType: "some updated docType",
      path: "some updated path",
      status: "some updated status",
      taxNo: "some updated taxNo",
      userID: 43
    }
    @invalid_attrs %{
      companyID: nil,
      docName: nil,
      docType: nil,
      path: nil,
      status: nil,
      taxNo: nil,
      userID: nil
    }

    def merchants_document_fixture(attrs \\ %{}) do
      {:ok, merchants_document} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Merchants.create_merchants_document()

      merchants_document
    end

    test "list_tbl_merchant_and_agent_doc/0 returns all tbl_merchant_and_agent_doc" do
      merchants_document = merchants_document_fixture()
      assert Merchants.list_tbl_merchant_and_agent_doc() == [merchants_document]
    end

    test "get_merchants_document!/1 returns the merchants_document with given id" do
      merchants_document = merchants_document_fixture()
      assert Merchants.get_merchants_document!(merchants_document.id) == merchants_document
    end

    test "create_merchants_document/1 with valid data creates a merchants_document" do
      assert {:ok, %Merchants_document{} = merchants_document} =
               Merchants.create_merchants_document(@valid_attrs)

      assert merchants_document.companyID == 42
      assert merchants_document.docName == "some docName"
      assert merchants_document.docType == "some docType"
      assert merchants_document.path == "some path"
      assert merchants_document.status == "some status"
      assert merchants_document.taxNo == "some taxNo"
      assert merchants_document.userID == 42
    end

    test "create_merchants_document/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Merchants.create_merchants_document(@invalid_attrs)
    end

    test "update_merchants_document/2 with valid data updates the merchants_document" do
      merchants_document = merchants_document_fixture()

      assert {:ok, %Merchants_document{} = merchants_document} =
               Merchants.update_merchants_document(merchants_document, @update_attrs)

      assert merchants_document.companyID == 43
      assert merchants_document.docName == "some updated docName"
      assert merchants_document.docType == "some updated docType"
      assert merchants_document.path == "some updated path"
      assert merchants_document.status == "some updated status"
      assert merchants_document.taxNo == "some updated taxNo"
      assert merchants_document.userID == 43
    end

    test "update_merchants_document/2 with invalid data returns error changeset" do
      merchants_document = merchants_document_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Merchants.update_merchants_document(merchants_document, @invalid_attrs)

      assert merchants_document == Merchants.get_merchants_document!(merchants_document.id)
    end

    test "delete_merchants_document/1 deletes the merchants_document" do
      merchants_document = merchants_document_fixture()

      assert {:ok, %Merchants_document{}} =
               Merchants.delete_merchants_document(merchants_document)

      assert_raise Ecto.NoResultsError, fn ->
        Merchants.get_merchants_document!(merchants_document.id)
      end
    end

    test "change_merchants_document/1 returns a merchants_document changeset" do
      merchants_document = merchants_document_fixture()
      assert %Ecto.Changeset{} = Merchants.change_merchants_document(merchants_document)
    end
  end

  describe "tbl_merchant_account" do
    alias Loanmanagementsystem.Merchants.Merchant_account

    @valid_attrs %{balance: 120.5, merchant_id: 42, merchant_number: "some merchant_number", status: "some status"}
    @update_attrs %{balance: 456.7, merchant_id: 43, merchant_number: "some updated merchant_number", status: "some updated status"}
    @invalid_attrs %{balance: nil, merchant_id: nil, merchant_number: nil, status: nil}

    def merchant_account_fixture(attrs \\ %{}) do
      {:ok, merchant_account} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Merchants.create_merchant_account()

      merchant_account
    end

    test "list_tbl_merchant_account/0 returns all tbl_merchant_account" do
      merchant_account = merchant_account_fixture()
      assert Merchants.list_tbl_merchant_account() == [merchant_account]
    end

    test "get_merchant_account!/1 returns the merchant_account with given id" do
      merchant_account = merchant_account_fixture()
      assert Merchants.get_merchant_account!(merchant_account.id) == merchant_account
    end

    test "create_merchant_account/1 with valid data creates a merchant_account" do
      assert {:ok, %Merchant_account{} = merchant_account} = Merchants.create_merchant_account(@valid_attrs)
      assert merchant_account.balance == 120.5
      assert merchant_account.merchant_id == 42
      assert merchant_account.merchant_number == "some merchant_number"
      assert merchant_account.status == "some status"
    end

    test "create_merchant_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Merchants.create_merchant_account(@invalid_attrs)
    end

    test "update_merchant_account/2 with valid data updates the merchant_account" do
      merchant_account = merchant_account_fixture()
      assert {:ok, %Merchant_account{} = merchant_account} = Merchants.update_merchant_account(merchant_account, @update_attrs)
      assert merchant_account.balance == 456.7
      assert merchant_account.merchant_id == 43
      assert merchant_account.merchant_number == "some updated merchant_number"
      assert merchant_account.status == "some updated status"
    end

    test "update_merchant_account/2 with invalid data returns error changeset" do
      merchant_account = merchant_account_fixture()
      assert {:error, %Ecto.Changeset{}} = Merchants.update_merchant_account(merchant_account, @invalid_attrs)
      assert merchant_account == Merchants.get_merchant_account!(merchant_account.id)
    end

    test "delete_merchant_account/1 deletes the merchant_account" do
      merchant_account = merchant_account_fixture()
      assert {:ok, %Merchant_account{}} = Merchants.delete_merchant_account(merchant_account)
      assert_raise Ecto.NoResultsError, fn -> Merchants.get_merchant_account!(merchant_account.id) end
    end

    test "change_merchant_account/1 returns a merchant_account changeset" do
      merchant_account = merchant_account_fixture()
      assert %Ecto.Changeset{} = Merchants.change_merchant_account(merchant_account)
    end
  end
end
