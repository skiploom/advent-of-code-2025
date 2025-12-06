defmodule Go do
  def go1() do
    %{ranges: ranges, ingredients: ingredients} = parse_file!()
    Enum.count(ingredients, &fresh?(ranges, &1))
  end

  def fresh?([], _), do: false
  def fresh?([{x1, x2} | _], id) when id >= x1 and id <= x2, do: true
  def fresh?([_ | next], id), do: fresh?(next, id)

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
