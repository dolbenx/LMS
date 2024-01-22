defmodule LoanSavingsSystemWeb.EmployeeView do
  use LoanSavingsSystemWeb, :view

  def if_map(amount) do
    IO.inspect(amount, label: "5555555555555")
    if is_list(amount) == true do
      map = Enum.at(amount, 1)
      principal = map["principal"] || map[:principal]
        principal
    else
      amount

    end
  end
end
