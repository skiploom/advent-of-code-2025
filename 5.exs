defmodule Go do
  # Part 1
  def go1() do
    %{ranges: ranges, ingredients: ingredients} = parse_file!()
    Enum.count(ingredients, &fresh?(ranges, &1))
  end

  def fresh?([], _), do: false
  def fresh?([{x1, x2} | _], id) when id >= x1 and id <= x2, do: true
  def fresh?([_ | next], id), do: fresh?(next, id)

  # Part 2
  def go2() do
    %{ranges: ranges} = parse_file!()
    Enum.sum_by(loop(ranges, []), fn {x, y} -> y - x + 1 end)
  end

  def loop([], acc), do: re_dedup(acc)

  def loop([curr | next], acc) do
    loop(next, dedup(curr, [], acc))
  end

  def dedup(curr, done, []), do: [curr | done]

  def dedup({x, y}, done, [{a, b} | next]) do
    case maybe_join({x, y}, {a, b}) do
      {new_x, new_y} -> [{new_x, new_y} | done] ++ next
      :disjoint -> dedup({x, y}, [{a, b} | done], next)
    end
  end

  def maybe_join({x, y}, {a, b}) do
    cond do
      # Subsume range
      x <= a and b <= y -> {x, y}
      # Extend range's right
      a <= x and x <= b and b < y -> {a, y}
      # Extend range's left
      x < a and a <= y and y <= b -> {x, b}
      # Range is subsumed
      (a <= x and x <= b) or (a <= y and y <= b) -> {a, b}
      # Range is disjoint, don't join
      true -> :disjoint
    end
  end

  # Do a final de-dupe pass. Might need to join some ranges, since the initial de-dupes stopped
  # at the first interesting action
  def re_dedup(rs) do
    [curr | next] = Enum.sort(rs)
    foo(curr, next, [])
  end

  def foo(curr, [last], done) do
    case maybe_join(curr, last) do
      {new_x, new_y} -> [{new_x, new_y} | done]
      :disjoint -> [curr | [last | done]]
    end
  end

  def foo(curr, [next | rest], done) do
    case maybe_join(curr, next) do
      # Combined, so re-compare
      {new_x, new_y} -> foo({new_x, new_y}, rest, done)
      # Didn't combine, move along move along just to make it through
      :disjoint -> foo(next, rest, [curr | done])
    end
  end

  # Shared
  def parse_file!() do
    lines =
      "inputs/5.txt"
      |> File.read!()
      |> String.split()

    i_first_id =
      Enum.find_index(lines, &(!String.contains?(&1, "-")))

    {range_strs, ingredient_strs} = Enum.split(lines, i_first_id)

    ranges =
      Enum.map(range_strs, fn s ->
        [x1, x2] = String.split(s, "-")
        {String.to_integer(x1), String.to_integer(x2)}
      end)

    ingredients = Enum.map(ingredient_strs, &String.to_integer/1)

    %{ranges: ranges, ingredients: ingredients}
  end
end

IO.puts(Go.go1())
IO.puts(Go.go2())
