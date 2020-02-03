defmodule BrAppWeb.ReactionController do
  use BrAppWeb, :controller
  alias BrApp.Reaction
  alias BrApp.ETSGenserver

  def update_reaction(conn, params) do
    reaction = Reaction.from_map(params)

    case add_reaction(reaction) do
      {:ok, rec} ->
        conn |> put_status(201) |> render("reaction.json", reaction: rec)

      {:error, :none} ->
        conn |> put_status(404) |> render("404.json", %{content_id: params["content_id"]})

      {:error, _} ->
        conn |> put_status(400) |> render("400.json", params: params)
    end
  end

  def get_reactions(conn, %{"content_id" => content_id}) do
    case ETSGenserver.search_reaction(content_id) do
      {:ok, fires} ->
        render(conn, "reaction_counts.json", %{fires: fires, content_id: content_id})

      {:error} ->
        conn |> put_status(404) |> render("404.json", %{content_id: content_id})
    end
  end

  def add_reaction({:ok, reaction}) do
    case reaction.action do
      "add" ->
        ETSGenserver.add_reaction(reaction)
        {:ok, reaction}

      "remove" ->
        remove_reaction(reaction)
    end
  end

  def remove_reaction(reaction) do
    case ETSGenserver.search_user_reaction(reaction) do
      {:ok, _} ->
        ETSGenserver.remove_reaction(reaction)
        {:ok, reaction}

      {:error} ->
        {:error, :none}
    end
  end

  def add_reaction(_) do
    {:error, {}}
  end
end
