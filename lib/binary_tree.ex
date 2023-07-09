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

  # base cases
  @spec value_in_tree?(t, term) :: boolean
  def value_in_tree?(%__MODULE__{value: val}, tar) when val == tar, do: true
  def value_in_tree?(nil, _tar), do: false

  def value_in_tree?(%__MODULE__{value: val, left: left}, tar) when tar < val do
    value_in_tree?(left, tar)
  end

  def value_in_tree?(%__MODULE__{value: val, right: right}, tar) when tar > val do
    value_in_tree?(right, tar)
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
