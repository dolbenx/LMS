defmodule Loanmanagementsystem.Accounts.SecurityQuestions do
  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [autogenerate: {Loanmanagementsystem.Accounts.Account.Localtime, :autogenerate, []}]
  schema "tbl_security_questions" do
    field :question, :string
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(security_questions, attrs) do
    security_questions
    |> cast(attrs, [:question, :status])
    |> validate_required([:question, :status])
  end
end
