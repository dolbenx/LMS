defmodule Loanmanagementsystem.Workers.Utlis.Utils do

  def sanitize_term(term), do: "%#{String.replace(term, "%", "\\%")}%"

  def decode_id(encoded_id) do
    decoded_id = Base.decode64!(encoded_id)
    String.to_integer(decoded_id)
  end

  def encode_id(id) do
    to_string(id)
    |> Base.encode64()
  end


  def timestamp do
    :os.system_time(:seconds)
  end


  def redirect_to_back(conn) do
    case List.keyfind(conn.req_headers, "referer", 0) do
      {"referer", referer} ->
        referer
        |> URI.parse()
        |> Map.get(:path)

      nil ->
        conn.request_path
    end
  end


  def time_stamp_ref() do
    Timex.now() |> Timex.format!("%Y%m%d%H%M%S", :strftime)
  end


  def local_datetime() do
    Timex.local() |> DateTime.to_naive()
  end

  def schema_time() do
    Timex.local() |> DateTime.to_naive() |> NaiveDateTime.truncate(:second)
  end

  def now() do
    {{y, m, d}, {h, mi, s}} = :calendar.local_time()
    month = to_string(m)
    month = if String.length(month) < 2, do: "0" <> month , else: month
    today =  to_string(y) <> month <> to_string(d)
    time = to_string(h) <> to_string(mi) <> to_string(s)
    today <> "T"<> time
  end

  def random_string(length) do
    :crypto.strong_rand_bytes(length)
    |> Base.url_encode64()
    |> binary_part(0, length)
  end

  def rand_str(), do: to_string(Enum.random(111..999))

  def to_atomic_map(string_map) do
    AtomicMap.convert(string_map, %{safe: false})
  end

  def traverse_errors(errors) do
    errors = for {key, {msg, _opts}} <- errors, do: "#{key} #{msg}"
    List.first(errors)
  end

  def to_db_date(date) do
    if String.contains?(date, "/") == true do
      [y,m,d] = String.split(date, ["/"], parts: 3)|>Enum.map(&String.to_integer/1)
      date = y <> "-" <> m <> "-" <> d
      Date.from_iso8601!(date)
    else
      date
    end
  end

  def to_naive_datetime(date) do
    y = date.year
    m = date.month
    d = date.day
    {:ok, date} = NaiveDateTime.new(y, m, d, 0, 0, 0)
    date
  end


  def get_randstr() do
    "0123456789"
    |> String.codepoints
    |> Enum.take_random(10)
    |> Enum.join
  end


  def gen_ref() do
    date = Timex.format!(Date.utc_today(), "%y%m%d", :strftime)
    random_int = to_string(Enum.random(1111..9999))
    date <> random_int
  end




  def gen_token() do
    to_string(Enum.random(100_000..999_999))
  end

  def gen_refs(user) do
    t = Timex.local() |> Timex.format!("%Y%m%d%H%M%S", :strftime)
    t<>to_string(user.id)
  end

  def gen_refs() do
    t = Timex.local() |> Timex.format!("%Y%m%d%H%M%S", :strftime)
    rand = to_string(Enum.random(100_000..999_999))
    :crypto.hash(:sha256, t<>rand)
    |> Base.encode16()
    |> String.upcase()
    |> String.slice(1..14)
  end



  def td_status(status) do
    case status do
      "SUCCESS"-> "SUCCESS"
      "DENIED"-> "DROPPED"
      "ACTIVE"-> "ACTIVE"
      "INACTIVE"-> "INACTIVE"
      "DEACTIVATED"-> "DEACTIVATED"
      "BLOCKED"-> "BLOCKED"
      "PENDING_APPROVAL"-> "PENDING APPROVAL"
      _any-> status
    end
  end


end
