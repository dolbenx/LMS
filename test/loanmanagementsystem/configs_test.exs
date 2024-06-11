defmodule Loanmanagementsystem.ConfigsTest do
  use Loanmanagementsystem.DataCase

  alias Loanmanagementsystem.Configs

  describe "tbl_titles" do
    alias Loanmanagementsystem.Configs.Titles

    import Loanmanagementsystem.ConfigsFixtures

    @invalid_attrs %{description: nil, maker: nil, status: nil, title: nil, updater: nil}

    test "list_tbl_titles/0 returns all tbl_titles" do
      titles = titles_fixture()
      assert Configs.list_tbl_titles() == [titles]
    end

    test "get_titles!/1 returns the titles with given id" do
      titles = titles_fixture()
      assert Configs.get_titles!(titles.id) == titles
    end

    test "create_titles/1 with valid data creates a titles" do
      valid_attrs = %{description: "some description", maker: 42, status: "some status", title: "some title", updater: 42}

      assert {:ok, %Titles{} = titles} = Configs.create_titles(valid_attrs)
      assert titles.description == "some description"
      assert titles.maker == 42
      assert titles.status == "some status"
      assert titles.title == "some title"
      assert titles.updater == 42
    end

    test "create_titles/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Configs.create_titles(@invalid_attrs)
    end

    test "update_titles/2 with valid data updates the titles" do
      titles = titles_fixture()
      update_attrs = %{description: "some updated description", maker: 43, status: "some updated status", title: "some updated title", updater: 43}

      assert {:ok, %Titles{} = titles} = Configs.update_titles(titles, update_attrs)
      assert titles.description == "some updated description"
      assert titles.maker == 43
      assert titles.status == "some updated status"
      assert titles.title == "some updated title"
      assert titles.updater == 43
    end

    test "update_titles/2 with invalid data returns error changeset" do
      titles = titles_fixture()
      assert {:error, %Ecto.Changeset{}} = Configs.update_titles(titles, @invalid_attrs)
      assert titles == Configs.get_titles!(titles.id)
    end

    test "delete_titles/1 deletes the titles" do
      titles = titles_fixture()
      assert {:ok, %Titles{}} = Configs.delete_titles(titles)
      assert_raise Ecto.NoResultsError, fn -> Configs.get_titles!(titles.id) end
    end

    test "change_titles/1 returns a titles changeset" do
      titles = titles_fixture()
      assert %Ecto.Changeset{} = Configs.change_titles(titles)
    end
  end
end
