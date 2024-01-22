defmodule LoanSavingsSystem.SMEsTest do
  use LoanSavingsSystem.DataCase

  alias LoanSavingsSystem.SMEs

  describe "tbl_sme" do
    alias LoanSavingsSystem.SMEs.SME

    @valid_attrs %{age: 42, city: "some city", company_name: "some company_name", email_address: "some email_address", first_name: "some first_name", gender: "some gender", home_address: "some home_address", id_number: 42, id_type: "some id_type", individual_id: 42, last_name: "some last_name", mobile_number: "some mobile_number", other_name: "some other_name", status: "some status", telco_id: 42, user_role: "some user_role"}
    @update_attrs %{age: 43, city: "some updated city", company_name: "some updated company_name", email_address: "some updated email_address", first_name: "some updated first_name", gender: "some updated gender", home_address: "some updated home_address", id_number: 43, id_type: "some updated id_type", individual_id: 43, last_name: "some updated last_name", mobile_number: "some updated mobile_number", other_name: "some updated other_name", status: "some updated status", telco_id: 43, user_role: "some updated user_role"}
    @invalid_attrs %{age: nil, city: nil, company_name: nil, email_address: nil, first_name: nil, gender: nil, home_address: nil, id_number: nil, id_type: nil, individual_id: nil, last_name: nil, mobile_number: nil, other_name: nil, status: nil, telco_id: nil, user_role: nil}

    def sme_fixture(attrs \\ %{}) do
      {:ok, sme} =
        attrs
        |> Enum.into(@valid_attrs)
        |> SMEs.create_sme()

      sme
    end

    test "list_tbl_sme/0 returns all tbl_sme" do
      sme = sme_fixture()
      assert SMEs.list_tbl_sme() == [sme]
    end

    test "get_sme!/1 returns the sme with given id" do
      sme = sme_fixture()
      assert SMEs.get_sme!(sme.id) == sme
    end

    test "create_sme/1 with valid data creates a sme" do
      assert {:ok, %SME{} = sme} = SMEs.create_sme(@valid_attrs)
      assert sme.age == 42
      assert sme.city == "some city"
      assert sme.company_name == "some company_name"
      assert sme.email_address == "some email_address"
      assert sme.first_name == "some first_name"
      assert sme.gender == "some gender"
      assert sme.home_address == "some home_address"
      assert sme.id_number == 42
      assert sme.id_type == "some id_type"
      assert sme.individual_id == 42
      assert sme.last_name == "some last_name"
      assert sme.mobile_number == "some mobile_number"
      assert sme.other_name == "some other_name"
      assert sme.status == "some status"
      assert sme.telco_id == 42
      assert sme.user_role == "some user_role"
    end

    test "create_sme/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = SMEs.create_sme(@invalid_attrs)
    end

    test "update_sme/2 with valid data updates the sme" do
      sme = sme_fixture()
      assert {:ok, %SME{} = sme} = SMEs.update_sme(sme, @update_attrs)
      assert sme.age == 43
      assert sme.city == "some updated city"
      assert sme.company_name == "some updated company_name"
      assert sme.email_address == "some updated email_address"
      assert sme.first_name == "some updated first_name"
      assert sme.gender == "some updated gender"
      assert sme.home_address == "some updated home_address"
      assert sme.id_number == 43
      assert sme.id_type == "some updated id_type"
      assert sme.individual_id == 43
      assert sme.last_name == "some updated last_name"
      assert sme.mobile_number == "some updated mobile_number"
      assert sme.other_name == "some updated other_name"
      assert sme.status == "some updated status"
      assert sme.telco_id == 43
      assert sme.user_role == "some updated user_role"
    end

    test "update_sme/2 with invalid data returns error changeset" do
      sme = sme_fixture()
      assert {:error, %Ecto.Changeset{}} = SMEs.update_sme(sme, @invalid_attrs)
      assert sme == SMEs.get_sme!(sme.id)
    end

    test "delete_sme/1 deletes the sme" do
      sme = sme_fixture()
      assert {:ok, %SME{}} = SMEs.delete_sme(sme)
      assert_raise Ecto.NoResultsError, fn -> SMEs.get_sme!(sme.id) end
    end

    test "change_sme/1 returns a sme changeset" do
      sme = sme_fixture()
      assert %Ecto.Changeset{} = SMEs.change_sme(sme)
    end
  end
end
