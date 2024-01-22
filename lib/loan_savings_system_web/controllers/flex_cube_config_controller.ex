defmodule LoanSavingsSystemWeb.FlexCubeConfigController do
  use LoanSavingsSystemWeb, :controller

  alias LoanSavingsSystem.EndOfDay
  alias LoanSavingsSystem.EndOfDay.FlexCubeConfig

  plug(
    LoanSavingsSystemWeb.Plugs.EnforcePasswordPolicy
      when action not in [:new_password, :change_password]
    )

  def index(conn, _params) do
    flexcubeconfigs = EndOfDay.list_flexcubeconfigs()
    render(conn, "index.html", flexcubeconfigs: flexcubeconfigs)
  end

  def new(conn, _params) do
    changeset = EndOfDay.change_flex_cube_config(%FlexCubeConfig{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"flex_cube_config" => flex_cube_config_params}) do
    case EndOfDay.create_flex_cube_config(flex_cube_config_params) do
      {:ok, flex_cube_config} ->
        conn
        |> put_flash(:info, "Flex cube config created successfully.")
        |> redirect(to: Routes.flex_cube_config_path(conn, :show, flex_cube_config))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    flex_cube_config = EndOfDay.get_flex_cube_config!(id)
    render(conn, "show.html", flex_cube_config: flex_cube_config)
  end

  def edit(conn, %{"id" => id}) do
    flex_cube_config = EndOfDay.get_flex_cube_config!(id)
    changeset = EndOfDay.change_flex_cube_config(flex_cube_config)
    render(conn, "edit.html", flex_cube_config: flex_cube_config, changeset: changeset)
  end

  def update(conn, %{"id" => id, "flex_cube_config" => flex_cube_config_params}) do
    flex_cube_config = EndOfDay.get_flex_cube_config!(id)

    case EndOfDay.update_flex_cube_config(flex_cube_config, flex_cube_config_params) do
      {:ok, flex_cube_config} ->
        conn
        |> put_flash(:info, "Flex cube config updated successfully.")
        |> redirect(to: Routes.flex_cube_config_path(conn, :show, flex_cube_config))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", flex_cube_config: flex_cube_config, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    flex_cube_config = EndOfDay.get_flex_cube_config!(id)
    {:ok, _flex_cube_config} = EndOfDay.delete_flex_cube_config(flex_cube_config)

    conn
    |> put_flash(:info, "Flex cube config deleted successfully.")
    |> redirect(to: Routes.flex_cube_config_path(conn, :index))
  end
end
