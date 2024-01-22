defmodule LoanSystem.UssdsTest do
  use LoanSystem.DataCase

  alias LoanSystem.Ussds

  describe "tbl_ussd_requests" do
    alias LoanSystem.Ussds.Ussd_Request

    @valid_attrs %{mobile_number: "some mobile_number", request_data: "some request_data", session_ended: "some session_ended", session_id: "some session_id"}
    @update_attrs %{mobile_number: "some updated mobile_number", request_data: "some updated request_data", session_ended: "some updated session_ended", session_id: "some updated session_id"}
    @invalid_attrs %{mobile_number: nil, request_data: nil, session_ended: nil, session_id: nil}

    def ussd__request_fixture(attrs \\ %{}) do
      {:ok, ussd__request} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Ussds.create_ussd__request()

      ussd__request
    end

    test "list_tbl_ussd_requests/0 returns all tbl_ussd_requests" do
      ussd__request = ussd__request_fixture()
      assert Ussds.list_tbl_ussd_requests() == [ussd__request]
    end

    test "get_ussd__request!/1 returns the ussd__request with given id" do
      ussd__request = ussd__request_fixture()
      assert Ussds.get_ussd__request!(ussd__request.id) == ussd__request
    end

    test "create_ussd__request/1 with valid data creates a ussd__request" do
      assert {:ok, %Ussd_Request{} = ussd__request} = Ussds.create_ussd__request(@valid_attrs)
      assert ussd__request.mobile_number == "some mobile_number"
      assert ussd__request.request_data == "some request_data"
      assert ussd__request.session_ended == "some session_ended"
      assert ussd__request.session_id == "some session_id"
    end

    test "create_ussd__request/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Ussds.create_ussd__request(@invalid_attrs)
    end

    test "update_ussd__request/2 with valid data updates the ussd__request" do
      ussd__request = ussd__request_fixture()
      assert {:ok, %Ussd_Request{} = ussd__request} = Ussds.update_ussd__request(ussd__request, @update_attrs)
      assert ussd__request.mobile_number == "some updated mobile_number"
      assert ussd__request.request_data == "some updated request_data"
      assert ussd__request.session_ended == "some updated session_ended"
      assert ussd__request.session_id == "some updated session_id"
    end

    test "update_ussd__request/2 with invalid data returns error changeset" do
      ussd__request = ussd__request_fixture()
      assert {:error, %Ecto.Changeset{}} = Ussds.update_ussd__request(ussd__request, @invalid_attrs)
      assert ussd__request == Ussds.get_ussd__request!(ussd__request.id)
    end

    test "delete_ussd__request/1 deletes the ussd__request" do
      ussd__request = ussd__request_fixture()
      assert {:ok, %Ussd_Request{}} = Ussds.delete_ussd__request(ussd__request)
      assert_raise Ecto.NoResultsError, fn -> Ussds.get_ussd__request!(ussd__request.id) end
    end

    test "change_ussd__request/1 returns a ussd__request changeset" do
      ussd__request = ussd__request_fixture()
      assert %Ecto.Changeset{} = Ussds.change_ussd__request(ussd__request)
    end
  end
end
