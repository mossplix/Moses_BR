defmodule BrAppWeb.ReactionView do
  use BrAppWeb, :view

  @doc """
     Get reaction counts as json
  """
  def render("reaction_counts.json", %{fires: fires, content_id: content_id}) do
    %{
      content_id: content_id,
      reaction_count: %{
        fire: fires
      }
    }
  end

  @doc """
    View for a successful post when no response is expected
  """
  def render("reaction.json", _) do
    %{
      status_code: "201",
      message: "success"
    }
  end

  @doc """
    view for when the request params are invalid
  """
  def render("400.json", %{params: params}) do
    %{
      error: "Bad request",
      status_code: "400",
      request_params: params
    }
  end

  @doc """
   Json returned when content_id is not found
  """
  def render("404.json", %{content_id: content_id}) do
    %{
      error: "Reaction with content_id `" <> content_id <> "` not found",
      status_code: "404"
    }
  end
end
