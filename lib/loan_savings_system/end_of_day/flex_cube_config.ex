defmodule LoanSavingsSystem.EndOfDay.FlexCubeConfig do
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
  def changeset(flex_cube_config, attrs) do
    flex_cube_config
    |> cast(attrs, [:flex_cube_gl_id, :flex_cube_gl_code, :flex_cube_gl_name, :action_type, :dr_cr])
    |> validate_required([:flex_cube_gl_id, :flex_cube_gl_code, :flex_cube_gl_name, :action_type, :dr_cr])
  end
end
