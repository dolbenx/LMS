defmodule LoanSavingsSystemWeb.FlexCubeConfigControllerTest do
  use LoanSavingsSystemWeb.ConnCase

  alias LoanSavingsSystem.EndOfDay

  @create_attrs %{action_type: "some action_type", dr_cr: "some dr_cr", flex_cube_gl_code: "some flex_cube_gl_code", flex_cube_gl_id: 42, flex_cube_gl_name: "some flex_cube_gl_name"}
  @update_attrs %{action_type: "some updated action_type", dr_cr: "some updated dr_cr", flex_cube_gl_code: "some updated flex_cube_gl_code", flex_cube_gl_id: 43, flex_cube_gl_name: "some updated flex_cube_gl_name"}
  @invalid_attrs %{action_type: nil, dr_cr: nil, flex_cube_gl_code: nil, flex_cube_gl_id: nil, flex_cube_gl_name: nil}

  def fixture(:flex_cube_config) do
    {:ok, flex_cube_config} = EndOfDay.create_flex_cube_config(@create_attrs)
    flex_cube_config
  end

  describe "index" do
    test "lists all flexcubeconfigs", %{conn: conn} do
      conn = get(conn, Routes.flex_cube_config_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Flexcubeconfigs"
    end
  end

  describe "new flex_cube_config" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.flex_cube_config_path(conn, :new))
      assert html_response(conn, 200) =~ "New Flex cube config"
    end
  end

  describe "create flex_cube_config" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.flex_cube_config_path(conn, :create), flex_cube_config: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.flex_cube_config_path(conn, :show, id)

      conn = get(conn, Routes.flex_cube_config_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Flex cube config"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.flex_cube_config_path(conn, :create), flex_cube_config: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Flex cube config"
    end
  end

  describe "edit flex_cube_config" do
    setup [:create_flex_cube_config]

    test "renders form for editing chosen flex_cube_config", %{conn: conn, flex_cube_config: flex_cube_config} do
      conn = get(conn, Routes.flex_cube_config_path(conn, :edit, flex_cube_config))
      assert html_response(conn, 200) =~ "Edit Flex cube config"
    end
  end

  describe "update flex_cube_config" do
    setup [:create_flex_cube_config]

    test "redirects when data is valid", %{conn: conn, flex_cube_config: flex_cube_config} do
      conn = put(conn, Routes.flex_cube_config_path(conn, :update, flex_cube_config), flex_cube_config: @update_attrs)
      assert redirected_to(conn) == Routes.flex_cube_config_path(conn, :show, flex_cube_config)

      conn = get(conn, Routes.flex_cube_config_path(conn, :show, flex_cube_config))
      assert html_response(conn, 200) =~ "some updated action_type"
    end

    test "renders errors when data is invalid", %{conn: conn, flex_cube_config: flex_cube_config} do
      conn = put(conn, Routes.flex_cube_config_path(conn, :update, flex_cube_config), flex_cube_config: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Flex cube config"
    end
  end

  describe "delete flex_cube_config" do
    setup [:create_flex_cube_config]

    test "deletes chosen flex_cube_config", %{conn: conn, flex_cube_config: flex_cube_config} do
      conn = delete(conn, Routes.flex_cube_config_path(conn, :delete, flex_cube_config))
      assert redirected_to(conn) == Routes.flex_cube_config_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.flex_cube_config_path(conn, :show, flex_cube_config))
      end
    end
  end

  defp create_flex_cube_config(_) do
    flex_cube_config = fixture(:flex_cube_config)
    {:ok, flex_cube_config: flex_cube_config}
  end
end
