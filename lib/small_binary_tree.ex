defmodule DataStructures.SmallBinaryTree do
  @typedoc """
  Represents a tree as as tuple with the first element being the left 
  child, the middle being the value, and the last being the right child.
  """
  @type t :: {t | nil, term, t | nil}
  @lookup %{
    left: 0,
    right: 2,
    value: 1
  }
  @doc """
  Convenience function for creating a new tree node
  """
  @spec new(term) :: t
  def new(val), do: {nil, val, nil}
  
  @doc """
  Convenience function for getting a child from a node
  """
  @spec get_child(t, :left | :right) :: t
  def get_child(tree, :left) do
    elem(tree, @lookup[:left])
  end

  def get_child(tree, :right) do
    elem(tree, @lookup[:right])
  end

  @doc """
  Convenience function for setting a child on a node
  """
  @spec set_child(t, term, :left | :right) :: t
  def set_child(tree, val, :left) do
    put_elem(tree, @lookup[:left], val)
  end

  def set_child(tree, val, :right) do
    put_elem(tree, @lookup[:right], val)
  end
  
  @doc """
  This implements the add function that is described in 
  problems 2.3 and 2.4.

  Since tuples are shallow copied for updates we should 
  end up with the desired memory profile here unlike the 
  implmentation based on structs in DataStructures.BinaryTree
  """
  @spec add(t, term) :: t
  def add(tree, new_val) do
    try do
      add(tree, new_val, [])
    rescue
      e in RuntimeError ->
        case e.message do
          :duplicate -> tree
          path -> deep_tree_update(tree, path, new_val)
        end
    end
  end

  # base cases
  defp add(nil, _new_val, path) do
    raise RuntimeError, message: Enum.reverse(path)
  end

  defp add({_, val, _}, val, _path) do
    raise RuntimeError, message: :duplicate
  end
  
  # recursive cases
  defp add({left, val, _}, new_val, path) when new_val < val do
    add(left, new_val, [:left | path])
  end

  defp add({_, _, right}, new_val, path) do
    add(right, new_val, [:right | path])
  end
  
  @doc """
  Checks whether a value is a member of the tree.
  """
  def member?(tree, val) do
    member?(tree, val, nil) == val
  end

  def member?(nil, _val, candidate), do: candidate

  def member?({left, node_val, right}, val, candidate) do
    if val < node_val do
      member?(left, val, candidate)
    else
      member?(right, val, node_val)
    end
  end
  
  @doc """
  Convenience function for creating a tree from a list.
  The list elements must be comparable!
  """
  @spec tree_from_list(list) :: t
  def tree_from_list([]), do: new(nil)
  def tree_from_list([head]), do: new(head)
  def tree_from_list([head|rest]) do
    Enum.reduce(rest, new(head), &add(&2, &1)) 
  end

  #This function allows us to perform a deep tree update if we have a path to the node
  #that needs to be updated.  Since updates to tuples are shallow we should only create 
  #one truly new value in memory.
  defp deep_tree_update(tree, [final], value), do: set_child(tree, new(value), final)

  defp deep_tree_update(tree, [next | path], value) do
    set_child(tree, deep_tree_update(get_child(tree, next), path, value), next)
  end
end
