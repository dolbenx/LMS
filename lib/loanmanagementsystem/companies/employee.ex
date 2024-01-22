defmodule Loanmanagementsystem.Companies.Employee do
  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [autogenerate: {Loanmanagementsystem.Accounts.Account.Localtime, :autogenerate, []}]
  schema "tbl_employee" do
    field :companyId, :integer
    field :employerId, :integer
    field :status, :string
    field :userId, :integer
    field :userRoleId, :integer
    field :loan_limit, :decimal
    field :nrc_image, :string
    field :uploafile_name, :string

    timestamps()
  end

  @doc false
  def changeset(employee, attrs) do
    employee
    |> cast(attrs, [
      :loan_limit,
      :companyId,
      :employerId,
      :userRoleId,
      :userId,
      :status,
      :nrc_image,
      :uploafile_name
    ])

    # |> validate_required([:companyId, :employerId, :userRoleId, :userId, :status])
  end
end
