defmodule Savings.MaintenanceFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Savings.Maintenance` context.
  """

  @doc """
  Generate a branch.
  """
  def branch_fixture(attrs \\ %{}) do
    {:ok, branch} =
      attrs
      |> Enum.into(%{
        branchCode: "some branchCode",
        branchName: "some branchName",
        isDefaultUSSDBranch: true,
        status: "some status"
      })
      |> Savings.Maintenance.create_branch()

    branch
  end

  @doc """
  Generate a charge.
  """
  def charge_fixture(attrs \\ %{}) do
    {:ok, charge} =
      attrs
      |> Enum.into(%{
        chargeAmount: "120.5",
        chargeName: "some chargeName",
        chargeType: "some chargeType",
        currencyId: 42,
        status: "some status"
      })
      |> Savings.Maintenance.create_charge()

    charge
  end
end
