defmodule BrApp.ETSGenserver do
  @moduledoc """
  Genserver to deal with async insertions into ETS as well as the garbage 
  collection of the tables.
  """
  use GenServer

  @user_reactions :reactions
  @content_counts :reaction_counts

  @genserver_name REAC

  # External API

  @doc """
     Use a named genserver that will be shared across all nodes
  """
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts ++ [name: @genserver_name])
  end

  
  def add_reaction(reaction) do
    GenServer.cast(@genserver_name, {:add, reaction})
  end

  def remove_reaction(reaction) do
    GenServer.cast(@genserver_name, {:remove, reaction})
  end

  @doc """
  Looks up the number of fires of the content_d`.
  Returns `{:ok, number_of_fires}` if the content_id exists, `:error` otherwise.
  use update counter to keep the read concurrency up
  """
  def search_reaction(content_id) do
    fires = :ets.update_counter(@content_counts, content_id, 0)
    {:ok, fires}
  rescue
    _ -> {:error}
  end

  @doc """
     Search that the user, content_id exists already in the ETS table. 
  """
  def search_user_reaction(reaction) do
    user_reaction =
      :ets.lookup_element(@user_reactions, {reaction.user_id, reaction.content_id}, 1)

    {:ok, user_reaction}
  rescue
    _ -> {:error}
  end

  def increment_content_id_counter(content_id) do
    :ets.update_counter(@content_counts, content_id, 1)
  rescue
    _ -> :ets.insert(@content_counts, {content_id, 1})
  end

  def decrement_content_id_counter(content_id) do
    with count when count > 1 <- search_reaction(content_id) do
      :ets.update_counter(@content_counts, content_id, -1)
    end
  end

  @doc """
     try and insert the user and reaction in the cache. If they dont exist, update the fire counter
  """
  def add_to_cache(reaction) do
    created =
      :ets.insert_new(@user_reactions, {{reaction.user_id, reaction.content_id}, reaction})

    case created do
      true -> increment_content_id_counter(reaction.content_id)
      _ -> nil
    end
  end

    @doc """
      remove reaction from cache
      The caller for this function checks that the `content_id` exists in the ETS table
  """
  def remove_from_cache(reaction) do
    decrement_content_id_counter(reaction.content_id)
    :ets.delete(@user_reactions, {reaction.user_id, reaction.content_id})
  end

  #######################
  # Genserver implementation
  ##################

  @doc """
   Initialize the genserver. We assume the writes to the ets tables will be infgrequent,
   hence we optimize for read_concurrency.
   We use one 
  """
  @impl true
  def init(_) do
    :ets.new(@user_reactions, [:set, :public, :named_table, read_concurrency: true])
    :ets.new(@content_counts, [:set, :public, :named_table, read_concurrency: true])
    {:ok, nil}
  end

  @impl true
  def handle_cast({action, reaction}, _) do
    case action do
      :add -> {:noreply, add_to_cache(reaction)}
      :remove -> {:noreply, remove_from_cache(reaction)}
      _ -> {:noreply, nil}
    end
  end

  @impl true
  def handle_info(_msg, state) do
    {:noreply, state}
  end
end
