defmodule Loanmanagementsystem.RelationshipManagementTest do
  use Loanmanagementsystem.DataCase

  alias Loanmanagementsystem.RelationshipManagement

  describe "tbl_leads" do
    alias Loanmanagementsystem.RelationshipManagement.Leads

    @valid_attrs %{bankId: 42, date_of_birth: ~D[2010-04-17], disability_detail: "some disability_detail", disability_status: "some disability_status", email_address: "some email_address", first_name: "some first_name", gender: "some gender", identification_number: "some identification_number", identification_type: "some identification_type", last_name: "some last_name", marital_status: "some marital_status", mobile_number: "some mobile_number", nationality: "some nationality", number_of_dependants: 42, other_name: "some other_name", title: "some title", userId: 42}
    @update_attrs %{bankId: 43, date_of_birth: ~D[2011-05-18], disability_detail: "some updated disability_detail", disability_status: "some updated disability_status", email_address: "some updated email_address", first_name: "some updated first_name", gender: "some updated gender", identification_number: "some updated identification_number", identification_type: "some updated identification_type", last_name: "some updated last_name", marital_status: "some updated marital_status", mobile_number: "some updated mobile_number", nationality: "some updated nationality", number_of_dependants: 43, other_name: "some updated other_name", title: "some updated title", userId: 43}
    @invalid_attrs %{bankId: nil, date_of_birth: nil, disability_detail: nil, disability_status: nil, email_address: nil, first_name: nil, gender: nil, identification_number: nil, identification_type: nil, last_name: nil, marital_status: nil, mobile_number: nil, nationality: nil, number_of_dependants: nil, other_name: nil, title: nil, userId: nil}

    def leads_fixture(attrs \\ %{}) do
      {:ok, leads} =
        attrs
        |> Enum.into(@valid_attrs)
        |> RelationshipManagement.create_leads()

      leads
    end

    test "list_tbl_leads/0 returns all tbl_leads" do
      leads = leads_fixture()
      assert RelationshipManagement.list_tbl_leads() == [leads]
    end

    test "get_leads!/1 returns the leads with given id" do
      leads = leads_fixture()
      assert RelationshipManagement.get_leads!(leads.id) == leads
    end

    test "create_leads/1 with valid data creates a leads" do
      assert {:ok, %Leads{} = leads} = RelationshipManagement.create_leads(@valid_attrs)
      assert leads.bankId == 42
      assert leads.date_of_birth == ~D[2010-04-17]
      assert leads.disability_detail == "some disability_detail"
      assert leads.disability_status == "some disability_status"
      assert leads.email_address == "some email_address"
      assert leads.first_name == "some first_name"
      assert leads.gender == "some gender"
      assert leads.identification_number == "some identification_number"
      assert leads.identification_type == "some identification_type"
      assert leads.last_name == "some last_name"
      assert leads.marital_status == "some marital_status"
      assert leads.mobile_number == "some mobile_number"
      assert leads.nationality == "some nationality"
      assert leads.number_of_dependants == 42
      assert leads.other_name == "some other_name"
      assert leads.title == "some title"
      assert leads.userId == 42
    end

    test "create_leads/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = RelationshipManagement.create_leads(@invalid_attrs)
    end

    test "update_leads/2 with valid data updates the leads" do
      leads = leads_fixture()
      assert {:ok, %Leads{} = leads} = RelationshipManagement.update_leads(leads, @update_attrs)
      assert leads.bankId == 43
      assert leads.date_of_birth == ~D[2011-05-18]
      assert leads.disability_detail == "some updated disability_detail"
      assert leads.disability_status == "some updated disability_status"
      assert leads.email_address == "some updated email_address"
      assert leads.first_name == "some updated first_name"
      assert leads.gender == "some updated gender"
      assert leads.identification_number == "some updated identification_number"
      assert leads.identification_type == "some updated identification_type"
      assert leads.last_name == "some updated last_name"
      assert leads.marital_status == "some updated marital_status"
      assert leads.mobile_number == "some updated mobile_number"
      assert leads.nationality == "some updated nationality"
      assert leads.number_of_dependants == 43
      assert leads.other_name == "some updated other_name"
      assert leads.title == "some updated title"
      assert leads.userId == 43
    end

    test "update_leads/2 with invalid data returns error changeset" do
      leads = leads_fixture()
      assert {:error, %Ecto.Changeset{}} = RelationshipManagement.update_leads(leads, @invalid_attrs)
      assert leads == RelationshipManagement.get_leads!(leads.id)
    end

    test "delete_leads/1 deletes the leads" do
      leads = leads_fixture()
      assert {:ok, %Leads{}} = RelationshipManagement.delete_leads(leads)
      assert_raise Ecto.NoResultsError, fn -> RelationshipManagement.get_leads!(leads.id) end
    end

    test "change_leads/1 returns a leads changeset" do
      leads = leads_fixture()
      assert %Ecto.Changeset{} = RelationshipManagement.change_leads(leads)
    end
  end

  describe "tbl_proposal" do
    alias Loanmanagementsystem.RelationshipManagement.Proposal

    @valid_attrs %{bankId: 42, date_of_birth: ~D[2010-04-17], disability_detail: "some disability_detail", disability_status: "some disability_status", email_address: "some email_address", first_name: "some first_name", gender: "some gender", identification_number: "some identification_number", identification_type: "some identification_type", last_name: "some last_name", marital_status: "some marital_status", mobile_number: "some mobile_number", nationality: "some nationality", number_of_dependants: 42, other_name: "some other_name", status: "some status", title: "some title", userId: 42}
    @update_attrs %{bankId: 43, date_of_birth: ~D[2011-05-18], disability_detail: "some updated disability_detail", disability_status: "some updated disability_status", email_address: "some updated email_address", first_name: "some updated first_name", gender: "some updated gender", identification_number: "some updated identification_number", identification_type: "some updated identification_type", last_name: "some updated last_name", marital_status: "some updated marital_status", mobile_number: "some updated mobile_number", nationality: "some updated nationality", number_of_dependants: 43, other_name: "some updated other_name", status: "some updated status", title: "some updated title", userId: 43}
    @invalid_attrs %{bankId: nil, date_of_birth: nil, disability_detail: nil, disability_status: nil, email_address: nil, first_name: nil, gender: nil, identification_number: nil, identification_type: nil, last_name: nil, marital_status: nil, mobile_number: nil, nationality: nil, number_of_dependants: nil, other_name: nil, status: nil, title: nil, userId: nil}

    def proposal_fixture(attrs \\ %{}) do
      {:ok, proposal} =
        attrs
        |> Enum.into(@valid_attrs)
        |> RelationshipManagement.create_proposal()

      proposal
    end

    test "list_tbl_proposal/0 returns all tbl_proposal" do
      proposal = proposal_fixture()
      assert RelationshipManagement.list_tbl_proposal() == [proposal]
    end

    test "get_proposal!/1 returns the proposal with given id" do
      proposal = proposal_fixture()
      assert RelationshipManagement.get_proposal!(proposal.id) == proposal
    end

    test "create_proposal/1 with valid data creates a proposal" do
      assert {:ok, %Proposal{} = proposal} = RelationshipManagement.create_proposal(@valid_attrs)
      assert proposal.bankId == 42
      assert proposal.date_of_birth == ~D[2010-04-17]
      assert proposal.disability_detail == "some disability_detail"
      assert proposal.disability_status == "some disability_status"
      assert proposal.email_address == "some email_address"
      assert proposal.first_name == "some first_name"
      assert proposal.gender == "some gender"
      assert proposal.identification_number == "some identification_number"
      assert proposal.identification_type == "some identification_type"
      assert proposal.last_name == "some last_name"
      assert proposal.marital_status == "some marital_status"
      assert proposal.mobile_number == "some mobile_number"
      assert proposal.nationality == "some nationality"
      assert proposal.number_of_dependants == 42
      assert proposal.other_name == "some other_name"
      assert proposal.status == "some status"
      assert proposal.title == "some title"
      assert proposal.userId == 42
    end

    test "create_proposal/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = RelationshipManagement.create_proposal(@invalid_attrs)
    end

    test "update_proposal/2 with valid data updates the proposal" do
      proposal = proposal_fixture()
      assert {:ok, %Proposal{} = proposal} = RelationshipManagement.update_proposal(proposal, @update_attrs)
      assert proposal.bankId == 43
      assert proposal.date_of_birth == ~D[2011-05-18]
      assert proposal.disability_detail == "some updated disability_detail"
      assert proposal.disability_status == "some updated disability_status"
      assert proposal.email_address == "some updated email_address"
      assert proposal.first_name == "some updated first_name"
      assert proposal.gender == "some updated gender"
      assert proposal.identification_number == "some updated identification_number"
      assert proposal.identification_type == "some updated identification_type"
      assert proposal.last_name == "some updated last_name"
      assert proposal.marital_status == "some updated marital_status"
      assert proposal.mobile_number == "some updated mobile_number"
      assert proposal.nationality == "some updated nationality"
      assert proposal.number_of_dependants == 43
      assert proposal.other_name == "some updated other_name"
      assert proposal.status == "some updated status"
      assert proposal.title == "some updated title"
      assert proposal.userId == 43
    end

    test "update_proposal/2 with invalid data returns error changeset" do
      proposal = proposal_fixture()
      assert {:error, %Ecto.Changeset{}} = RelationshipManagement.update_proposal(proposal, @invalid_attrs)
      assert proposal == RelationshipManagement.get_proposal!(proposal.id)
    end

    test "delete_proposal/1 deletes the proposal" do
      proposal = proposal_fixture()
      assert {:ok, %Proposal{}} = RelationshipManagement.delete_proposal(proposal)
      assert_raise Ecto.NoResultsError, fn -> RelationshipManagement.get_proposal!(proposal.id) end
    end

    test "change_proposal/1 returns a proposal changeset" do
      proposal = proposal_fixture()
      assert %Ecto.Changeset{} = RelationshipManagement.change_proposal(proposal)
    end
  end
end
