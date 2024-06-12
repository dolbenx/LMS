defmodule Loanmanagementsystem.MaintenanceFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Loanmanagementsystem.Maintenance` context.
  """

  @doc """
  Generate a bank.
  """
  def bank_fixture(attrs \\ %{}) do
    {:ok, bank} =
      attrs
      |> Enum.into(%{
        acronym: "some acronym",
        approved_by: 42,
        bank_address: "some bank_address",
        bank_code: "some bank_code",
        bank_descrip: "some bank_descrip",
        bank_name: "some bank_name",
        city_id: 42,
        country_id: 42,
        created_by: 42,
        district_id: 42,
        process_branch: "some process_branch",
        province_id: 42,
        status: "some status",
        swift_code: "some swift_code"
      })
      |> Loanmanagementsystem.Maintenance.create_bank()

    bank
  end

  @doc """
  Generate a branch.
  """
  def branch_fixture(attrs \\ %{}) do
    {:ok, branch} =
      attrs
      |> Enum.into(%{
        : 42,
        approved_by: 42,
        bank_id: "some bank_id",
        branch_address: "some branch_address",
        branch_code: "some branch_code",
        branch_name: "some branch_name",
        city_id: 42,
        country_id: 42,
        created_by: 42,
        district_id: 42,
        is_default_ussd_branch: true,
        province_id: 42,
        status: "some status"
      })
      |> Loanmanagementsystem.Maintenance.create_branch()

    branch
  end

  @doc """
  Generate a country.
  """
  def country_fixture(attrs \\ %{}) do
    {:ok, country} =
      attrs
      |> Enum.into(%{
        approved_by: 42,
        code: "some code",
        country_file_name: "some country_file_name",
        created_by: 42,
        name: "some name",
        status: "some status"
      })
      |> Loanmanagementsystem.Maintenance.create_country()

    country
  end

  @doc """
  Generate a province.
  """
  def province_fixture(attrs \\ %{}) do
    {:ok, province} =
      attrs
      |> Enum.into(%{
        approved_by: 42,
        country_id: 42,
        created_by: 42,
        name: "some name",
        status: "some status"
      })
      |> Loanmanagementsystem.Maintenance.create_province()

    province
  end

  @doc """
  Generate a district.
  """
  def district_fixture(attrs \\ %{}) do
    {:ok, district} =
      attrs
      |> Enum.into(%{
        approved_by: 42,
        country_id: 42,
        created_by: 42,
        name: "some name",
        province_id: 42,
        status: "some status"
      })
      |> Loanmanagementsystem.Maintenance.create_district()

    district
  end

  @doc """
  Generate a currency.
  """
  def currency_fixture(attrs \\ %{}) do
    {:ok, currency} =
      attrs
      |> Enum.into(%{
        acronym: "some acronym",
        approved_by: 42,
        country_id: 42,
        created_by: 42,
        currency_decimal: 42,
        iso_code: "some iso_code",
        name: "some name",
        status: "some status"
      })
      |> Loanmanagementsystem.Maintenance.create_currency()

    currency
  end
end
