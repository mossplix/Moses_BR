defmodule BrApp.ReactionTest do
    @moduledoc """
    Test the validation rules of the Reaction request struct
    """
    use ExUnit.Case, async: true
    alias BrApp.Reaction
    @expected_attrs %{
        action: "remove",
        content_id: "7488a646-e31f-11e4-aace-6003088",
        reaction_type: "fire",
        type: "reaction",
        user_id: "7488a646-e31f-11e4-aace-600308960662"
      }
      @unexpected_attrs %{action: "reacgt", content_id: nil, reaction_type: nil, type: nil, user_id: nil}
      @valid_params %{"action" => "remove", "content_id" => "id3","reaction_type" => "fire","type" => "reaction", "user_id" => "random id"}
      @invalid_params %{ "content_id" => "id3","reaction_type" => "fire","type" => "reaction"}


      describe "Test Reaction Request Params Struct" do
        test "Test creation from valid map" do
          {:ok,reaction_struct}=Reaction.from_map(@valid_params)
          assert reaction_struct.content_id == @valid_params["content_id"]
        end

        test "Test creation from invalid  map" do
            {:error,reaction_struct}=Reaction.from_map(@invalid_params)
            assert reaction_struct == {}
            
          end

          test "Test invalid when empty" do
             assert Reaction.valid?(%Reaction{}) == false 
          end

          test "Test invalid is has wrong values" do
            assert Reaction.valid?(@unexpected_attrs) == false 
          end

          test "Test is valid is attrs are valid" do
            assert Reaction.valid?( @expected_attrs) == true
          end
      end

end