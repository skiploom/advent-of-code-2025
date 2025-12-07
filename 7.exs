defmodule Go do
  @start "S"
  @splitter "^"

  def go1() do
    parse_file!()
    |> pew()
    |> count_splits()
  end

  def pew(grid) do
    down([grid.start], 0, grid)
  end

  def down(_, ym, %{ym: ym} = acc), do: acc

  def down(row_beams, y, acc) do
    next = check(row_beams, acc.splitters, MapSet.new())
    down(MapSet.to_list(next), y + 1, Map.update!(acc, :beams, &MapSet.union(&1, next)))
  end

  def check([], _, acc), do: acc

  def check([{bx, by} | rest], splitters, acc) do
    below = {bx, by + 1}

    new_beams =
      if MapSet.member?(splitters, below) do
        MapSet.union(acc, MapSet.new(split(below)))
      else
        MapSet.put(acc, below)
      end

    check(rest, splitters, new_beams)
  end

  def split({x, y}), do: [{x - 1, y}, {x + 1, y}]

  def count_splits(%{splitters: splitters, beams: beams}) do
    count(MapSet.to_list(splitters), beams, 0)
  end

  def count([], _, acc), do: acc

  def count([{x, y} | rest], beams, acc) do
    # Just realized I could've done this count way earlier when splitting the beams. Ah well.
    count(rest, beams, if(MapSet.member?(beams, {x, y - 1}), do: acc + 1, else: acc))
  end

  def parse_file!() do
    "inputs/7.txt"
    |> File.read!()
    |> String.split()
    |> Enum.map(&String.graphemes/1)
    |> grid!(0, %{start: nil, beams: MapSet.new(), splitters: MapSet.new(), xm: nil, ym: nil})
  end

  def grid!([], ym, acc), do: Map.put(acc, :ym, ym)
  def grid!([c | rest], y, acc), do: grid!(rest, y + 1, row!(c, {0, y}, acc))

  def row!([], {xm, _}, %{xm: nil} = acc), do: Map.put(acc, :xm, xm)
  def row!([], _, acc), do: acc

  def row!([c | rest], {x, y}, acc) do
    case c do
      @start -> row!(rest, {x + 1, y}, Map.put(acc, :start, {x, y}))
      @splitter -> row!(rest, {x + 1, y}, Map.update!(acc, :splitters, &MapSet.put(&1, {x, y})))
      _ -> row!(rest, {x + 1, y}, acc)
    end
  end
end

IO.puts(Go.go1())
