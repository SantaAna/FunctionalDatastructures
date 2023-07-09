defmodule Chapter2Test do
  use ExUnit.Case
  alias DataStructures.Exercises.Chapter2, as: C2

  describe "prefixes/1" do
    test "produces prefixes in right order for non-empty list" do
      assert C2.prefixes([1, 2, 3]) == [[1, 2, 3], [2, 3], [3]]
    end

    test "produces emtpy list when given empty list" do
      assert C2.prefixes([]) == []
    end
  end
end
