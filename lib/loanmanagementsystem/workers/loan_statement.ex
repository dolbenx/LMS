defmodule LoanSavingsSystem.Workers.LoanStatement do
  def generate(entry) do
    entry = entry
    details = map_entry(entry)
    template = read_template(details)
    data = details |> Enum.at(0)

    map = %{
      "logo" =>
        try do
          ""
        rescue
          _ -> ""
        end
    }

    template
    |> :bbmustache.render(map, key_type: :binary)
    |> PdfGenerator.generate_binary!(page_width: "11.695", page_height: "8.26772")
  end

  defp read_template(entries) do
    template =
      Application.app_dir(:loanmanagementsystem, "priv/static/reports/loan_statement.html.eex")
      |> File.read!()

    html_str =
      Enum.map(entries, fn entry ->
        """
        <tr>
            <td>{{ transaction_date }}</td>
            <td>{{ narration }}</td>
            <td>{{ mno_mobile_no }}</td>
            <td>{{ amount }}</td>
            <td>{{ balance }}</td>
            <td>{{ balance }}</td>
        
        </tr>
        
        """
        |> :bbmustache.render(entry, key_type: :binary)
      end)

    body = "<tbody>" <> Enum.join(html_str, "") <> "</tbody>"
    String.replace(template, "<tbody></tbody>", body)
  end

  defp map_entry(entry) do
    Enum.map(entry, fn x ->
      %{
        "first_name" => to_string(x.first_name),
        "last_name" => to_string(x.last_name),
        "phone" => to_string(x.transaction_date),
        "email_address" => to_string(x.first_name),
        "transaction_date" => to_string(x.transaction_date),
        "mno_mobile_no" => to_string(x.mno_mobile_no),
        "bank_account_no" => to_string(x.bank_account_no),
        "principal_amount" => Number.Delimit.number_to_delimited(x.principal_amount),
        "repayment_amount" => Number.Delimit.number_to_delimited(x.repayment_amount),
        "closedon_date" => to_string(x.closedon_date),
        "amount" => Number.Delimit.number_to_delimited(x.amount),
        "narration" => to_string(x.narration)
      }
    end)
  end
end
