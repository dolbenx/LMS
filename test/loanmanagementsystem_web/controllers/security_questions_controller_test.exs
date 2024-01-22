defmodule LoanmanagementsystemWeb.Security_questionsControllerTest do
  use LoanmanagementsystemWeb.ConnCase

  alias Loanmanagementsystem.Maintenance

  @create_attrs %{
    productType: "some productType",
    question: "some question",
    status: "some status"
  }
  @update_attrs %{
    productType: "some updated productType",
    question: "some updated question",
    status: "some updated status"
  }
  @invalid_attrs %{productType: nil, question: nil, status: nil}

  def fixture(:security_questions) do
    {:ok, security_questions} = Maintenance.create_security_questions(@create_attrs)
    security_questions
  end

  describe "index" do
    test "lists all tbl_security_questions", %{conn: conn} do
      conn = get(conn, Routes.security_questions_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Tbl security questions"
    end
  end

  describe "new security_questions" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.security_questions_path(conn, :new))
      assert html_response(conn, 200) =~ "New Security questions"
    end
  end

  describe "create security_questions" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn =
        post(conn, Routes.security_questions_path(conn, :create),
          security_questions: @create_attrs
        )

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.security_questions_path(conn, :show, id)

      conn = get(conn, Routes.security_questions_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Security questions"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn =
        post(conn, Routes.security_questions_path(conn, :create),
          security_questions: @invalid_attrs
        )

      assert html_response(conn, 200) =~ "New Security questions"
    end
  end

  describe "edit security_questions" do
    setup [:create_security_questions]

    test "renders form for editing chosen security_questions", %{
      conn: conn,
      security_questions: security_questions
    } do
      conn = get(conn, Routes.security_questions_path(conn, :edit, security_questions))
      assert html_response(conn, 200) =~ "Edit Security questions"
    end
  end

  describe "update security_questions" do
    setup [:create_security_questions]

    test "redirects when data is valid", %{conn: conn, security_questions: security_questions} do
      conn =
        put(conn, Routes.security_questions_path(conn, :update, security_questions),
          security_questions: @update_attrs
        )

      assert redirected_to(conn) ==
               Routes.security_questions_path(conn, :show, security_questions)

      conn = get(conn, Routes.security_questions_path(conn, :show, security_questions))
      assert html_response(conn, 200) =~ "some updated productType"
    end

    test "renders errors when data is invalid", %{
      conn: conn,
      security_questions: security_questions
    } do
      conn =
        put(conn, Routes.security_questions_path(conn, :update, security_questions),
          security_questions: @invalid_attrs
        )

      assert html_response(conn, 200) =~ "Edit Security questions"
    end
  end

  describe "delete security_questions" do
    setup [:create_security_questions]

    test "deletes chosen security_questions", %{
      conn: conn,
      security_questions: security_questions
    } do
      conn = delete(conn, Routes.security_questions_path(conn, :delete, security_questions))
      assert redirected_to(conn) == Routes.security_questions_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.security_questions_path(conn, :show, security_questions))
      end
    end
  end

  defp create_security_questions(_) do
    security_questions = fixture(:security_questions)
    %{security_questions: security_questions}
  end
end
