defmodule DataStructures.NaiveDoubleQueue do
  
  def add_back(list, element) do
    rev = Enum.reverse(list)
    [element | rev] |> Enum.reverse()
  end

  def add_front(list, element) do
    [element | list]  
  end

  def get_front([head | _rest]) do 
    head 
  end

  def get_back(list) do
    Enum.reverse(list)
    |> hd()
  end
end
