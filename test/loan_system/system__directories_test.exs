defmodule LoanSystem.System_DirectoriesTest do
  use LoanSystem.DataCase

  alias LoanSystem.System_Directories

  describe "tbl_documents" do
    alias LoanSystem.System_Directories.Directory

    @valid_attrs %{document_file: "some document_file", document_type: "some document_type", external_id: "some external_id"}
    @update_attrs %{document_file: "some updated document_file", document_type: "some updated document_type", external_id: "some updated external_id"}
    @invalid_attrs %{document_file: nil, document_type: nil, external_id: nil}

    def directory_fixture(attrs \\ %{}) do
      {:ok, directory} =
        attrs
        |> Enum.into(@valid_attrs)
        |> System_Directories.create_directory()

      directory
    end

    test "list_tbl_documents/0 returns all tbl_documents" do
      directory = directory_fixture()
      assert System_Directories.list_tbl_documents() == [directory]
    end

    test "get_directory!/1 returns the directory with given id" do
      directory = directory_fixture()
      assert System_Directories.get_directory!(directory.id) == directory
    end

    test "create_directory/1 with valid data creates a directory" do
      assert {:ok, %Directory{} = directory} = System_Directories.create_directory(@valid_attrs)
      assert directory.document_file == "some document_file"
      assert directory.document_type == "some document_type"
      assert directory.external_id == "some external_id"
    end

    test "create_directory/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = System_Directories.create_directory(@invalid_attrs)
    end

    test "update_directory/2 with valid data updates the directory" do
      directory = directory_fixture()
      assert {:ok, %Directory{} = directory} = System_Directories.update_directory(directory, @update_attrs)
      assert directory.document_file == "some updated document_file"
      assert directory.document_type == "some updated document_type"
      assert directory.external_id == "some updated external_id"
    end

    test "update_directory/2 with invalid data returns error changeset" do
      directory = directory_fixture()
      assert {:error, %Ecto.Changeset{}} = System_Directories.update_directory(directory, @invalid_attrs)
      assert directory == System_Directories.get_directory!(directory.id)
    end

    test "delete_directory/1 deletes the directory" do
      directory = directory_fixture()
      assert {:ok, %Directory{}} = System_Directories.delete_directory(directory)
      assert_raise Ecto.NoResultsError, fn -> System_Directories.get_directory!(directory.id) end
    end

    test "change_directory/1 returns a directory changeset" do
      directory = directory_fixture()
      assert %Ecto.Changeset{} = System_Directories.change_directory(directory)
    end
  end
end
