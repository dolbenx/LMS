defmodule Loanmanagementsystem.ConfigsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Loanmanagementsystem.Configs` context.
  """

  @doc """
  Generate a titles.
  """
  def titles_fixture(attrs \\ %{}) do
    {:ok, titles} =
      attrs
      |> Enum.into(%{
        description: "some description",
        maker: 42,
        status: "some status",
        title: "some title",
        updater: 42
      })
      |> Loanmanagementsystem.Configs.create_titles()

    titles
  end
end
