defmodule BinaryTreeTest do
  use ExUnit.Case
  alias DataStructures.BinaryTree, as: BT

  describe "new/1" do
    test "new will create a new BinaryTree node with no children" do
      assert BT.new(1) == %BT{value: 1, left: nil, right: nil}
    end
  end

  describe "add/2" do
    test "add will place an element that is less than the current node to the left" do
      assert BT.add_node(BT.new(1), 0) == %BT{value: 1, left: BT.new(0), right: nil}
    end

    test "add will place an element that is greater than the current node to the right" do
      assert BT.add_node(BT.new(1), 2) == %BT{value: 1, right: BT.new(2), left: nil}
    end

    test "add will not add a duplicate value to a tree" do
      assert BT.add_node(BT.new(3), 3) == BT.new(3)
    end

    test "add will recursively insert recursively to the right" do
      tree = BT.new(2) |> BT.add_node(3) |> BT.add_node(4)
      assert tree == %BT{value: 2, left: nil, right: %BT{value: 3, right: BT.new(4), left: nil}}
    end

    test "add will recursively insert recursively to the left" do
      tree = BT.new(4) |> BT.add_node(3) |> BT.add_node(2)
      assert tree == %BT{value: 4, right: nil, left: %BT{value: 3, left: BT.new(2), right: nil}}
    end
  end

  describe "value_in_tree?/2" do
    test "will return true for values that are in the tree" do
      assert Enum.map(1..10, fn _ -> Enum.shuffle(1..10) end)
             |> Enum.map(&BT.tree_from_list/1)
             |> Enum.map(&BT.value_in_tree?(&1, Enum.random(1..10)))
             |> Enum.all?()
    end

    test "will return false for values that are not in the tree" do
      refute Enum.map(1..10, fn _ -> Enum.shuffle(1..10) end)
             |> Enum.map(&BT.tree_from_list/1)
             |> Enum.map(&BT.value_in_tree?(&1, Enum.random(11..21)))
             |> Enum.all?()
    end
  end

  # don't think much testing is needed her as we have already tested add thoroughly and the implmenation of 
  # tree_from_list is just repeated add calls.
  describe "tree_from_list/1" do
    test "will create a basic tree from a list" do
      assert BT.tree_from_list([1, 2, 0, 4]) == %BT{
               value: 1,
               right: %BT{value: 2, left: nil, right: BT.new(4)},
               left: BT.new(0)
             }
    end
  end
end
