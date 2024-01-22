defmodule Loanmanagementsystem.Chart_of_accounts.Chart_of_account do
  use Ecto.Schema
  use Endon
  import Ecto.Changeset

  @timestamps_opts [autogenerate: {Loanmanagementsystem.Accounts.Account.Localtime, :autogenerate, []}]
  schema "tbl_chart_of_accounts" do
    field :ac_gl_ccy, :string
    field :ac_ccy_res, :string
    field :ac_gl_descption, :string
    field :ac_gl_no, :string
    field :ac_open_date, :string
    field :ac_or_gl, :string
    field :ac_status, :string
    field :alt_ac_no, :string
    field :auth_status, :string
    field :branch_code, :string
    field :cust_name, :string
    field :cust_no, :string
    field :gl_branch_res, :string
    field :gl_category, :string
    field :gl_post_type, :string
    field :gl_type, :string
    field :leaf_or_node, :string
    field :node_gl, :string
    field :overall_limit, :string
    field :revaluation, :string
    field :uploafile_name, :string
    field :fcy_bal, :float
    field :lcy_bal, :float

    timestamps()
  end

  @doc false
  def changeset(chart_of_account, attrs) do
    chart_of_account
    |> cast(attrs, [
      :ac_gl_no,
      :ac_gl_ccy,
      :fcy_bal,
      :lcy_bal,
      :uploafile_name,
      :ac_ccy_res,
      :ac_or_gl,
      :cust_no,
      :gl_type,
      :ac_gl_descption,
      :alt_ac_no,
      :cust_name,
      :gl_category,
      :overall_limit,
      :revaluation,
      :ac_open_date,
      :gl_post_type,
      :branch_code,
      :gl_branch_res,
      :ac_status,
      :auth_status,
      :leaf_or_node,
      :node_gl
    ])
    |> validate_required([
      :ac_gl_no,
      :gl_type,
      :ac_gl_descption,
      :gl_category,
      :auth_status,
      :leaf_or_node,
      :node_gl
    ])
    |> unique_constraint(:ac_gl_no)
  end
end
