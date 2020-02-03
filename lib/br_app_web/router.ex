defmodule BrAppWeb.Router do
  use BrAppWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BrAppWeb do
    pipe_through :api
    post "/reaction", ReactionController, :update_reaction
    get "/reaction_counts/:content_id", ReactionController, :get_reactions
  end

end
