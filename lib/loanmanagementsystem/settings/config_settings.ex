defmodule Loanmanagementsystem.Settings.ConfigSettings do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_config_settings" do
    field :deleted_at, :naive_datetime
    field :description, :string
    field :name, :string
    field :updated_by, :string
    field :value, :string
    field :value_type, :string

    timestamps()
  end

  @doc false
  def changeset(config_settings, attrs) do
    config_settings
    |> cast(attrs, [:name, :value, :value_type, :description, :deleted_at, :updated_by])
    |> validate_required([:name, :value, :value_type, :description, :deleted_at, :updated_by])
  end
end
