defmodule Loanmanagementsystem.Maintenance.Maker_checker do
  use Ecto.Schema
  import Ecto.Changeset
  @timestamps_opts [autogenerate: {Loanmanagementsystem.Loan.Loans.Localtime, :autogenerate, []}]
  @number_regex ~r(^[0-9]*$)

  schema "tbl_maker_checker" do
    field :checker, :string
    field :maker, :string
    field :module, :string
    field :module_code, :string

    timestamps()
  end

  @doc false
  def changeset(maker_checker, attrs) do
    maker_checker
    |> cast(attrs, [:module, :module_code, :maker, :checker])
    |> validate_required([:module, :module_code, :maker, :checker])
  end
end
