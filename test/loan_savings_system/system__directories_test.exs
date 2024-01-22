defmodule LoanSavingsSystem.System_DirectoriesTest do
  use LoanSavingsSystem.DataCase

  alias LoanSavingsSystem.System_Directories

  describe "tbl_system_directories" do
    alias LoanSavingsSystem.System_Directories.Directory

    @valid_attrs %{bulk_trns: "some bulk_trns", esb_complete: "some esb_complete", esb_downloa: "some esb_downloa", failed: "some failed", processed: "some processed"}
    @update_attrs %{bulk_trns: "some updated bulk_trns", esb_complete: "some updated esb_complete", esb_downloa: "some updated esb_downloa", failed: "some updated failed", processed: "some updated processed"}
    @invalid_attrs %{bulk_trns: nil, esb_complete: nil, esb_downloa: nil, failed: nil, processed: nil}

    def directory_fixture(attrs \\ %{}) do
      {:ok, directory} =
        attrs
        |> Enum.into(@valid_attrs)
        |> System_Directories.create_directory()

      directory
    end

    test "list_tbl_system_directories/0 returns all tbl_system_directories" do
      directory = directory_fixture()
      assert System_Directories.list_tbl_system_directories() == [directory]
    end

    test "get_directory!/1 returns the directory with given id" do
      directory = directory_fixture()
      assert System_Directories.get_directory!(directory.id) == directory
    end

    test "create_directory/1 with valid data creates a directory" do
      assert {:ok, %Directory{} = directory} = System_Directories.create_directory(@valid_attrs)
      assert directory.bulk_trns == "some bulk_trns"
      assert directory.esb_complete == "some esb_complete"
      assert directory.esb_downloa == "some esb_downloa"
      assert directory.failed == "some failed"
      assert directory.processed == "some processed"
    end

    test "create_directory/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = System_Directories.create_directory(@invalid_attrs)
    end

    test "update_directory/2 with valid data updates the directory" do
      directory = directory_fixture()
      assert {:ok, %Directory{} = directory} = System_Directories.update_directory(directory, @update_attrs)
      assert directory.bulk_trns == "some updated bulk_trns"
      assert directory.esb_complete == "some updated esb_complete"
      assert directory.esb_downloa == "some updated esb_downloa"
      assert directory.failed == "some updated failed"
      assert directory.processed == "some updated processed"
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
