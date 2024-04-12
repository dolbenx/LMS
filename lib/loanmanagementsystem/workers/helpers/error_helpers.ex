defmodule Loanmanagementsystem.Workers.Helpers.ErrorHelper do
  import Phoenix.LiveView


  def get_results(socket, result) do
    case result do
      {:ok, msg} ->
        success_message(socket, msg)

      {:error, msg} ->
        error_message(socket, msg)
    end
  end

  defp success_message(%{assigns: _assigns} = socket, msg) do
    {
      :noreply,
      assign(socket, :success_modal, true)
      |> assign(:info_modal, false)
      |> assign(:error_modal, false)
      |> assign(info_wording: "Yes")
      |> assign(:success_message, msg)
    }
  end

  defp error_message(%{assigns: _assigns} = socket, msg) do
    {
      :noreply,
      assign(socket, :error_modal, true)
      |> assign(:info_modal, false)
      |> assign(:info_modal, false)
      |> assign(:maker_checker, false)
      |> assign(:success_modal, false)
      |> assign(info_wording: "Yes")
      |> assign(:error_message, msg)
    }
  end
end
