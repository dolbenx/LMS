defmodule LoanSavingsSystem.SystemSetting.Telco do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_telco" do
    field :name, :string
    field :telcoIP, :string

    timestamps()
  end

  @doc false
  def changeset(telco, attrs) do
    telco
    |> cast(attrs, [:name, :telcoIP])
    |> validate_required([:name, :telcoIP])
  end
end
