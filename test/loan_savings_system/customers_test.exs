defmodule LoanSavingsSystem.CustomersTest do
  use LoanSavingsSystem.DataCase

  alias LoanSavingsSystem.Customers

  describe "tbl_customer" do
    alias LoanSavingsSystem.Customers.Customer

    @valid_attrs %{age: "some age", customer_id: "some customer_id", email_address: "some email_address", first_name: "some first_name", gender: "some gender", home_address: "some home_address", id_number: "some id_number", id_type: "some id_type", last_name: "some last_name", mobile_number: "some mobile_number", telco_id: "some telco_id", user_role: "some user_role"}
    @update_attrs %{age: "some updated age", customer_id: "some updated customer_id", email_address: "some updated email_address", first_name: "some updated first_name", gender: "some updated gender", home_address: "some updated home_address", id_number: "some updated id_number", id_type: "some updated id_type", last_name: "some updated last_name", mobile_number: "some updated mobile_number", telco_id: "some updated telco_id", user_role: "some updated user_role"}
    @invalid_attrs %{age: nil, customer_id: nil, email_address: nil, first_name: nil, gender: nil, home_address: nil, id_number: nil, id_type: nil, last_name: nil, mobile_number: nil, telco_id: nil, user_role: nil}

    def customer_fixture(attrs \\ %{}) do
      {:ok, customer} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Customers.create_customer()

      customer
    end

    test "list_tbl_customer/0 returns all tbl_customer" do
      customer = customer_fixture()
      assert Customers.list_tbl_customer() == [customer]
    end

    test "get_customer!/1 returns the customer with given id" do
      customer = customer_fixture()
      assert Customers.get_customer!(customer.id) == customer
    end

    test "create_customer/1 with valid data creates a customer" do
      assert {:ok, %Customer{} = customer} = Customers.create_customer(@valid_attrs)
      assert customer.age == "some age"
      assert customer.customer_id == "some customer_id"
      assert customer.email_address == "some email_address"
      assert customer.first_name == "some first_name"
      assert customer.gender == "some gender"
      assert customer.home_address == "some home_address"
      assert customer.id_number == "some id_number"
      assert customer.id_type == "some id_type"
      assert customer.last_name == "some last_name"
      assert customer.mobile_number == "some mobile_number"
      assert customer.telco_id == "some telco_id"
      assert customer.user_role == "some user_role"
    end

    test "create_customer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Customers.create_customer(@invalid_attrs)
    end

    test "update_customer/2 with valid data updates the customer" do
      customer = customer_fixture()
      assert {:ok, %Customer{} = customer} = Customers.update_customer(customer, @update_attrs)
      assert customer.age == "some updated age"
      assert customer.customer_id == "some updated customer_id"
      assert customer.email_address == "some updated email_address"
      assert customer.first_name == "some updated first_name"
      assert customer.gender == "some updated gender"
      assert customer.home_address == "some updated home_address"
      assert customer.id_number == "some updated id_number"
      assert customer.id_type == "some updated id_type"
      assert customer.last_name == "some updated last_name"
      assert customer.mobile_number == "some updated mobile_number"
      assert customer.telco_id == "some updated telco_id"
      assert customer.user_role == "some updated user_role"
    end

    test "update_customer/2 with invalid data returns error changeset" do
      customer = customer_fixture()
      assert {:error, %Ecto.Changeset{}} = Customers.update_customer(customer, @invalid_attrs)
      assert customer == Customers.get_customer!(customer.id)
    end

    test "delete_customer/1 deletes the customer" do
      customer = customer_fixture()
      assert {:ok, %Customer{}} = Customers.delete_customer(customer)
      assert_raise Ecto.NoResultsError, fn -> Customers.get_customer!(customer.id) end
    end

    test "change_customer/1 returns a customer changeset" do
      customer = customer_fixture()
      assert %Ecto.Changeset{} = Customers.change_customer(customer)
    end
  end

  describe "tbl_customer_address" do
    alias LoanSavingsSystem.Customers.Customer_address

    @valid_attrs %{customer_id: "some customer_id", district_id: "some district_id", is_current: "some is_current", line_address_1: "some line_address_1", line_address_2: "some line_address_2", province_id: "some province_id"}
    @update_attrs %{customer_id: "some updated customer_id", district_id: "some updated district_id", is_current: "some updated is_current", line_address_1: "some updated line_address_1", line_address_2: "some updated line_address_2", province_id: "some updated province_id"}
    @invalid_attrs %{customer_id: nil, district_id: nil, is_current: nil, line_address_1: nil, line_address_2: nil, province_id: nil}

    def customer_address_fixture(attrs \\ %{}) do
      {:ok, customer_address} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Customers.create_customer_address()

      customer_address
    end

    test "list_tbl_customer_address/0 returns all tbl_customer_address" do
      customer_address = customer_address_fixture()
      assert Customers.list_tbl_customer_address() == [customer_address]
    end

    test "get_customer_address!/1 returns the customer_address with given id" do
      customer_address = customer_address_fixture()
      assert Customers.get_customer_address!(customer_address.id) == customer_address
    end

    test "create_customer_address/1 with valid data creates a customer_address" do
      assert {:ok, %Customer_address{} = customer_address} = Customers.create_customer_address(@valid_attrs)
      assert customer_address.customer_id == "some customer_id"
      assert customer_address.district_id == "some district_id"
      assert customer_address.is_current == "some is_current"
      assert customer_address.line_address_1 == "some line_address_1"
      assert customer_address.line_address_2 == "some line_address_2"
      assert customer_address.province_id == "some province_id"
    end

    test "create_customer_address/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Customers.create_customer_address(@invalid_attrs)
    end

    test "update_customer_address/2 with valid data updates the customer_address" do
      customer_address = customer_address_fixture()
      assert {:ok, %Customer_address{} = customer_address} = Customers.update_customer_address(customer_address, @update_attrs)
      assert customer_address.customer_id == "some updated customer_id"
      assert customer_address.district_id == "some updated district_id"
      assert customer_address.is_current == "some updated is_current"
      assert customer_address.line_address_1 == "some updated line_address_1"
      assert customer_address.line_address_2 == "some updated line_address_2"
      assert customer_address.province_id == "some updated province_id"
    end

    test "update_customer_address/2 with invalid data returns error changeset" do
      customer_address = customer_address_fixture()
      assert {:error, %Ecto.Changeset{}} = Customers.update_customer_address(customer_address, @invalid_attrs)
      assert customer_address == Customers.get_customer_address!(customer_address.id)
    end

    test "delete_customer_address/1 deletes the customer_address" do
      customer_address = customer_address_fixture()
      assert {:ok, %Customer_address{}} = Customers.delete_customer_address(customer_address)
      assert_raise Ecto.NoResultsError, fn -> Customers.get_customer_address!(customer_address.id) end
    end

    test "change_customer_address/1 returns a customer_address changeset" do
      customer_address = customer_address_fixture()
      assert %Ecto.Changeset{} = Customers.change_customer_address(customer_address)
    end
  end

  describe "tbl_bio_data" do
    alias LoanSavingsSystem.Customers.Customer

    @valid_attrs %{account_number: "some account_number", address: "some address", chief_name: "some chief_name", country_name: "some country_name", customer_id: "some customer_id", date_of_birth: "some date_of_birth", district_name: "some district_name", first_name: "some first_name", gender: "some gender", id_number: "some id_number", last_name: "some last_name", next_of_kin: "some next_of_kin", other_name: "some other_name", place_of_birth: "some place_of_birth", provnce_name: "some provnce_name", village_name: "some village_name"}
    @update_attrs %{account_number: "some updated account_number", address: "some updated address", chief_name: "some updated chief_name", country_name: "some updated country_name", customer_id: "some updated customer_id", date_of_birth: "some updated date_of_birth", district_name: "some updated district_name", first_name: "some updated first_name", gender: "some updated gender", id_number: "some updated id_number", last_name: "some updated last_name", next_of_kin: "some updated next_of_kin", other_name: "some updated other_name", place_of_birth: "some updated place_of_birth", provnce_name: "some updated provnce_name", village_name: "some updated village_name"}
    @invalid_attrs %{account_number: nil, address: nil, chief_name: nil, country_name: nil, customer_id: nil, date_of_birth: nil, district_name: nil, first_name: nil, gender: nil, id_number: nil, last_name: nil, next_of_kin: nil, other_name: nil, place_of_birth: nil, provnce_name: nil, village_name: nil}

    def customer_fixture(attrs \\ %{}) do
      {:ok, customer} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Customers.create_customer()

      customer
    end

    test "list_tbl_bio_data/0 returns all tbl_bio_data" do
      customer = customer_fixture()
      assert Customers.list_tbl_bio_data() == [customer]
    end

    test "get_customer!/1 returns the customer with given id" do
      customer = customer_fixture()
      assert Customers.get_customer!(customer.id) == customer
    end

    test "create_customer/1 with valid data creates a customer" do
      assert {:ok, %Customer{} = customer} = Customers.create_customer(@valid_attrs)
      assert customer.account_number == "some account_number"
      assert customer.address == "some address"
      assert customer.chief_name == "some chief_name"
      assert customer.country_name == "some country_name"
      assert customer.customer_id == "some customer_id"
      assert customer.date_of_birth == "some date_of_birth"
      assert customer.district_name == "some district_name"
      assert customer.first_name == "some first_name"
      assert customer.gender == "some gender"
      assert customer.id_number == "some id_number"
      assert customer.last_name == "some last_name"
      assert customer.next_of_kin == "some next_of_kin"
      assert customer.other_name == "some other_name"
      assert customer.place_of_birth == "some place_of_birth"
      assert customer.provnce_name == "some provnce_name"
      assert customer.village_name == "some village_name"
    end

    test "create_customer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Customers.create_customer(@invalid_attrs)
    end

    test "update_customer/2 with valid data updates the customer" do
      customer = customer_fixture()
      assert {:ok, %Customer{} = customer} = Customers.update_customer(customer, @update_attrs)
      assert customer.account_number == "some updated account_number"
      assert customer.address == "some updated address"
      assert customer.chief_name == "some updated chief_name"
      assert customer.country_name == "some updated country_name"
      assert customer.customer_id == "some updated customer_id"
      assert customer.date_of_birth == "some updated date_of_birth"
      assert customer.district_name == "some updated district_name"
      assert customer.first_name == "some updated first_name"
      assert customer.gender == "some updated gender"
      assert customer.id_number == "some updated id_number"
      assert customer.last_name == "some updated last_name"
      assert customer.next_of_kin == "some updated next_of_kin"
      assert customer.other_name == "some updated other_name"
      assert customer.place_of_birth == "some updated place_of_birth"
      assert customer.provnce_name == "some updated provnce_name"
      assert customer.village_name == "some updated village_name"
    end

    test "update_customer/2 with invalid data returns error changeset" do
      customer = customer_fixture()
      assert {:error, %Ecto.Changeset{}} = Customers.update_customer(customer, @invalid_attrs)
      assert customer == Customers.get_customer!(customer.id)
    end

    test "delete_customer/1 deletes the customer" do
      customer = customer_fixture()
      assert {:ok, %Customer{}} = Customers.delete_customer(customer)
      assert_raise Ecto.NoResultsError, fn -> Customers.get_customer!(customer.id) end
    end

    test "change_customer/1 returns a customer changeset" do
      customer = customer_fixture()
      assert %Ecto.Changeset{} = Customers.change_customer(customer)
    end
  end

  describe "tbl_bio_data" do
    alias LoanSavingsSystem.Customers.Customer_bio_data

    @valid_attrs %{account_number: "some account_number", address: "some address", chief_name: "some chief_name", country_name: "some country_name", customer_id: "some customer_id", date_of_birth: "some date_of_birth", district_name: "some district_name", first_name: "some first_name", gender: "some gender", id_number: "some id_number", last_name: "some last_name", next_of_kin: "some next_of_kin", other_name: "some other_name", place_of_birth: "some place_of_birth", provnce_name: "some provnce_name", village_name: "some village_name"}
    @update_attrs %{account_number: "some updated account_number", address: "some updated address", chief_name: "some updated chief_name", country_name: "some updated country_name", customer_id: "some updated customer_id", date_of_birth: "some updated date_of_birth", district_name: "some updated district_name", first_name: "some updated first_name", gender: "some updated gender", id_number: "some updated id_number", last_name: "some updated last_name", next_of_kin: "some updated next_of_kin", other_name: "some updated other_name", place_of_birth: "some updated place_of_birth", provnce_name: "some updated provnce_name", village_name: "some updated village_name"}
    @invalid_attrs %{account_number: nil, address: nil, chief_name: nil, country_name: nil, customer_id: nil, date_of_birth: nil, district_name: nil, first_name: nil, gender: nil, id_number: nil, last_name: nil, next_of_kin: nil, other_name: nil, place_of_birth: nil, provnce_name: nil, village_name: nil}

    def customer_bio_data_fixture(attrs \\ %{}) do
      {:ok, customer_bio_data} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Customers.create_customer_bio_data()

      customer_bio_data
    end

    test "list_tbl_bio_data/0 returns all tbl_bio_data" do
      customer_bio_data = customer_bio_data_fixture()
      assert Customers.list_tbl_bio_data() == [customer_bio_data]
    end

    test "get_customer_bio_data!/1 returns the customer_bio_data with given id" do
      customer_bio_data = customer_bio_data_fixture()
      assert Customers.get_customer_bio_data!(customer_bio_data.id) == customer_bio_data
    end

    test "create_customer_bio_data/1 with valid data creates a customer_bio_data" do
      assert {:ok, %Customer_bio_data{} = customer_bio_data} = Customers.create_customer_bio_data(@valid_attrs)
      assert customer_bio_data.account_number == "some account_number"
      assert customer_bio_data.address == "some address"
      assert customer_bio_data.chief_name == "some chief_name"
      assert customer_bio_data.country_name == "some country_name"
      assert customer_bio_data.customer_id == "some customer_id"
      assert customer_bio_data.date_of_birth == "some date_of_birth"
      assert customer_bio_data.district_name == "some district_name"
      assert customer_bio_data.first_name == "some first_name"
      assert customer_bio_data.gender == "some gender"
      assert customer_bio_data.id_number == "some id_number"
      assert customer_bio_data.last_name == "some last_name"
      assert customer_bio_data.next_of_kin == "some next_of_kin"
      assert customer_bio_data.other_name == "some other_name"
      assert customer_bio_data.place_of_birth == "some place_of_birth"
      assert customer_bio_data.provnce_name == "some provnce_name"
      assert customer_bio_data.village_name == "some village_name"
    end

    test "create_customer_bio_data/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Customers.create_customer_bio_data(@invalid_attrs)
    end

    test "update_customer_bio_data/2 with valid data updates the customer_bio_data" do
      customer_bio_data = customer_bio_data_fixture()
      assert {:ok, %Customer_bio_data{} = customer_bio_data} = Customers.update_customer_bio_data(customer_bio_data, @update_attrs)
      assert customer_bio_data.account_number == "some updated account_number"
      assert customer_bio_data.address == "some updated address"
      assert customer_bio_data.chief_name == "some updated chief_name"
      assert customer_bio_data.country_name == "some updated country_name"
      assert customer_bio_data.customer_id == "some updated customer_id"
      assert customer_bio_data.date_of_birth == "some updated date_of_birth"
      assert customer_bio_data.district_name == "some updated district_name"
      assert customer_bio_data.first_name == "some updated first_name"
      assert customer_bio_data.gender == "some updated gender"
      assert customer_bio_data.id_number == "some updated id_number"
      assert customer_bio_data.last_name == "some updated last_name"
      assert customer_bio_data.next_of_kin == "some updated next_of_kin"
      assert customer_bio_data.other_name == "some updated other_name"
      assert customer_bio_data.place_of_birth == "some updated place_of_birth"
      assert customer_bio_data.provnce_name == "some updated provnce_name"
      assert customer_bio_data.village_name == "some updated village_name"
    end

    test "update_customer_bio_data/2 with invalid data returns error changeset" do
      customer_bio_data = customer_bio_data_fixture()
      assert {:error, %Ecto.Changeset{}} = Customers.update_customer_bio_data(customer_bio_data, @invalid_attrs)
      assert customer_bio_data == Customers.get_customer_bio_data!(customer_bio_data.id)
    end

    test "delete_customer_bio_data/1 deletes the customer_bio_data" do
      customer_bio_data = customer_bio_data_fixture()
      assert {:ok, %Customer_bio_data{}} = Customers.delete_customer_bio_data(customer_bio_data)
      assert_raise Ecto.NoResultsError, fn -> Customers.get_customer_bio_data!(customer_bio_data.id) end
    end

    test "change_customer_bio_data/1 returns a customer_bio_data changeset" do
      customer_bio_data = customer_bio_data_fixture()
      assert %Ecto.Changeset{} = Customers.change_customer_bio_data(customer_bio_data)
    end
  end

  describe "tbl_customer" do
    alias LoanSavingsSystem.Customers.Customer

    @valid_attrs %{age: "some age", customer_id: "some customer_id", email_address: "some email_address", first_name: "some first_name", gender: "some gender", home_address: "some home_address", id_number: "some id_number", id_type: "some id_type", last_name: "some last_name", mobile_number: "some mobile_number", telco_id: "some telco_id", user_role: "some user_role"}
    @update_attrs %{age: "some updated age", customer_id: "some updated customer_id", email_address: "some updated email_address", first_name: "some updated first_name", gender: "some updated gender", home_address: "some updated home_address", id_number: "some updated id_number", id_type: "some updated id_type", last_name: "some updated last_name", mobile_number: "some updated mobile_number", telco_id: "some updated telco_id", user_role: "some updated user_role"}
    @invalid_attrs %{age: nil, customer_id: nil, email_address: nil, first_name: nil, gender: nil, home_address: nil, id_number: nil, id_type: nil, last_name: nil, mobile_number: nil, telco_id: nil, user_role: nil}

    def customer_fixture(attrs \\ %{}) do
      {:ok, customer} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Customers.create_customer()

      customer
    end

    test "list_tbl_customer/0 returns all tbl_customer" do
      customer = customer_fixture()
      assert Customers.list_tbl_customer() == [customer]
    end

    test "get_customer!/1 returns the customer with given id" do
      customer = customer_fixture()
      assert Customers.get_customer!(customer.id) == customer
    end

    test "create_customer/1 with valid data creates a customer" do
      assert {:ok, %Customer{} = customer} = Customers.create_customer(@valid_attrs)
      assert customer.age == "some age"
      assert customer.customer_id == "some customer_id"
      assert customer.email_address == "some email_address"
      assert customer.first_name == "some first_name"
      assert customer.gender == "some gender"
      assert customer.home_address == "some home_address"
      assert customer.id_number == "some id_number"
      assert customer.id_type == "some id_type"
      assert customer.last_name == "some last_name"
      assert customer.mobile_number == "some mobile_number"
      assert customer.telco_id == "some telco_id"
      assert customer.user_role == "some user_role"
    end

    test "create_customer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Customers.create_customer(@invalid_attrs)
    end

    test "update_customer/2 with valid data updates the customer" do
      customer = customer_fixture()
      assert {:ok, %Customer{} = customer} = Customers.update_customer(customer, @update_attrs)
      assert customer.age == "some updated age"
      assert customer.customer_id == "some updated customer_id"
      assert customer.email_address == "some updated email_address"
      assert customer.first_name == "some updated first_name"
      assert customer.gender == "some updated gender"
      assert customer.home_address == "some updated home_address"
      assert customer.id_number == "some updated id_number"
      assert customer.id_type == "some updated id_type"
      assert customer.last_name == "some updated last_name"
      assert customer.mobile_number == "some updated mobile_number"
      assert customer.telco_id == "some updated telco_id"
      assert customer.user_role == "some updated user_role"
    end

    test "update_customer/2 with invalid data returns error changeset" do
      customer = customer_fixture()
      assert {:error, %Ecto.Changeset{}} = Customers.update_customer(customer, @invalid_attrs)
      assert customer == Customers.get_customer!(customer.id)
    end

    test "delete_customer/1 deletes the customer" do
      customer = customer_fixture()
      assert {:ok, %Customer{}} = Customers.delete_customer(customer)
      assert_raise Ecto.NoResultsError, fn -> Customers.get_customer!(customer.id) end
    end

    test "change_customer/1 returns a customer changeset" do
      customer = customer_fixture()
      assert %Ecto.Changeset{} = Customers.change_customer(customer)
    end
  end

  describe "tbl_customer_credit_score" do
    alias LoanSavingsSystem.Customers.Score

    @valid_attrs %{"customer-id": "some customer-id", score_entry: "some score_entry"}
    @update_attrs %{"customer-id": "some updated customer-id", score_entry: "some updated score_entry"}
    @invalid_attrs %{"customer-id": nil, score_entry: nil}

    def score_fixture(attrs \\ %{}) do
      {:ok, score} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Customers.create_score()

      score
    end

    test "list_tbl_customer_credit_score/0 returns all tbl_customer_credit_score" do
      score = score_fixture()
      assert Customers.list_tbl_customer_credit_score() == [score]
    end

    test "get_score!/1 returns the score with given id" do
      score = score_fixture()
      assert Customers.get_score!(score.id) == score
    end

    test "create_score/1 with valid data creates a score" do
      assert {:ok, %Score{} = score} = Customers.create_score(@valid_attrs)
      assert score.customer-id == "some customer-id"
      assert score.score_entry == "some score_entry"
    end

    test "create_score/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Customers.create_score(@invalid_attrs)
    end

    test "update_score/2 with valid data updates the score" do
      score = score_fixture()
      assert {:ok, %Score{} = score} = Customers.update_score(score, @update_attrs)
      assert score.customer-id == "some updated customer-id"
      assert score.score_entry == "some updated score_entry"
    end

    test "update_score/2 with invalid data returns error changeset" do
      score = score_fixture()
      assert {:error, %Ecto.Changeset{}} = Customers.update_score(score, @invalid_attrs)
      assert score == Customers.get_score!(score.id)
    end

    test "delete_score/1 deletes the score" do
      score = score_fixture()
      assert {:ok, %Score{}} = Customers.delete_score(score)
      assert_raise Ecto.NoResultsError, fn -> Customers.get_score!(score.id) end
    end

    test "change_score/1 returns a score changeset" do
      score = score_fixture()
      assert %Ecto.Changeset{} = Customers.change_score(score)
    end
  end
end
