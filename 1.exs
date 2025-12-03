defmodule Go do
  @reset 0
  @start 50
  @num_pos 100

  # Part 1
  def go1() do
    goo1(parse_file!(), @start, 0)
  end

  def goo1([], _, acc), do: acc
  def goo1([rot | next], pos, acc) do
    new_pos = rotate(pos, rot)
    goo1(next, new_pos, incr_acc(acc, new_pos))
  end

  def incr_acc(acc, @reset), do: acc + 1
  def incr_acc(acc, _), do: acc

  # Part 2
  def go2() do
    goo2(parse_file!(), @start, 0)
  end

  def goo2([], _, acc), do: acc
  def goo2([rot | next], pos, acc) do
    is_going_left = rot < 0

    # steps_away: number of steps away from the first click
    steps_away =
      cond do
        pos == @reset -> @num_pos
        is_going_left -> pos
        true -> @num_pos - pos
      end

    num_clicks = if abs(rot) < steps_away, do: 0, else: 1 + div(abs(rot) - steps_away, @num_pos)
    goo2(next, rotate(pos, rot), acc + num_clicks)
  end

  # Shared
  def rotate(pos, rot) do
    Integer.mod(pos + rot, @num_pos)
  end

  def parse_file!() do
    "inputs/1.txt"
    |> File.read!()
    |> String.split()
    |> Enum.map(&parse!/1)
  end

  @spec parse!(String.t()) :: integer()
  def parse!(s) do
    case String.split_at(s, 1) do
      {"L", num_str} ->
        -1 * String.to_integer(num_str)
      {"R", num_str} ->
        String.to_integer(num_str)
      _ -> raise "Failed to parse."
    end
  end
end

IO.puts(Go.go1())
IO.puts(Go.go2())
