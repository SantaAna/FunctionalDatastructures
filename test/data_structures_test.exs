defmodule DataStructuresTest do
  use ExUnit.Case
  alias DataStructures.{NaiveDoubleQueue, FastDoubleQueue}

  describe "Naive implementation of double queue" do
    test "can peak at front" do
      list = [1, 2, 3]
      assert NaiveDoubleQueue.get_front(list) == 1
    end

    test "can peak at back" do
      list = [1, 2, 3]
      assert NaiveDoubleQueue.get_back(list) == 3
    end

    test "can insert at back" do
      list = [1, 2, 3]
      assert NaiveDoubleQueue.add_back(list, 4) == [1, 2, 3, 4]
    end

    test "can insert at front" do
      list = [1, 2, 3]
      assert NaiveDoubleQueue.add_front(list, 0) == [0, 1, 2, 3]
    end
  end

  describe "Fast implementation of double queue" do

    test "pops from empty queue return nil" do
      queue = FastDoubleQueue.new([])       
      assert FastDoubleQueue.pop_front(queue) == {nil, {[], []}}
      assert FastDoubleQueue.pop_back(queue) == {nil, {[], []}}
    end

    test "can pop at front" do
      queue = FastDoubleQueue.new([1, 2, 3])
      assert FastDoubleQueue.pop_front(queue) == {1, {[2,3], []}}

      queue = {[], [5,4,3]}
      assert FastDoubleQueue.pop_front(queue) == {3, {[4],[5]}}
    end

    test "can pop at back" do
      queue = FastDoubleQueue.new([1, 2, 3])
      assert FastDoubleQueue.pop_back(queue) == {3, {[1], [2]}}
    end

    test "can push at back" do
      queue = FastDoubleQueue.new([1, 2, 3])
      assert FastDoubleQueue.push_back(queue, 4) == {[1, 2, 3], [4]}
    end

    test "can push at front" do
      queue = FastDoubleQueue.new([1, 2, 3])
      assert FastDoubleQueue.push_front(queue, 0) == {[0, 1, 2, 3], []}
    end
  end
end
