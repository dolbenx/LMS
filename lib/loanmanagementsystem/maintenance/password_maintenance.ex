defmodule Loanmanagementsystem.Maintenance.Password_maintenance do
  use Ecto.Schema
  use Endon
  import Ecto.Changeset
  @timestamps_opts [autogenerate: {Loanmanagementsystem.Loan.Loans.Localtime, :autogenerate, []}]
  @number_regex ~r(^[0-9]*$)

  schema "tbl_password_maintenance" do
    field :max_length, :string
    field :min_length, :string
    field :password_format, :string
    field :user_id, :integer

    timestamps()
  end

  @doc false
  def changeset(password_maintenance, attrs) do
    password_maintenance
    |> cast(attrs, [:user_id, :password_format, :min_length, :max_length])
    |> validate_required([:user_id, :password_format, :min_length, :max_length])
  end
end
