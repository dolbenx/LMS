defmodule Loanmanagementsystem.ProductServices.Product do
  alias Loanmanagementsystem.Notifications.Messages
  alias Loanmanagementsystem.Products


def list_product_details(conn, _params) do
  products = Loanmanagementsystem.Operations.get_products_individual()
  Messages.success_message("Products List", %{products: products})
end






end
