defmodule LoanSavingsSystem.UssdTest do
  use LoanSavingsSystem.DataCase

  alias LoanSavingsSystem.Ussd

  describe "ussd_requests" do
    alias LoanSavingsSystem.Ussd.UssdRequest

    @valid_attrs %{is_logged_in: 42, mobile_number: "some mobile_number", request_data: "some request_data", session_ended: 42, session_id: "some session_id"}
    @update_attrs %{is_logged_in: 43, mobile_number: "some updated mobile_number", request_data: "some updated request_data", session_ended: 43, session_id: "some updated session_id"}
    @invalid_attrs %{is_logged_in: nil, mobile_number: nil, request_data: nil, session_ended: nil, session_id: nil}

    def ussd_request_fixture(attrs \\ %{}) do
      {:ok, ussd_request} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Ussd.create_ussd_request()

      ussd_request
    end

    test "list_ussd_requests/0 returns all ussd_requests" do
      ussd_request = ussd_request_fixture()
      assert Ussd.list_ussd_requests() == [ussd_request]
    end

    test "get_ussd_request!/1 returns the ussd_request with given id" do
      ussd_request = ussd_request_fixture()
      assert Ussd.get_ussd_request!(ussd_request.id) == ussd_request
    end

    test "create_ussd_request/1 with valid data creates a ussd_request" do
      assert {:ok, %UssdRequest{} = ussd_request} = Ussd.create_ussd_request(@valid_attrs)
      assert ussd_request.is_logged_in == 42
      assert ussd_request.mobile_number == "some mobile_number"
      assert ussd_request.request_data == "some request_data"
      assert ussd_request.session_ended == 42
      assert ussd_request.session_id == "some session_id"
    end

    test "create_ussd_request/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Ussd.create_ussd_request(@invalid_attrs)
    end

    test "update_ussd_request/2 with valid data updates the ussd_request" do
      ussd_request = ussd_request_fixture()
      assert {:ok, %UssdRequest{} = ussd_request} = Ussd.update_ussd_request(ussd_request, @update_attrs)
      assert ussd_request.is_logged_in == 43
      assert ussd_request.mobile_number == "some updated mobile_number"
      assert ussd_request.request_data == "some updated request_data"
      assert ussd_request.session_ended == 43
      assert ussd_request.session_id == "some updated session_id"
    end

    test "update_ussd_request/2 with invalid data returns error changeset" do
      ussd_request = ussd_request_fixture()
      assert {:error, %Ecto.Changeset{}} = Ussd.update_ussd_request(ussd_request, @invalid_attrs)
      assert ussd_request == Ussd.get_ussd_request!(ussd_request.id)
    end

    test "delete_ussd_request/1 deletes the ussd_request" do
      ussd_request = ussd_request_fixture()
      assert {:ok, %UssdRequest{}} = Ussd.delete_ussd_request(ussd_request)
      assert_raise Ecto.NoResultsError, fn -> Ussd.get_ussd_request!(ussd_request.id) end
    end

    test "change_ussd_request/1 returns a ussd_request changeset" do
      ussd_request = ussd_request_fixture()
      assert %Ecto.Changeset{} = Ussd.change_ussd_request(ussd_request)
    end
  end
end
