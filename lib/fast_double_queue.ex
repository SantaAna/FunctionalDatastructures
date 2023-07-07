defmodule DataStructures.FastDoubleQueue do

  @type t :: {list, list}
  
  def new(list) do
    {list, []}
  end
 
  @spec push_back(t, term) :: t
  def push_back({forward, backward}, element) do
    {forward, [element | backward]}
  end

  @spec push_front(t, term) :: t
  def push_front({forward, backward}, element) do
    {[element | forward], backward}  
  end
  
  @spec pop_front(t) :: {term, t}
  def pop_front(queue, default \\ nil)
  #if the queue is empty return the default value and queue
  def pop_front({[], []} = queue, default) do
    {default, queue}  
  end
  #if there is only a single element in the end, return it and empty queue.
  def pop_front({[], [single | []]}, _default) do
    {single, {[], []}}
  end
  #if the front queue is empty, split the back and perfrom reverse and then
  #recursive call
  def pop_front({[], backward}, default) do
    {back, front} = split_list(backward) 
    pop_front({Enum.reverse(front), back}, default)
  end
  #happy path, return the head of the forward list.
  def pop_front({[head | rest], backward}, _default) do 
    {head, {rest, backward}} 
  end

  
  @spec pop_back(t) :: {term , t}
  def pop_back(queue, default \\ nil)
  def pop_back({[], []} = queue, default) do
    {default, queue}
  end
  def pop_back({[single | []], []}, _default) do
    {single, {[], []}}
  end
  def pop_back({forward, []}, default) do
    {front , back} = split_list(forward)
    pop_back({front, Enum.reverse(back)}, default)
  end
  def pop_back({forward, [last | rest]}, _default) do
    {last, {forward, rest}}
  end
  
  def split_list([]), do: [[],[]]
  def split_list(list) do
    length = Enum.count(list)
    Enum.split(list, div(length, 2))
  end

end
