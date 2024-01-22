defmodule LoanSavingsSystem.SystemSetting.SystemSettings do
  use Endon
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_system_settings" do
    field :name, :string
    field :value, :string

    timestamps()
  end

  @doc false
  def changeset(system_settings, attrs) do
    system_settings
    |> cast(attrs, [:name, :value])
    |> validate_required([:name, :value])
  end
end
