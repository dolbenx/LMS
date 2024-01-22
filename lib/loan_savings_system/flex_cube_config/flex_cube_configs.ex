defmodule LoanSavingsSystem.FlexCubeConfig.FlexCubeConfigs do
  use Ecto.Schema
  import Ecto.Changeset

  schema "flexcubeconfigs" do
    field :action_type, :string
    field :dr_cr, :string
    field :flex_cube_gl_code, :string
    field :flex_cube_gl_id, :integer
    field :flex_cube_gl_name, :string

    timestamps()
  end

  @doc false
  def changeset(flex_cube_configs, attrs) do
    flex_cube_configs
    |> cast(attrs, [:action_type, :dr_cr, :flex_cube_gl_code, :flex_cube_gl_id, :flex_cube_gl_name])
    |> validate_required([:action_type, :dr_cr, :flex_cube_gl_code, :flex_cube_gl_id, :flex_cube_gl_name])
  end
end
