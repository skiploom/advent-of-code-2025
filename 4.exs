defmodule Go do
  @type coord() :: {x :: non_neg_integer(), y :: non_neg_integer()}
  @type grid() :: %{coord() => is_roll :: boolean()}
  @type bounds() :: %{x0: non_neg_integer(), xm: non_neg_integer(), y0: non_neg_integer(), y1: non_neg_integer()}

  # Part 1
  def go1() do
    grid = parse_file!()
    bounds = get_bounds(grid)
    fork(grid, bounds)
  end

  def fork(grid, bounds) do
    bounds.y0..bounds.ym
    |> Enum.map(fn y -> fork_x?(grid, bounds, bounds.x0, y, []) end)
    |> List.flatten()
    |> Enum.count(&(&1))
  end

  def fork_x?(_, %{xm: xm}, x, _, acc) when x == xm + 1, do: acc
  def fork_x?(grid, bounds, x, y, acc) do
    fork_x?(grid, bounds, x + 1, y, [fork_at?(x, y, grid) | acc])
  end

  # Part 2
  def go2() do
    grid = parse_file!()
    bounds = get_bounds(grid)
    fortnite(grid, bounds, 0)
  end

  # Count forky-workys, clean 'em up, then do it all over again
  def fortnite(grid, bounds, total_forks) do
    coords = find_forks(grid, bounds)
    num_forks = MapSet.size(coords)

    if num_forks > 0 do
      cleaned =
        Enum.reduce(MapSet.to_list(coords), grid, fn coord, acc ->
          Map.put(acc, coord, false)
        end)

      fortnite(cleaned, bounds, total_forks + num_forks)
    else
      total_forks
    end
  end

  @spec find_forks(grid(), bounds()) :: MapSet.t(coord())
  def find_forks(grid, bounds) do
    Enum.reduce(bounds.y0..bounds.ym, MapSet.new(), fn y, acc ->
      MapSet.union(acc, find_forks_x(grid, bounds, bounds.x0, y, MapSet.new()))
    end)
  end

  def find_forks_x(_, %{xm: xm}, x, _, acc) when x == xm + 1, do: acc
  def find_forks_x(grid, bounds, x, y, acc) do
    new_acc = if fork_at?(x, y, grid), do: MapSet.put(acc, {x,y}), else: acc
    find_forks_x(grid, bounds, x + 1, y, new_acc)
  end

  # Shared
  def fork_at?(x, y, grid) do
    # If I really wanted to be efficient, I could store 0s and 1s in the grid where
    # 1 denotes a roll. Then instead of building up a list and counting here,
    # I could just add the surrounding coordinate values and check if that's less than 4,
    # which would save an iteration. Ah well.
    if peek({x,y}, grid) do
      [{x-1,y-1}, {x,y-1}, {x+1,y-1}, {x-1,y}, {x+1,y}, {x-1,y+1}, {x,y+1}, {x+1,y+1}]
      |> Enum.map(&peek(&1, grid))
      |> Enum.count(&(&1))
      |> then(&(&1 < 4))
    else
      false
    end
  end

  def peek(coord, grid), do: Map.get(grid, coord, false)

  def get_bounds(grid) do
    {xs, ys} = Enum.unzip(Map.keys(grid))
    %{x0: Enum.min(xs), xm: Enum.max(xs), y0: Enum.min(ys), ym: Enum.max(ys)}
  end

  def parse_file!() do
    "inputs/4.txt"
    |> File.read!()
    |> String.split()
    |> parse_ls(0, %{})
  end

  @spec parse_ls(lines :: list(String.t()), y :: non_neg_integer(), grid()) :: grid()
  def parse_ls([], _, acc), do: acc
  def parse_ls([curr | next], y, acc) do
    parse_ls(next, y + 1, Map.merge(acc, parse_l(String.graphemes(curr), 0, y, %{})))
  end

  def parse_l([], _, _, acc), do: acc
  def parse_l([curr | next], x, y, acc) do
    parse_l(next, x + 1, y, Map.put(acc, {x,y}, roll?(curr)))
  end

  def roll?(char), do: char == "@"
end

IO.puts(Go.go1())
IO.puts(Go.go2())
