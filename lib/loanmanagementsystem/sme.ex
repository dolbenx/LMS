# defmodule Loanmanagementsystem.Sme do
#   @moduledoc """
#   The Accounts context.
#   """

# #
#   # Loanmanagementsystem.Accounts.get_loan_customer_individual()

#   import Ecto.Query, warn: false
#   alias Loanmanagementsystem.Repo

#   alias Loanmanagementsystem.Accounts.User
#   alias Loanmanagementsystem.Accounts.UserBioData
#   alias Loanmanagementsystem.Accounts.UserRole
#   alias Loanmanagementsystem.Logs.UserLogs

#   def list_tbl_user_bio_data do
#     Repo.all(Company)
#   end

#   def list_tbl_user_logs do
#     Repo.all(Company)
#   end

#   def list_tbl_user_roles do
#     Repo.all(Company)
#   end

#   def list_tbl_users do
#     Repo.all(Company)
#   end

#   @doc """
#   Gets a single company.

#   Raises `Ecto.NoResultsError` if the Company does not exist.

#   ## Examples

#       iex> get_company!(123)
#       %Company{}

#       iex> get_company!(456)
#       ** (Ecto.NoResultsError)

#   """
#   def add_user_bio_data!(id), do: Repo.get!(UserBioData, id)

#   def add_user_logs!(id), do: Repo.get!(UserLogs, id)

#   def add_user_role!(id), do: Repo.get!(UserRole, id)

#   def add_user!(id), do: Repo.get!(User, id)

#   @doc """
#   Creates a company.

#   ## Examples

#       iex> create_company(%{field: value})
#       {:ok, %Company{}}

#       iex> create_company(%{field: bad_value})
#       {:error, %Ecto.Changeset{}}

#   """
#   def create_company(attrs \\ %{}) do
#     %Company{}
#     |> Company.changeset(attrs)
#     |> Repo.insert()
#   end
# end
