defmodule LoanSavingsSystem.ClientTest do
  use LoanSavingsSystem.DataCase

  alias LoanSavingsSystem.Client

  describe "tbl_clients" do
    alias LoanSavingsSystem.Client.Clients

    @valid_attrs %{accountCreationEndpoint: "some accountCreationEndpoint", balanceEnquiryEndpoint: "some balanceEnquiryEndpoint", bankId: 42, countryId: 42, defaultCurrencyId: 42, defaultCurrencyName: "some defaultCurrencyName", fundsTransferEndpoint: "some fundsTransferEndpoint", isBank: true, isDomicileAccountAtBank: true, status: "some status"}
    @update_attrs %{accountCreationEndpoint: "some updated accountCreationEndpoint", balanceEnquiryEndpoint: "some updated balanceEnquiryEndpoint", bankId: 43, countryId: 43, defaultCurrencyId: 43, defaultCurrencyName: "some updated defaultCurrencyName", fundsTransferEndpoint: "some updated fundsTransferEndpoint", isBank: false, isDomicileAccountAtBank: false, status: "some updated status"}
    @invalid_attrs %{accountCreationEndpoint: nil, balanceEnquiryEndpoint: nil, bankId: nil, countryId: nil, defaultCurrencyId: nil, defaultCurrencyName: nil, fundsTransferEndpoint: nil, isBank: nil, isDomicileAccountAtBank: nil, status: nil}

    def clients_fixture(attrs \\ %{}) do
      {:ok, clients} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Client.create_clients()

      clients
    end

    test "list_tbl_clients/0 returns all tbl_clients" do
      clients = clients_fixture()
      assert Client.list_tbl_clients() == [clients]
    end

    test "get_clients!/1 returns the clients with given id" do
      clients = clients_fixture()
      assert Client.get_clients!(clients.id) == clients
    end

    test "create_clients/1 with valid data creates a clients" do
      assert {:ok, %Clients{} = clients} = Client.create_clients(@valid_attrs)
      assert clients.accountCreationEndpoint == "some accountCreationEndpoint"
      assert clients.balanceEnquiryEndpoint == "some balanceEnquiryEndpoint"
      assert clients.bankId == 42
      assert clients.countryId == 42
      assert clients.defaultCurrencyId == 42
      assert clients.defaultCurrencyName == "some defaultCurrencyName"
      assert clients.fundsTransferEndpoint == "some fundsTransferEndpoint"
      assert clients.isBank == true
      assert clients.isDomicileAccountAtBank == true
      assert clients.status == "some status"
    end

    test "create_clients/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Client.create_clients(@invalid_attrs)
    end

    test "update_clients/2 with valid data updates the clients" do
      clients = clients_fixture()
      assert {:ok, %Clients{} = clients} = Client.update_clients(clients, @update_attrs)
      assert clients.accountCreationEndpoint == "some updated accountCreationEndpoint"
      assert clients.balanceEnquiryEndpoint == "some updated balanceEnquiryEndpoint"
      assert clients.bankId == 43
      assert clients.countryId == 43
      assert clients.defaultCurrencyId == 43
      assert clients.defaultCurrencyName == "some updated defaultCurrencyName"
      assert clients.fundsTransferEndpoint == "some updated fundsTransferEndpoint"
      assert clients.isBank == false
      assert clients.isDomicileAccountAtBank == false
      assert clients.status == "some updated status"
    end

    test "update_clients/2 with invalid data returns error changeset" do
      clients = clients_fixture()
      assert {:error, %Ecto.Changeset{}} = Client.update_clients(clients, @invalid_attrs)
      assert clients == Client.get_clients!(clients.id)
    end

    test "delete_clients/1 deletes the clients" do
      clients = clients_fixture()
      assert {:ok, %Clients{}} = Client.delete_clients(clients)
      assert_raise Ecto.NoResultsError, fn -> Client.get_clients!(clients.id) end
    end

    test "change_clients/1 returns a clients changeset" do
      clients = clients_fixture()
      assert %Ecto.Changeset{} = Client.change_clients(clients)
    end
  end

  describe "tbl_client_setting" do
    alias LoanSavingsSystem.Client.ClientSetting

    @valid_attrs %{clientId: 42, emailSenderName: "some emailSenderName", emailSenderPassword: "some emailSenderPassword", emailSenderUsername: "some emailSenderUsername", smsEndPoint: "some smsEndPoint", smsSenderName: "some smsSenderName", status: "some status"}
    @update_attrs %{clientId: 43, emailSenderName: "some updated emailSenderName", emailSenderPassword: "some updated emailSenderPassword", emailSenderUsername: "some updated emailSenderUsername", smsEndPoint: "some updated smsEndPoint", smsSenderName: "some updated smsSenderName", status: "some updated status"}
    @invalid_attrs %{clientId: nil, emailSenderName: nil, emailSenderPassword: nil, emailSenderUsername: nil, smsEndPoint: nil, smsSenderName: nil, status: nil}

    def client_setting_fixture(attrs \\ %{}) do
      {:ok, client_setting} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Client.create_client_setting()

      client_setting
    end

    test "list_tbl_client_setting/0 returns all tbl_client_setting" do
      client_setting = client_setting_fixture()
      assert Client.list_tbl_client_setting() == [client_setting]
    end

    test "get_client_setting!/1 returns the client_setting with given id" do
      client_setting = client_setting_fixture()
      assert Client.get_client_setting!(client_setting.id) == client_setting
    end

    test "create_client_setting/1 with valid data creates a client_setting" do
      assert {:ok, %ClientSetting{} = client_setting} = Client.create_client_setting(@valid_attrs)
      assert client_setting.clientId == 42
      assert client_setting.emailSenderName == "some emailSenderName"
      assert client_setting.emailSenderPassword == "some emailSenderPassword"
      assert client_setting.emailSenderUsername == "some emailSenderUsername"
      assert client_setting.smsEndPoint == "some smsEndPoint"
      assert client_setting.smsSenderName == "some smsSenderName"
      assert client_setting.status == "some status"
    end

    test "create_client_setting/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Client.create_client_setting(@invalid_attrs)
    end

    test "update_client_setting/2 with valid data updates the client_setting" do
      client_setting = client_setting_fixture()
      assert {:ok, %ClientSetting{} = client_setting} = Client.update_client_setting(client_setting, @update_attrs)
      assert client_setting.clientId == 43
      assert client_setting.emailSenderName == "some updated emailSenderName"
      assert client_setting.emailSenderPassword == "some updated emailSenderPassword"
      assert client_setting.emailSenderUsername == "some updated emailSenderUsername"
      assert client_setting.smsEndPoint == "some updated smsEndPoint"
      assert client_setting.smsSenderName == "some updated smsSenderName"
      assert client_setting.status == "some updated status"
    end

    test "update_client_setting/2 with invalid data returns error changeset" do
      client_setting = client_setting_fixture()
      assert {:error, %Ecto.Changeset{}} = Client.update_client_setting(client_setting, @invalid_attrs)
      assert client_setting == Client.get_client_setting!(client_setting.id)
    end

    test "delete_client_setting/1 deletes the client_setting" do
      client_setting = client_setting_fixture()
      assert {:ok, %ClientSetting{}} = Client.delete_client_setting(client_setting)
      assert_raise Ecto.NoResultsError, fn -> Client.get_client_setting!(client_setting.id) end
    end

    test "change_client_setting/1 returns a client_setting changeset" do
      client_setting = client_setting_fixture()
      assert %Ecto.Changeset{} = Client.change_client_setting(client_setting)
    end
  end

  describe "tbl_user_bio_data" do
    alias LoanSavingsSystem.Client.UserBioData

    @valid_attrs %{clientId: 42, dateOfBirth: ~D[2010-04-17], emailAddress: "some emailAddress", firstName: "some firstName", gender: "some gender", lastName: "some lastName", meansOfIdentificationNumber: "some meansOfIdentificationNumber", meansOfIdentificationType: "some meansOfIdentificationType", mobileNumber: "some mobileNumber", therName: "some therName", title: "some title", userId: 42}
    @update_attrs %{clientId: 43, dateOfBirth: ~D[2011-05-18], emailAddress: "some updated emailAddress", firstName: "some updated firstName", gender: "some updated gender", lastName: "some updated lastName", meansOfIdentificationNumber: "some updated meansOfIdentificationNumber", meansOfIdentificationType: "some updated meansOfIdentificationType", mobileNumber: "some updated mobileNumber", therName: "some updated therName", title: "some updated title", userId: 43}
    @invalid_attrs %{clientId: nil, dateOfBirth: nil, emailAddress: nil, firstName: nil, gender: nil, lastName: nil, meansOfIdentificationNumber: nil, meansOfIdentificationType: nil, mobileNumber: nil, therName: nil, title: nil, userId: nil}

    def user_bio_data_fixture(attrs \\ %{}) do
      {:ok, user_bio_data} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Client.create_user_bio_data()

      user_bio_data
    end

    test "list_tbl_user_bio_data/0 returns all tbl_user_bio_data" do
      user_bio_data = user_bio_data_fixture()
      assert Client.list_tbl_user_bio_data() == [user_bio_data]
    end

    test "get_user_bio_data!/1 returns the user_bio_data with given id" do
      user_bio_data = user_bio_data_fixture()
      assert Client.get_user_bio_data!(user_bio_data.id) == user_bio_data
    end

    test "create_user_bio_data/1 with valid data creates a user_bio_data" do
      assert {:ok, %UserBioData{} = user_bio_data} = Client.create_user_bio_data(@valid_attrs)
      assert user_bio_data.clientId == 42
      assert user_bio_data.dateOfBirth == ~D[2010-04-17]
      assert user_bio_data.emailAddress == "some emailAddress"
      assert user_bio_data.firstName == "some firstName"
      assert user_bio_data.gender == "some gender"
      assert user_bio_data.lastName == "some lastName"
      assert user_bio_data.meansOfIdentificationNumber == "some meansOfIdentificationNumber"
      assert user_bio_data.meansOfIdentificationType == "some meansOfIdentificationType"
      assert user_bio_data.mobileNumber == "some mobileNumber"
      assert user_bio_data.therName == "some therName"
      assert user_bio_data.title == "some title"
      assert user_bio_data.userId == 42
    end

    test "create_user_bio_data/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Client.create_user_bio_data(@invalid_attrs)
    end

    test "update_user_bio_data/2 with valid data updates the user_bio_data" do
      user_bio_data = user_bio_data_fixture()
      assert {:ok, %UserBioData{} = user_bio_data} = Client.update_user_bio_data(user_bio_data, @update_attrs)
      assert user_bio_data.clientId == 43
      assert user_bio_data.dateOfBirth == ~D[2011-05-18]
      assert user_bio_data.emailAddress == "some updated emailAddress"
      assert user_bio_data.firstName == "some updated firstName"
      assert user_bio_data.gender == "some updated gender"
      assert user_bio_data.lastName == "some updated lastName"
      assert user_bio_data.meansOfIdentificationNumber == "some updated meansOfIdentificationNumber"
      assert user_bio_data.meansOfIdentificationType == "some updated meansOfIdentificationType"
      assert user_bio_data.mobileNumber == "some updated mobileNumber"
      assert user_bio_data.therName == "some updated therName"
      assert user_bio_data.title == "some updated title"
      assert user_bio_data.userId == 43
    end

    test "update_user_bio_data/2 with invalid data returns error changeset" do
      user_bio_data = user_bio_data_fixture()
      assert {:error, %Ecto.Changeset{}} = Client.update_user_bio_data(user_bio_data, @invalid_attrs)
      assert user_bio_data == Client.get_user_bio_data!(user_bio_data.id)
    end

    test "delete_user_bio_data/1 deletes the user_bio_data" do
      user_bio_data = user_bio_data_fixture()
      assert {:ok, %UserBioData{}} = Client.delete_user_bio_data(user_bio_data)
      assert_raise Ecto.NoResultsError, fn -> Client.get_user_bio_data!(user_bio_data.id) end
    end

    test "change_user_bio_data/1 returns a user_bio_data changeset" do
      user_bio_data = user_bio_data_fixture()
      assert %Ecto.Changeset{} = Client.change_user_bio_data(user_bio_data)
    end
  end

  describe "tbl_addresses" do
    alias LoanSavingsSystem.Client.Address

    @valid_attrs %{addressLine1: "some addressLine1", addressLine2: "some addressLine2", city: "some city", clientId: 42, countryId: 42, countryName: "some countryName", districtId: 42, districtName: "some districtName", isCurrent: true, provinceId: 42, provinceName: "some provinceName", userId: 42}
    @update_attrs %{addressLine1: "some updated addressLine1", addressLine2: "some updated addressLine2", city: "some updated city", clientId: 43, countryId: 43, countryName: "some updated countryName", districtId: 43, districtName: "some updated districtName", isCurrent: false, provinceId: 43, provinceName: "some updated provinceName", userId: 43}
    @invalid_attrs %{addressLine1: nil, addressLine2: nil, city: nil, clientId: nil, countryId: nil, countryName: nil, districtId: nil, districtName: nil, isCurrent: nil, provinceId: nil, provinceName: nil, userId: nil}

    def address_fixture(attrs \\ %{}) do
      {:ok, address} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Client.create_address()

      address
    end

    test "list_tbl_addresses/0 returns all tbl_addresses" do
      address = address_fixture()
      assert Client.list_tbl_addresses() == [address]
    end

    test "get_address!/1 returns the address with given id" do
      address = address_fixture()
      assert Client.get_address!(address.id) == address
    end

    test "create_address/1 with valid data creates a address" do
      assert {:ok, %Address{} = address} = Client.create_address(@valid_attrs)
      assert address.addressLine1 == "some addressLine1"
      assert address.addressLine2 == "some addressLine2"
      assert address.city == "some city"
      assert address.clientId == 42
      assert address.countryId == 42
      assert address.countryName == "some countryName"
      assert address.districtId == 42
      assert address.districtName == "some districtName"
      assert address.isCurrent == true
      assert address.provinceId == 42
      assert address.provinceName == "some provinceName"
      assert address.userId == 42
    end

    test "create_address/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Client.create_address(@invalid_attrs)
    end

    test "update_address/2 with valid data updates the address" do
      address = address_fixture()
      assert {:ok, %Address{} = address} = Client.update_address(address, @update_attrs)
      assert address.addressLine1 == "some updated addressLine1"
      assert address.addressLine2 == "some updated addressLine2"
      assert address.city == "some updated city"
      assert address.clientId == 43
      assert address.countryId == 43
      assert address.countryName == "some updated countryName"
      assert address.districtId == 43
      assert address.districtName == "some updated districtName"
      assert address.isCurrent == false
      assert address.provinceId == 43
      assert address.provinceName == "some updated provinceName"
      assert address.userId == 43
    end

    test "update_address/2 with invalid data returns error changeset" do
      address = address_fixture()
      assert {:error, %Ecto.Changeset{}} = Client.update_address(address, @invalid_attrs)
      assert address == Client.get_address!(address.id)
    end

    test "delete_address/1 deletes the address" do
      address = address_fixture()
      assert {:ok, %Address{}} = Client.delete_address(address)
      assert_raise Ecto.NoResultsError, fn -> Client.get_address!(address.id) end
    end

    test "change_address/1 returns a address changeset" do
      address = address_fixture()
      assert %Ecto.Changeset{} = Client.change_address(address)
    end
  end

  describe "tbl_next_of_kin" do
    alias LoanSavingsSystem.Client.NextOfKin

    @valid_attrs %{accountId: 42, addressLine1: "some addressLine1", addressLine2: "some addressLine2", city: "some city", clientId: 42, districtId: 42, districtName: "some districtName", firstName: "some firstName", lastName: "some lastName", otherName: "some otherName", provinceId: 42, provinceName: "some provinceName", userId: 42}
    @update_attrs %{accountId: 43, addressLine1: "some updated addressLine1", addressLine2: "some updated addressLine2", city: "some updated city", clientId: 43, districtId: 43, districtName: "some updated districtName", firstName: "some updated firstName", lastName: "some updated lastName", otherName: "some updated otherName", provinceId: 43, provinceName: "some updated provinceName", userId: 43}
    @invalid_attrs %{accountId: nil, addressLine1: nil, addressLine2: nil, city: nil, clientId: nil, districtId: nil, districtName: nil, firstName: nil, lastName: nil, otherName: nil, provinceId: nil, provinceName: nil, userId: nil}

    def next_of_kin_fixture(attrs \\ %{}) do
      {:ok, next_of_kin} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Client.create_next_of_kin()

      next_of_kin
    end

    test "list_tbl_next_of_kin/0 returns all tbl_next_of_kin" do
      next_of_kin = next_of_kin_fixture()
      assert Client.list_tbl_next_of_kin() == [next_of_kin]
    end

    test "get_next_of_kin!/1 returns the next_of_kin with given id" do
      next_of_kin = next_of_kin_fixture()
      assert Client.get_next_of_kin!(next_of_kin.id) == next_of_kin
    end

    test "create_next_of_kin/1 with valid data creates a next_of_kin" do
      assert {:ok, %NextOfKin{} = next_of_kin} = Client.create_next_of_kin(@valid_attrs)
      assert next_of_kin.accountId == 42
      assert next_of_kin.addressLine1 == "some addressLine1"
      assert next_of_kin.addressLine2 == "some addressLine2"
      assert next_of_kin.city == "some city"
      assert next_of_kin.clientId == 42
      assert next_of_kin.districtId == 42
      assert next_of_kin.districtName == "some districtName"
      assert next_of_kin.firstName == "some firstName"
      assert next_of_kin.lastName == "some lastName"
      assert next_of_kin.otherName == "some otherName"
      assert next_of_kin.provinceId == 42
      assert next_of_kin.provinceName == "some provinceName"
      assert next_of_kin.userId == 42
    end

    test "create_next_of_kin/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Client.create_next_of_kin(@invalid_attrs)
    end

    test "update_next_of_kin/2 with valid data updates the next_of_kin" do
      next_of_kin = next_of_kin_fixture()
      assert {:ok, %NextOfKin{} = next_of_kin} = Client.update_next_of_kin(next_of_kin, @update_attrs)
      assert next_of_kin.accountId == 43
      assert next_of_kin.addressLine1 == "some updated addressLine1"
      assert next_of_kin.addressLine2 == "some updated addressLine2"
      assert next_of_kin.city == "some updated city"
      assert next_of_kin.clientId == 43
      assert next_of_kin.districtId == 43
      assert next_of_kin.districtName == "some updated districtName"
      assert next_of_kin.firstName == "some updated firstName"
      assert next_of_kin.lastName == "some updated lastName"
      assert next_of_kin.otherName == "some updated otherName"
      assert next_of_kin.provinceId == 43
      assert next_of_kin.provinceName == "some updated provinceName"
      assert next_of_kin.userId == 43
    end

    test "update_next_of_kin/2 with invalid data returns error changeset" do
      next_of_kin = next_of_kin_fixture()
      assert {:error, %Ecto.Changeset{}} = Client.update_next_of_kin(next_of_kin, @invalid_attrs)
      assert next_of_kin == Client.get_next_of_kin!(next_of_kin.id)
    end

    test "delete_next_of_kin/1 deletes the next_of_kin" do
      next_of_kin = next_of_kin_fixture()
      assert {:ok, %NextOfKin{}} = Client.delete_next_of_kin(next_of_kin)
      assert_raise Ecto.NoResultsError, fn -> Client.get_next_of_kin!(next_of_kin.id) end
    end

    test "change_next_of_kin/1 returns a next_of_kin changeset" do
      next_of_kin = next_of_kin_fixture()
      assert %Ecto.Changeset{} = Client.change_next_of_kin(next_of_kin)
    end
  end

  describe "tbl_banks" do
    alias LoanSavingsSystem.Client.Banks

    @valid_attrs %{eod_url: "some eod_url", name: "some name"}
    @update_attrs %{eod_url: "some updated eod_url", name: "some updated name"}
    @invalid_attrs %{eod_url: nil, name: nil}

    def banks_fixture(attrs \\ %{}) do
      {:ok, banks} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Client.create_banks()

      banks
    end

    test "list_tbl_banks/0 returns all tbl_banks" do
      banks = banks_fixture()
      assert Client.list_tbl_banks() == [banks]
    end

    test "get_banks!/1 returns the banks with given id" do
      banks = banks_fixture()
      assert Client.get_banks!(banks.id) == banks
    end

    test "create_banks/1 with valid data creates a banks" do
      assert {:ok, %Banks{} = banks} = Client.create_banks(@valid_attrs)
      assert banks.eod_url == "some eod_url"
      assert banks.name == "some name"
    end

    test "create_banks/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Client.create_banks(@invalid_attrs)
    end

    test "update_banks/2 with valid data updates the banks" do
      banks = banks_fixture()
      assert {:ok, %Banks{} = banks} = Client.update_banks(banks, @update_attrs)
      assert banks.eod_url == "some updated eod_url"
      assert banks.name == "some updated name"
    end

    test "update_banks/2 with invalid data returns error changeset" do
      banks = banks_fixture()
      assert {:error, %Ecto.Changeset{}} = Client.update_banks(banks, @invalid_attrs)
      assert banks == Client.get_banks!(banks.id)
    end

    test "delete_banks/1 deletes the banks" do
      banks = banks_fixture()
      assert {:ok, %Banks{}} = Client.delete_banks(banks)
      assert_raise Ecto.NoResultsError, fn -> Client.get_banks!(banks.id) end
    end

    test "change_banks/1 returns a banks changeset" do
      banks = banks_fixture()
      assert %Ecto.Changeset{} = Client.change_banks(banks)
    end
  end
end
