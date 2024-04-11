defmodule LoanSavingsSystem.Workers.Resource do
  # alias LoanSavingsSystem.Accounts.UserRole
  alias LoanSavingsSystem.Repo

  def random_string(length) do
    downcase =
      Enum.take_random(
        [
          "a",
          "b",
          "c",
          "d",
          "e",
          "f",
          "g",
          "h",
          "i",
          "j",
          "k",
          "l",
          "m",
          "n",
          "o",
          "p",
          "q",
          "r",
          "s",
          "t",
          "u",
          "v",
          "w",
          "x",
          "y",
          "z"
        ],
        1
      )
      |> Enum.reduce(fn x, acc -> x <> acc end)

    upcase =
      Enum.take_random(
        [
          "A",
          "B",
          "C",
          "D",
          "E",
          "F",
          "G",
          "H",
          "I",
          "J",
          "K",
          "L",
          "M",
          "N",
          "O",
          "P",
          "Q",
          "R",
          "S",
          "T",
          "U",
          "V",
          "W",
          "X",
          "Y",
          "Z"
        ],
        1
      )
      |> Enum.reduce(fn x, acc -> x <> acc end)

    spc =
      Enum.take_random(["@", "#", "$", "%", "&", "*", "?"], 1)
      |> Enum.reduce(fn x, acc -> x <> acc end)

    crpt = :crypto.strong_rand_bytes(length) |> Base.url_encode64() |> binary_part(0, length)
    downcase <> "" <> spc <> "" <> crpt <> "#{1..1000 |> Enum.random()}" <> upcase
  end

  # def to_atomic_map(string_map), do: AtomicMap.convert(string_map, %{safe: false})

  def otp(), do: to_string(Enum.random(1111..9999))

  # def update_permissions(%UserRole{} = user_role, permissions), do: Repo.update(UserRole.changeset(user_role, %{permissions:  Enum.reduce(permissions, fn x, acc -> x <> "~" <> acc end) } ) )
end
