defmodule LoanSavingsSystemWeb.EndOfDayEntryController do
  use LoanSavingsSystemWeb, :controller

  alias LoanSavingsSystem.EndOfDay
  alias LoanSavingsSystem.EndOfDay.EndOfDayEntry

  plug(
    LoanSavingsSystemWeb.Plugs.EnforcePasswordPolicy
      when action not in [:new_password, :change_password]
    )

  def index(conn, params) do
    tbl_end_of_day_entries = EndOfDay.list_tbl_end_of_day_entries()
    render(conn, "index.html", tbl_end_of_day_entries: tbl_end_of_day_entries)
  end

  def new(conn, _params) do
    changeset = EndOfDay.change_end_of_day_entry(%EndOfDayEntry{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"end_of_day_entry" => end_of_day_entry_params}) do
    case EndOfDay.create_end_of_day_entry(end_of_day_entry_params) do
      {:ok, end_of_day_entry} ->
        conn
        |> put_flash(:info, "End of day entry created successfully.")
        |> redirect(to: Routes.end_of_day_entry_path(conn, :show, end_of_day_entry))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    end_of_day_entry = EndOfDay.get_end_of_day_entry!(id)
    render(conn, "show.html", end_of_day_entry: end_of_day_entry)
  end

  def edit(conn, %{"id" => id}) do
    end_of_day_entry = EndOfDay.get_end_of_day_entry!(id)
    changeset = EndOfDay.change_end_of_day_entry(end_of_day_entry)
    render(conn, "edit.html", end_of_day_entry: end_of_day_entry, changeset: changeset)
  end

  def update(conn, %{"id" => id, "end_of_day_entry" => end_of_day_entry_params}) do
    end_of_day_entry = EndOfDay.get_end_of_day_entry!(id)

    case EndOfDay.update_end_of_day_entry(end_of_day_entry, end_of_day_entry_params) do
      {:ok, end_of_day_entry} ->
        conn
        |> put_flash(:info, "End of day entry updated successfully.")
        |> redirect(to: Routes.end_of_day_entry_path(conn, :show, end_of_day_entry))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", end_of_day_entry: end_of_day_entry, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    end_of_day_entry = EndOfDay.get_end_of_day_entry!(id)
    {:ok, _end_of_day_entry} = EndOfDay.delete_end_of_day_entry(end_of_day_entry)

    conn
    |> put_flash(:info, "End of day entry deleted successfully.")
    |> redirect(to: Routes.end_of_day_entry_path(conn, :index))
  end
  
  

	def formatFDId(id) do
		idLen = String.length("#{id}");
		fixedDepositNumber = String.pad_leading("#{id}", (6 - idLen), "0");
		fixedDepositNumber
	end
end
