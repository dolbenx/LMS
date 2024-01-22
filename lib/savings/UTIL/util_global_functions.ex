defmodule Savings.Util do
  defmodule Time do
    #    def local_day(), do: Timex.now("Africa/Lusaka")
    def local_day(), do: Timex.now()
    #    def local_time2(), do: local_day() |> Calendar.DateTime.to_naive()
    def local_time2(),
      do:
        local_day()
        |> DateTime.truncate(:millisecond)
        |> Timex.to_naive_datetime()
        |> Timex.shift(hours: 2)

    def local_time(),
      do:
        local_day()
        |> DateTime.truncate(:second)
        |> Timex.to_naive_datetime()
        |> Timex.shift(hours: 2)
  end

  defmodule Sanitation do
    def special_character(str) do
      str |> HtmlEntities.decode()
    end
  end

  def alter_date_stamp do
    %{
      created_at: DateTime.utc_now() |> DateTime.truncate(:second) |> Timex.shift(hours: 2),
      updated_at: DateTime.utc_now() |> DateTime.truncate(:second) |> Timex.shift(hours: 2)
    }
  end
end
