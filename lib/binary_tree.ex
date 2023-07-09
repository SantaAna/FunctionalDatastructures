defmodule DataStructures.BinaryTree do
  defstruct [:value, left: nil, right: nil]

  @moduledoc """
  Represents a binary tree datastructure.
  ## Performance
  If the binary tree is balanced, we should expect to be able to add and find 
  elements in O(log(n)) time.  Performance will tend towards linear the more 
  inbalanced the tree becomes.
  """

  @type t :: %__MODULE__{
          value: term,
          left: t | nil,
          right: t | nil
        }

  @spec new(term) :: t
  def new(val), do: %__MODULE__{value: val, left: nil, right: nil}

  # base cases for adding a node.  I've chosen to skip over any attempt to add a new node
  # with the same value as a node already in the tree

  @spec add_node(t, term) :: t
  def add_node(%__MODULE__{value: val, left: nil} = current, new_val) when new_val < val do
    Map.put(current, :left, new(new_val))
  end

  def add_node(%__MODULE__{value: val, right: nil} = current, new_val) when new_val > val do
    Map.put(current, :right, new(new_val))
  end

  def add_node(%__MODULE__{value: val} = current, new_val) when new_val == val, do: current

  # recursive cases
  def add_node(%__MODULE__{value: val, left: left} = current, new_val) when new_val < val do
    Map.put(current, :left, add_node(left, new_val))
  end

  def add_node(%__MODULE__{value: val, right: right} = current, new_val) when new_val > val do
    Map.put(current, :right, add_node(right, new_val))
  end

  @doc """
  Exercise 2.3 & 2.4 in the book.

  Here we keep an accumulator that tracks our path to where the new value should be inserted
  and raise an exception once we have reached a nil tree value.  The trace is returned back 
  up to the calling function via a RuntimeError (this is generally a bad idea, but here we 
  are specifically trying to save memory over all else) and is then used to update the tree 
  via Kernel.put_in/3.  This version hinges on put_in being more memory efficient than copying
  a path down to the leaf where we insert the node as with add_node.

  To redcue the number of comparisons we take the right branch as soon as we know that we aren't
  taking the left branch instead of making a check to see if the new_value is less than the current 
  node value.

  """
  @spec add_node_with_exception(t, term) :: t
  def add_node_with_exception(tree, new_val) do
    try do
      add_node_with_exception(tree, new_val, [])
    rescue
      e in RuntimeError ->
        case e.message do
          :duplicate ->
            tree

          trace ->
            put_in(tree, trace, new(new_val))
        end
    end
  end

  defp add_node_with_exception(nil, _new_val, trace) do
    raise RuntimeError, message: Enum.reverse(trace)
  end

  defp add_node_with_exception(%__MODULE__{value: val}, val, _trace) do
    raise RuntimeError, message: :duplicate
  end

  defp add_node_with_exception(%__MODULE__{value: val, left: left}, new_val, trace)
       when new_val < val do
    add_node_with_exception(left, new_val, [Access.key(:left) | trace])
  end

  defp add_node_with_exception(%__MODULE__{right: right}, new_val, trace) do
    add_node_with_exception(right, new_val, [Access.key(:right) | trace])
  end

  # base cases
  @spec value_in_tree?(t, term) :: boolean
  def value_in_tree?(%__MODULE__{value: val}, tar) when val == tar, do: true
  def value_in_tree?(nil, _tar), do: false

  # recursive cases
  def value_in_tree?(%__MODULE__{value: val, left: left}, tar) when tar < val do
    value_in_tree?(left, tar)
  end

  def value_in_tree?(%__MODULE__{value: val, right: right}, tar) when tar > val do
    value_in_tree?(right, tar)
  end

  @doc """
  Exercise 2.2 in the book.  We are aksed to make a version of search where we perform
  at most d + 1 comaprisons where d is the depth of the binary tree.

  By recording candidates for the match as we traverse the tree and only making a comparsion
  at the end we ensure that the algorithm always makes d + 1 comparisons, but it will now
  perform worse in the average case.
  """
  @spec lazy_value_in_tree?(t, term, term) :: boolean
  def lazy_value_in_tree?(tree, tar, candidate \\ nil)
  def lazy_value_in_tree?(nil, tar, candidate), do: tar == candidate

  def lazy_value_in_tree?(%__MODULE__{value: val, left: left, right: right}, tar, candidate) do
    # if the value is greater than the target then it is not a candidate.
    if tar < val do
      lazy_value_in_tree?(left, tar, candidate)
    else
      # in this case the val is <= the tar so it is a canddiate.
      lazy_value_in_tree?(right, tar, val)
    end
  end

  @doc """
  Creates a new binary tree from a list.
  ## Gotchas
  - List elements must be comparable!
  - If list elements are sorted you will end up with an unbalanced tree. 
  """
  @spec tree_from_list(list) :: t
  def tree_from_list([head | rest]) do
    Enum.reduce(rest, new(head), &add_node(&2, &1))
  end
end
