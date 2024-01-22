defmodule LoanSavingsSystem.DocumentsTest do
  use LoanSavingsSystem.DataCase

  alias LoanSavingsSystem.Documents

  describe "tbl_document" do
    alias LoanSavingsSystem.Documents.Document

    @valid_attrs %{company_id: "some company_id", customer_id: "some customer_id", name: "some name", off_taker_id: "some off_taker_id", status: "some status", type_of_doc: "some type_of_doc", user_id: "some user_id"}
    @update_attrs %{company_id: "some updated company_id", customer_id: "some updated customer_id", name: "some updated name", off_taker_id: "some updated off_taker_id", status: "some updated status", type_of_doc: "some updated type_of_doc", user_id: "some updated user_id"}
    @invalid_attrs %{company_id: nil, customer_id: nil, name: nil, off_taker_id: nil, status: nil, type_of_doc: nil, user_id: nil}

    def document_fixture(attrs \\ %{}) do
      {:ok, document} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Documents.create_document()

      document
    end

    test "list_tbl_document/0 returns all tbl_document" do
      document = document_fixture()
      assert Documents.list_tbl_document() == [document]
    end

    test "get_document!/1 returns the document with given id" do
      document = document_fixture()
      assert Documents.get_document!(document.id) == document
    end

    test "create_document/1 with valid data creates a document" do
      assert {:ok, %Document{} = document} = Documents.create_document(@valid_attrs)
      assert document.company_id == "some company_id"
      assert document.customer_id == "some customer_id"
      assert document.name == "some name"
      assert document.off_taker_id == "some off_taker_id"
      assert document.status == "some status"
      assert document.type_of_doc == "some type_of_doc"
      assert document.user_id == "some user_id"
    end

    test "create_document/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Documents.create_document(@invalid_attrs)
    end

    test "update_document/2 with valid data updates the document" do
      document = document_fixture()
      assert {:ok, %Document{} = document} = Documents.update_document(document, @update_attrs)
      assert document.company_id == "some updated company_id"
      assert document.customer_id == "some updated customer_id"
      assert document.name == "some updated name"
      assert document.off_taker_id == "some updated off_taker_id"
      assert document.status == "some updated status"
      assert document.type_of_doc == "some updated type_of_doc"
      assert document.user_id == "some updated user_id"
    end

    test "update_document/2 with invalid data returns error changeset" do
      document = document_fixture()
      assert {:error, %Ecto.Changeset{}} = Documents.update_document(document, @invalid_attrs)
      assert document == Documents.get_document!(document.id)
    end

    test "delete_document/1 deletes the document" do
      document = document_fixture()
      assert {:ok, %Document{}} = Documents.delete_document(document)
      assert_raise Ecto.NoResultsError, fn -> Documents.get_document!(document.id) end
    end

    test "change_document/1 returns a document changeset" do
      document = document_fixture()
      assert %Ecto.Changeset{} = Documents.change_document(document)
    end
  end

  describe "tbl_document" do
    alias LoanSavingsSystem.Documents.Document

    @valid_attrs %{company_id: "some company_id", customer_id: "some customer_id", name: "some name", off_taker_id: "some off_taker_id", status: "some status", type_of_doc: "some type_of_doc", user_id: "some user_id"}
    @update_attrs %{company_id: "some updated company_id", customer_id: "some updated customer_id", name: "some updated name", off_taker_id: "some updated off_taker_id", status: "some updated status", type_of_doc: "some updated type_of_doc", user_id: "some updated user_id"}
    @invalid_attrs %{company_id: nil, customer_id: nil, name: nil, off_taker_id: nil, status: nil, type_of_doc: nil, user_id: nil}

    def document_fixture(attrs \\ %{}) do
      {:ok, document} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Documents.create_document()

      document
    end

    test "list_tbl_document/0 returns all tbl_document" do
      document = document_fixture()
      assert Documents.list_tbl_document() == [document]
    end

    test "get_document!/1 returns the document with given id" do
      document = document_fixture()
      assert Documents.get_document!(document.id) == document
    end

    test "create_document/1 with valid data creates a document" do
      assert {:ok, %Document{} = document} = Documents.create_document(@valid_attrs)
      assert document.company_id == "some company_id"
      assert document.customer_id == "some customer_id"
      assert document.name == "some name"
      assert document.off_taker_id == "some off_taker_id"
      assert document.status == "some status"
      assert document.type_of_doc == "some type_of_doc"
      assert document.user_id == "some user_id"
    end

    test "create_document/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Documents.create_document(@invalid_attrs)
    end

    test "update_document/2 with valid data updates the document" do
      document = document_fixture()
      assert {:ok, %Document{} = document} = Documents.update_document(document, @update_attrs)
      assert document.company_id == "some updated company_id"
      assert document.customer_id == "some updated customer_id"
      assert document.name == "some updated name"
      assert document.off_taker_id == "some updated off_taker_id"
      assert document.status == "some updated status"
      assert document.type_of_doc == "some updated type_of_doc"
      assert document.user_id == "some updated user_id"
    end

    test "update_document/2 with invalid data returns error changeset" do
      document = document_fixture()
      assert {:error, %Ecto.Changeset{}} = Documents.update_document(document, @invalid_attrs)
      assert document == Documents.get_document!(document.id)
    end

    test "delete_document/1 deletes the document" do
      document = document_fixture()
      assert {:ok, %Document{}} = Documents.delete_document(document)
      assert_raise Ecto.NoResultsError, fn -> Documents.get_document!(document.id) end
    end

    test "change_document/1 returns a document changeset" do
      document = document_fixture()
      assert %Ecto.Changeset{} = Documents.change_document(document)
    end
  end

  describe "tbl_document" do
    alias LoanSavingsSystem.Documents.Document

    @valid_attrs %{company_id: "some company_id", customer_id: "some customer_id", name: "some name", off_taker_id: "some off_taker_id", status: "some status", type_of_doc: "some type_of_doc", user_id: "some user_id"}
    @update_attrs %{company_id: "some updated company_id", customer_id: "some updated customer_id", name: "some updated name", off_taker_id: "some updated off_taker_id", status: "some updated status", type_of_doc: "some updated type_of_doc", user_id: "some updated user_id"}
    @invalid_attrs %{company_id: nil, customer_id: nil, name: nil, off_taker_id: nil, status: nil, type_of_doc: nil, user_id: nil}

    def document_fixture(attrs \\ %{}) do
      {:ok, document} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Documents.create_document()

      document
    end

    test "list_tbl_document/0 returns all tbl_document" do
      document = document_fixture()
      assert Documents.list_tbl_document() == [document]
    end

    test "get_document!/1 returns the document with given id" do
      document = document_fixture()
      assert Documents.get_document!(document.id) == document
    end

    test "create_document/1 with valid data creates a document" do
      assert {:ok, %Document{} = document} = Documents.create_document(@valid_attrs)
      assert document.company_id == "some company_id"
      assert document.customer_id == "some customer_id"
      assert document.name == "some name"
      assert document.off_taker_id == "some off_taker_id"
      assert document.status == "some status"
      assert document.type_of_doc == "some type_of_doc"
      assert document.user_id == "some user_id"
    end

    test "create_document/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Documents.create_document(@invalid_attrs)
    end

    test "update_document/2 with valid data updates the document" do
      document = document_fixture()
      assert {:ok, %Document{} = document} = Documents.update_document(document, @update_attrs)
      assert document.company_id == "some updated company_id"
      assert document.customer_id == "some updated customer_id"
      assert document.name == "some updated name"
      assert document.off_taker_id == "some updated off_taker_id"
      assert document.status == "some updated status"
      assert document.type_of_doc == "some updated type_of_doc"
      assert document.user_id == "some updated user_id"
    end

    test "update_document/2 with invalid data returns error changeset" do
      document = document_fixture()
      assert {:error, %Ecto.Changeset{}} = Documents.update_document(document, @invalid_attrs)
      assert document == Documents.get_document!(document.id)
    end

    test "delete_document/1 deletes the document" do
      document = document_fixture()
      assert {:ok, %Document{}} = Documents.delete_document(document)
      assert_raise Ecto.NoResultsError, fn -> Documents.get_document!(document.id) end
    end

    test "change_document/1 returns a document changeset" do
      document = document_fixture()
      assert %Ecto.Changeset{} = Documents.change_document(document)
    end
  end

  describe "tbl_document_type" do
    alias LoanSavingsSystem.Documents.Document_Type

    @valid_attrs %{createdByUserId: 42, deleted_at: ~D[2010-04-17], description: "some description", documentFormats: "some documentFormats", name: "some name"}
    @update_attrs %{createdByUserId: 43, deleted_at: ~D[2011-05-18], description: "some updated description", documentFormats: "some updated documentFormats", name: "some updated name"}
    @invalid_attrs %{createdByUserId: nil, deleted_at: nil, description: nil, documentFormats: nil, name: nil}

    def document__type_fixture(attrs \\ %{}) do
      {:ok, document__type} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Documents.create_document__type()

      document__type
    end

    test "list_tbl_document_type/0 returns all tbl_document_type" do
      document__type = document__type_fixture()
      assert Documents.list_tbl_document_type() == [document__type]
    end

    test "get_document__type!/1 returns the document__type with given id" do
      document__type = document__type_fixture()
      assert Documents.get_document__type!(document__type.id) == document__type
    end

    test "create_document__type/1 with valid data creates a document__type" do
      assert {:ok, %Document_Type{} = document__type} = Documents.create_document__type(@valid_attrs)
      assert document__type.createdByUserId == 42
      assert document__type.deleted_at == ~D[2010-04-17]
      assert document__type.description == "some description"
      assert document__type.documentFormats == "some documentFormats"
      assert document__type.name == "some name"
    end

    test "create_document__type/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Documents.create_document__type(@invalid_attrs)
    end

    test "update_document__type/2 with valid data updates the document__type" do
      document__type = document__type_fixture()
      assert {:ok, %Document_Type{} = document__type} = Documents.update_document__type(document__type, @update_attrs)
      assert document__type.createdByUserId == 43
      assert document__type.deleted_at == ~D[2011-05-18]
      assert document__type.description == "some updated description"
      assert document__type.documentFormats == "some updated documentFormats"
      assert document__type.name == "some updated name"
    end

    test "update_document__type/2 with invalid data returns error changeset" do
      document__type = document__type_fixture()
      assert {:error, %Ecto.Changeset{}} = Documents.update_document__type(document__type, @invalid_attrs)
      assert document__type == Documents.get_document__type!(document__type.id)
    end

    test "delete_document__type/1 deletes the document__type" do
      document__type = document__type_fixture()
      assert {:ok, %Document_Type{}} = Documents.delete_document__type(document__type)
      assert_raise Ecto.NoResultsError, fn -> Documents.get_document__type!(document__type.id) end
    end

    test "change_document__type/1 returns a document__type changeset" do
      document__type = document__type_fixture()
      assert %Ecto.Changeset{} = Documents.change_document__type(document__type)
    end
  end
end
