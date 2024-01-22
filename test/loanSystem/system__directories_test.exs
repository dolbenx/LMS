defmodule LoanSystem.System_DirectoriesTest do
  use LoanSystem.DataCase

  alias LoanSystem.System_Directories

  describe "tbl_system_directories" do
    alias LoanSystem.System_Directories.Directory

    @valid_attrs %{auth_status: "some auth_status", bulk_trns: "some bulk_trns", errors: "some errors", esb_complete: "some esb_complete", esb_download: "some esb_download", esb_failed: "some esb_failed", esb_pending: "some esb_pending", failed: "some failed", internet_trns: "some internet_trns", inwards: "some inwards", modification: "some modification", outwards: "some outwards", processed: "some processed", reason: "some reason"}
    @update_attrs %{auth_status: "some updated auth_status", bulk_trns: "some updated bulk_trns", errors: "some updated errors", esb_complete: "some updated esb_complete", esb_download: "some updated esb_download", esb_failed: "some updated esb_failed", esb_pending: "some updated esb_pending", failed: "some updated failed", internet_trns: "some updated internet_trns", inwards: "some updated inwards", modification: "some updated modification", outwards: "some updated outwards", processed: "some updated processed", reason: "some updated reason"}
    @invalid_attrs %{auth_status: nil, bulk_trns: nil, errors: nil, esb_complete: nil, esb_download: nil, esb_failed: nil, esb_pending: nil, failed: nil, internet_trns: nil, inwards: nil, modification: nil, outwards: nil, processed: nil, reason: nil}

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
      assert directory.auth_status == "some auth_status"
      assert directory.bulk_trns == "some bulk_trns"
      assert directory.errors == "some errors"
      assert directory.esb_complete == "some esb_complete"
      assert directory.esb_download == "some esb_download"
      assert directory.esb_failed == "some esb_failed"
      assert directory.esb_pending == "some esb_pending"
      assert directory.failed == "some failed"
      assert directory.internet_trns == "some internet_trns"
      assert directory.inwards == "some inwards"
      assert directory.modification == "some modification"
      assert directory.outwards == "some outwards"
      assert directory.processed == "some processed"
      assert directory.reason == "some reason"
    end

    test "create_directory/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = System_Directories.create_directory(@invalid_attrs)
    end

    test "update_directory/2 with valid data updates the directory" do
      directory = directory_fixture()
      assert {:ok, %Directory{} = directory} = System_Directories.update_directory(directory, @update_attrs)
      assert directory.auth_status == "some updated auth_status"
      assert directory.bulk_trns == "some updated bulk_trns"
      assert directory.errors == "some updated errors"
      assert directory.esb_complete == "some updated esb_complete"
      assert directory.esb_download == "some updated esb_download"
      assert directory.esb_failed == "some updated esb_failed"
      assert directory.esb_pending == "some updated esb_pending"
      assert directory.failed == "some updated failed"
      assert directory.internet_trns == "some updated internet_trns"
      assert directory.inwards == "some updated inwards"
      assert directory.modification == "some updated modification"
      assert directory.outwards == "some updated outwards"
      assert directory.processed == "some updated processed"
      assert directory.reason == "some updated reason"
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
