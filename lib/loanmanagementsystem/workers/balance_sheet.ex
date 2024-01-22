defmodule LoanSavingsSystem.Workers.BalanceSheet do
  require Logger

  def generate(entry) do
    entry = entry
    details = map_entry(entry)
    template = read_template(details)
    data = details |> Enum.at(0)

    map = %{
      "local-debits" => data["local_total_debts"],
      "local-credits" => data["local_total_credits"]
      # "logo" => try do FundsMgt.System_settings.get_image().image_string rescue _-> "" end,
      # "company_name" => try do FundsMgt.System_settings.get_comapny_name().company_name rescue _-> "" end,
      # "town" => try do FundsMgt.System_settings.get_comapny_town().town rescue _-> "" end,
      # "branch_number" => try do FundsMgt.System_settings.get_comapny_number().branch_phone rescue _-> "" end,
      # "country" => try do FundsMgt.System_settings.get_comapny_country().country rescue _-> "" end,
      # "branch_address" => try do FundsMgt.System_settings.get_comapny_address().branch_address rescue _-> "" end
    }

    template
    |> :bbmustache.render(map, key_type: :binary)
    |> PdfGenerator.generate_binary!(
      page_width: "11.695",
      page_height: "8.26772",
      shell_params: ["--orientation", "landscape"]
    )

    # |> PdfGenerator.generate_binary!(page_width: "11.695", page_height: "8.26772") this is for potrait
  end

  defp read_template(entries) do
    template =
      Application.app_dir(:funds_mgt, "priv/static/Reports/balance_sheet.html.eex")
      |> File.read!()

    html_str =
      Enum.map(entries, fn entry ->
        """
        <tr>
            <td>{{ gl_code }}</td>
            <td>{{ gl_category }}</td>
            <td>{{ ledger_name }}</td>
            <td>{{ fcy_dr_bal }}</td>
            <td>{{ fcy_cr_bal }}</td>
            <td>{{ lyc_dr_bal }}</td>
            <td>{{ lyc_cr_bal }}</td>
        
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
        "gl_code" => to_string(x.gl_code),
        "gl_category" => to_string(x.gl_category),
        "ledger_name" => to_string(x.ledger_name),
        "fcy_dr_bal" => Number.Delimit.number_to_delimited(x.fcy_dr_bal),
        "fcy_cr_bal" => Number.Delimit.number_to_delimited(x.fcy_cr_bal),
        "lyc_dr_bal" => Number.Delimit.number_to_delimited(x.lyc_dr_bal),
        "lyc_cr_bal" => Number.Delimit.number_to_delimited(x.lyc_cr_bal),
        "local_total_debts" => Number.Delimit.number_to_delimited(x.local_total_debts),
        "local_total_credits" => Number.Delimit.number_to_delimited(x.local_total_credits),
        "foreign_total_debts" => Number.Delimit.number_to_delimited(x.foreign_total_debts),
        "foreign_total_credits" => Number.Delimit.number_to_delimited(x.foreign_total_credits)
      }
    end)
  end
end
