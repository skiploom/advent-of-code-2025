defmodule Go do
  def go1() do
    parse_file!()
    |> Enum.map(&jolt/1)
    |> Enum.sum()
  end

  def jolt(bank) do
    {j1, i} = find_1st(bank, 0, 0, 0)
    j2 = find_2nd(Enum.drop(bank, 1 + i), 0)
    j1 * 10 + j2
  end

  # The last bank digit can't be the first joltage digit
  def find_1st([_last], largest, largest_i, _), do: {largest, largest_i}
  # If the current digit is equal our known largest, ignore it (as it may be a good second joltage digit)
  def find_1st([curr | next], largest, _, i) when curr > largest, do: find_1st(next, curr, i, i + 1)
  def find_1st([_curr | next], largest, largest_i, i), do: find_1st(next, largest, largest_i, i + 1)

  def find_2nd([], largest), do: largest
  def find_2nd([curr | next], largest) when curr > largest, do: find_2nd(next, curr)
  def find_2nd([_curr | next], largest), do: find_2nd(next, largest)

  def parse_file!() do
    "inputs/3.txt"
    |> File.read!()
    |> String.split()
    # |> Enum.take(5)
    |> Enum.map(&parse!/1)
  end

  @spec parse!(String.t()) :: nonempty_list(pos_integer())
  def parse!(s), do: Enum.map(String.graphemes(s), &String.to_integer/1)
end

IO.puts(Go.go1())
