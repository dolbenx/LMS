defmodule Savings.Repo.Migrations.ModifyFlexcubelogs do
  use Ecto.Migration

  def change do
    alter table(:flexcubelogs) do
      modify :request, :text
      modify :response_data, :text
    end
  end
end
