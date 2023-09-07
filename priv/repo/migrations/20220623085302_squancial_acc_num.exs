defmodule Loanmanagementsystem.Repo.Migrations.SquancialAccNum do
  use Ecto.Migration

  def change do
    execute """
    CREATE SEQUENCE GenSequenceNumber
    START WITH 1
    INCREMENT BY 1
    """
  end
end
