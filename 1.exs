defmodule P1 do
  @reset 0
  @start 50
  @num_pos 100

  def go() do
    rots =
      "inputs/1.txt"
      |> File.read!()
      |> String.split()
      |> Enum.map(&parse!/1)

    goo(rots, @start, 0)
  end

  def goo([], _, acc), do: acc
  def goo([rot | next], pos, acc) do
    new_pos = rotate(pos, rot)
    goo(next, new_pos, incr_acc(acc, new_pos))
  end

  def rotate(pos, rot) do
    Integer.mod(pos + rot, @num_pos)
  end

  def incr_acc(acc, @reset), do: acc + 1
  def incr_acc(acc, _), do: acc

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

IO.puts(P1.go())
