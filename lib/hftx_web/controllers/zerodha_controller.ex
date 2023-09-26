defmodule HftxWeb.Controllers.ZerodhaController do
  use HftxWeb, :controller
  alias Hftx.Zerodha

  def update_token(conn, %{"access_token" => access_token}) do
    case Zerodha.init(access_token) do
      :ok ->
        conn
        |> put_status(:ok)
        |> json(%{data: %{message: "Token updated successfully"}})

      :error ->
        conn
        |> put_status(:internal_server_error)
        |> json(%{error: %{details: "Failed to update the token"}})
    end
  end

  def update_token(conn, _params) do
    conn
    |> put_status(:bad_request)
    |> json(%{error: %{details: "Access token missing in request payload"}})
  end

  def status(conn, _) do
    case Zerodha.status() do
      {:ok, :not_initialized} ->
        conn
        |> put_status(:ok)
        |> json(%{data: %{message: "Not initialized"}})

      {:ok, :running} ->
        conn
        |> put_status(:ok)
        |> json(%{data: %{message: "Healthy"}})

      {:error, :invalid_token} ->
        conn
        |> put_status(:failed_dependency)
        |> json(%{error: %{details: "Invalid token, unable to run websocket connection"}})

      {:error, :unexpected_state} ->
        conn
        |> put_status(:internal_server_error)
        |> json(%{error: %{details: "Zerodha process tree in unexpected state"}})
    end
  end
end
