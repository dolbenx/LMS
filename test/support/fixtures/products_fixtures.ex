defmodule Savings.ProductsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Savings.Products` context.
  """

  @doc """
  Generate a products_period.
  """
  def products_period_fixture(attrs \\ %{}) do
    {:ok, products_period} =
      attrs
      |> Enum.into(%{
        periodDays: "some periodDays",
        periodType: "some periodType",
        productID: 42,
        status: "some status"
      })
      |> Savings.Products.create_products_period()

    products_period
  end
end
