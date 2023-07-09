defmodule DataStructures.Exercises.Chapter2 do
  @moduledoc """
  Worked exercises for Chapter 2
  """

  @doc """
  # Problem
  Given a list, return the suffixes of the list in decreasing order.
  Show that the function operates in O(n) time and O(n) space.

  ## Discussion 
  Clearly the algorithm below operates in O(n) time as it traverses
  a singly linked list which is an O(n) operation.

  O(n) space is used because the Elixir runtime will not create full 
  copies of the list. Instead each prefix is a single element that  
  points to its next position in the original list which remains 
  unchanged in memory.
  [diagram](https://excalidraw.com/#json=enUvaY1C2B3U10pOpfY5y,cCgtjTm35ZFD9QgpIRyA1w)
  """
  def prefixes([]), do: [] 
  def prefixes([_head | rest] = prefix) do
    [prefix | prefixes(rest)]
  end
end
