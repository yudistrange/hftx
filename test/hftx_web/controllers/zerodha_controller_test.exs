defmodule HftxWeb.Controllers.ZerodhaControllerTest do
  use HftxWeb.ConnCase, async: true
  import Mock

  describe "Zerodha Related APIs" do
    test "Sends the status", %{conn: conn} do
      conn = get(conn, "/api/zerodha")
      assert json_response(conn, 200) == %{"status" => "healthy"}
    end

    test "Can't update the token store with bad token", %{conn: conn} do
      conn = put(conn, "/api/zerodha/token", %{"access_token" => "blah"})

      assert json_response(conn, 500) == %{
               "error" => %{"details" => "Failed to update the token"}
             }
    end

    test "Fail with bad-request when token is missing in the request payload", %{conn: conn} do
      conn = put(conn, "/api/zerodha/token", %{})

      assert json_response(conn, 400) == %{
               "error" => %{"details" => "Access token missing in request payload"}
             }
    end

    test "Update the token store & start websocket with the right token", %{conn: conn} do
      with_mock Hftx.Zerodha, init: fn "access_granted" -> :ok end do
        conn = put(conn, "/api/zerodha/token", %{"access_token" => "access_granted"})

        assert json_response(conn, 200) == %{
                 "data" => %{"message" => "Token updated successfully"}
               }
      end
    end
  end
end
