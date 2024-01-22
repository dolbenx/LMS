defmodule LoanmanagementsystemWeb.ProductController do
  use LoanmanagementsystemWeb, :controller
  # alias Loanmanagementsystem.Security.ParamsValidator
  alias Loanmanagementsystem.ProductServices.Product

  def list_loan_products(conn, params) do
    json(conn, Product.list_product_details(conn, params))
  end

end
