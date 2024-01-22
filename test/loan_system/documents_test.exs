defmodule LoanSystem.DocumentsTest do
  use LoanSystem.DataCase

  alias LoanSystem.Documents

  describe "tbl_documents" do
    alias LoanSystem.Documents.Document

    @valid_attrs %{document_file: "some document_file", document_type: "some document_type", external_id: "some external_id"}
    @update_attrs %{document_file: "some updated document_file", document_type: "some updated document_type", external_id: "some updated external_id"}
    @invalid_attrs %{document_file: nil, document_type: nil, external_id: nil}

    def document_fixture(attrs \\ %{}) do
      {:ok, document} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Documents.create_document()

      document
    end

    test "list_tbl_documents/0 returns all tbl_documents" do
      document = document_fixture()
      assert Documents.list_tbl_documents() == [document]
    end

    test "get_document!/1 returns the document with given id" do
      document = document_fixture()
      assert Documents.get_document!(document.id) == document
    end

    test "create_document/1 with valid data creates a document" do
      assert {:ok, %Document{} = document} = Documents.create_document(@valid_attrs)
      assert document.document_file == "some document_file"
      assert document.document_type == "some document_type"
      assert document.external_id == "some external_id"
    end

    test "create_document/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Documents.create_document(@invalid_attrs)
    end

    test "update_document/2 with valid data updates the document" do
      document = document_fixture()
      assert {:ok, %Document{} = document} = Documents.update_document(document, @update_attrs)
      assert document.document_file == "some updated document_file"
      assert document.document_type == "some updated document_type"
      assert document.external_id == "some updated external_id"
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
end
