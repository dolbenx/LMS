defmodule Loanmanagementsystem.Services.Services do
  import Ecto.Query, warn: false
  alias Loanmanagementsystem.Repo
  alias Loanmanagementsystem.Maintenance.{District, Province, Currency, Country}

  # Loanmanagementsystem.Services.Services.get_all_districts
  def get_all_districts() do
    Repo.all(
      from(
        u in District,
        select: u
      )
    )
  end

  # Loanmanagementsystem.Services.Services.get_all_provinces
  def get_all_provinces() do
    Repo.all(
      from(
        u in Province,
        select: u
      )
    )
  end

  # Loanmanagementsystem.Services.Services.get_all_currencies
  #  def get_all_currencies() do
  #   Repo.all(
  #     from(
  #       u in Currency,
  #       join:
  #       where: u.countryId ==
  #       select: u
  #     )
  #   )
  # end

  # Loanmanagementsystem.Services.Services.get_all_currencies
  def get_all_currencies() do
    Currency
    |> join(:left, [cO], uB in "tbl_country", on: cO.countryId == uB.id)
    |> where([cO, uB], cO.countryId == uB.id)
    |> select([cO, uB], %{
      id: cO.id,
      countryId: cO.countryId,
      isoCode: cO.isoCode,
      name: cO.name,
      countryName: uB.name,
      currencyDecimal: cO.currencyDecimal
    })
    |> Repo.all()
  end

  # Loanmanagementsystem.Services.Services.admin_get_disbursed_loans
  def admin_get_disbursed_loans() do
    Repo.all(
      from(
        u in Loanmanagementsystem.Loan.Loans,
        where: u.status == ^"DISBUSED",
        select: u
      )
    )
  end

  # Loanmanagementsystem.Services.Services.admin_get_pending_loans
  def employer_get_pending_loans() do
    Repo.all(
      from(
        u in Loanmanagementsystem.Loan.Loans,
        where: u.status == ^"PENDING",
        select: u
      )
    )
  end

  # Loanmanagementsystem.Services.Services.admin_get_rejected_loans

  def employer_get_rejected_loans() do
    Repo.all(
      from(
        u in Loanmanagementsystem.Loan.Loans,
        where: u.status == ^"REJECTED",
        select: u
      )
    )
  end

  # Loanmanagementsystem.Services.Services.employer_get_all_loans
  def employer_get_all_loans() do
    Repo.all(
      from(
        u in Loanmanagementsystem.Loan.Loans,
        select: u
      )
    )
  end

  # Loanmanagementsystem.Services.Services.get_employer_userlogs(2)
  def get_employer_userlogs(id) do
    Loanmanagementsystem.Logs.UserLogs
    |> join(:left, [uL], uS in Loanmanagementsystem.Accounts.User, on: uL.user_id == uS.id)
    |> where([uL, uS], uS.company_id == ^id)
    |> select([uL, uS], %{
      id: uL.id,
      activity: uL.activity,
      user_id: uL.user_id
    })
    |> Repo.all()
  end
end
