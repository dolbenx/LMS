defmodule Loanmanagementsystem.Maintenance.Company_maintenance do
  use Ecto.Schema
  use Endon
  import Ecto.Changeset

  @timestamps_opts [autogenerate: {Loanmanagementsystem.Accounts.Account.Localtime, :autogenerate, []}]
  schema "tbl_company_maintanence" do
    field :address, :string
    field :company_logo, :string
    field :company_name, :string
    field :company_reg_no, :string
    field :country, :string
    field :currency, :string
    field :phone_no, :string
    field :town, :string
    field :tpin, :string

    timestamps()
  end

  @doc false
  def changeset(company_maintenance, attrs) do
    company_maintenance
    |> cast(attrs, [
      :company_name,
      :company_reg_no,
      :company_logo,
      :tpin,
      :currency,
      :country,
      :town,
      :address,
      :phone_no
    ])
    |> validate_required([
      :company_name,
      :company_reg_no,
      :company_logo,
      :tpin,
      :currency,
      :country,
      :town,
      :address,
      :phone_no
    ])
  end
end
