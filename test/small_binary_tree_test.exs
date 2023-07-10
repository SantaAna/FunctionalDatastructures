defmodule SmallBinaryTreeTest do
  use ExUnit.Case
  alias DataStructures.SmallBinaryTree, as: SBT

  describe "new/1" do
    test "new will create a new BinaryTree node with no children" do
      assert SBT.new(1) == {nil, 1, nil}
    end
  end

  describe "add/2" do
    test "add will place an element that is less than the current node to the left" do
      assert SBT.add(SBT.new(1), 0) == {SBT.new(0), 1, nil}
    end

    test "add will place an element that is greater than the current node to the right" do
      assert SBT.add(SBT.new(1), 2) == {nil, 1, SBT.new(2)}
    end

    test "add will not add a duplicate value to a tree" do
      assert SBT.add(SBT.new(3), 3) == {nil, 3, nil}
    end

    test "add will insert recursively to the right" do
      tree = SBT.new(2) |> SBT.add(3) |> SBT.add(4)
      assert tree == {nil, 2, {nil, 3, {nil, 4, nil}}}
    end

    test "add will insert recursively to the left" do
      tree = SBT.new(4) |> SBT.add(3) |> SBT.add(2)
      assert tree == {{{nil, 2, nil}, 3, nil}, 4, nil}
    end
  end

  describe "member?/2" do
    test "will return true for values that are in the tree" do
      assert Enum.map(1..10, fn _ -> Enum.shuffle(1..10) end)
             |> Enum.map(&SBT.tree_from_list/1)
             |> Enum.map(&SBT.member?(&1, Enum.random(1..10)))
             |> Enum.all?()
    end

    test "will return false for values that are not in the tree" do
      refute Enum.map(1..10, fn _ -> Enum.shuffle(1..10) end)
             |> Enum.map(&SBT.tree_from_list/1)
             |> Enum.map(&SBT.member?(&1, Enum.random(11..21)))
             |> Enum.all?()
    end
  end

  # don't think much testing is needed her as we have already tested add thoroughly and the implmenation of 
  # tree_from_list is just repeated add calls.
  describe "tree_from_list/1" do
    test "will create a basic tree from a list" do
      assert SBT.tree_from_list([1, 2, 0, 4]) == {{nil, 0, nil}, 1, {nil, 2, {nil, 4, nil}}}
    end
  end
end
