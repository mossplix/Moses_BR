defmodule BrApp.Reaction do
    @moduledoc """
    The struct provising infoermation about the reaction request
    """

 
    @type t :: %BrApp.Reaction{}
    @derive Jason.Encoder
    defstruct  type: nil, action: nil, content_id:  nil,user_id:  nil, reaction_type:  nil

   
    defp valid_action?(action) do
        action in ["add","remove"]
    end

   
    defp valid_reaction_type?(reaction_type) do
        reaction_type in ["fire"]
    end

    defp valid_type?(type) do
        type in ["reaction"]
    end


      @doc """
         Validate that all the request params are valid
      """
    def valid?(reaction) do
        case is_map(reaction) do  
        true -> !!(reaction.type && reaction.action && reaction.content_id && reaction.user_id && reaction.reaction_type) && valid_action?(reaction.action) && valid_reaction_type?(reaction.reaction_type) && valid_type?(reaction.type)
        false -> false
        end
    end

    @doc """
       helper function to Create the struct from a map
    """
    def from_map(map) when is_map(map) do
        try do
          reaction = %BrApp.Reaction{
            type: Map.fetch!(map, "type"),
            action: Map.fetch!(map,"action"), 
            content_id: Map.fetch!(map,"content_id"),
            user_id: Map.fetch!(map,"user_id"), 
            reaction_type: Map.fetch!(map,"reaction_type")
          }

          case valid?(reaction) do
            true -> {:ok,reaction}
            false -> {:error,{}}
        end

        rescue
          _ in [KeyError] ->
            {:error,{}}
        end
      end



end