defmodule SFFoodTrucksWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use SFFoodTrucksWeb, :controller

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(html: SFFoodTrucksWeb.ErrorHTML, json: SFFoodTrucksWeb.ErrorJSON)
    |> render(:"404")
  end

  def call(conn, {:error, :no_valid_changes}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(html: SFFoodTrucksWeb.ErrorHTML, json: SFFoodTrucksWeb.ErrorJSON)
    |> render(:"422")
  end

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(json: SFFoodTrucksWeb.ChangesetJSON)
    |> render(:error, changeset: changeset)
  end

  def call(conn, {:error, _}) do
    conn
    |> put_status(:internal_server_error)
    |> put_view(html: SFFoodTrucksWeb.ErrorHTML, json: SFFoodTrucksWeb.ErrorJSON)
    |> render("500.json")
  end
end
