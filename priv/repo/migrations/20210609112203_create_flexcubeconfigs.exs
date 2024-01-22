defmodule LoanSavingsSystem.Repo.Migrations.CreateFlexcubeconfigs do
  use Ecto.Migration

  def change do
    create table(:flexcubeconfigs) do
      add :flex_cube_gl_id, :integer
      add :flex_cube_gl_code, :string
      add :flex_cube_gl_name, :string
      add :action_type, :string
      add :dr_cr, :string

      timestamps()
    end

  end
end
