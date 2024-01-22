defmodule Loanmanagementsystem.Maintenance.Maker_checker do
  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [autogenerate: {Loanmanagementsystem.Accounts.Account.Localtime, :autogenerate, []}]
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
