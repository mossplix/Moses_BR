defmodule BrApp.ETSGenserverTest do

    alias BrApp.ETSGenserver
    use ExUnit.Case, async: false
   
    alias BrApp.Reaction 
    @reaction1 %Reaction{
        action: "add",
        content_id: "7488a646-e31f-11e4-aace-6003088_g",
        reaction_type: "fire",
        type: "reaction",
        user_id: "7488a646-e31f-11e4-aace-_g"
      }
      @reaction2 %Reaction{
        action: "remove",
        content_id: "7488a646-e31f-11e4-aace-6003088_g",
        reaction_type: "fire",
        type: "reaction",
        user_id: "7488a646-e31f-11e4-aace-_g"
      }

      @reaction3 %Reaction{
        action: "add",
        content_id: "7488a646-e31f-11e4-aace-6003088_g",
        reaction_type: "fire",
        type: "reaction",
        user_id: "7488a646-e31f-11e4-aace-_gdh"
      }
      @reaction4 %Reaction{
        action: "add",
        content_id: "7488a646-e31f-11e4-aace-6003088_g",
        reaction_type: "fire",
        type: "reaction",
        user_id: "7488a646-e31f-11e4-aace-_gdhnn"
      }
  


      test "querying existing reactions returns the correct number of fires", context do
        assert ETSGenserver.add_reaction(@reaction1) == :ok
        assert ETSGenserver.add_reaction(@reaction1) == :ok
        assert ETSGenserver.add_reaction(@reaction1) == :ok
        assert ETSGenserver.add_reaction(@reaction3) == :ok
        assert ETSGenserver.add_reaction(@reaction3) == :ok
        Process.sleep(500) # we need to guarantee that the insert has completed
        assert ETSGenserver.search_reaction(@reaction1.content_id) == {:ok, 2}
      end

     
      test "querying none existing reactions returns :error", context do
        assert ETSGenserver.search_reaction("foo") == {:error}
      end

      test "search_user_reaction functionality for existing user" do
        assert ETSGenserver.add_reaction(@reaction1) == :ok
        Process.sleep(500) # we need to guarantee that the insert has completed
        assert {:ok, {@reaction1.user_id,@reaction1.content_id}} ==ETSGenserver.search_user_reaction(@reaction1)

      end

end