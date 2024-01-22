defmodule LoanSavingsSystem.Accounts.SecurityQuestions do
  use Ecto.Schema
  import Ecto.Changeset

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
