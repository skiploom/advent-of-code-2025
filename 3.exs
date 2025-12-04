defmodule Go do
  # Part 1
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

  # Part 2
  @num_batt 12

  def go2() do
    parse_file!()
    |> Enum.map(&poo/1)
    |> Enum.sum()
  end

  def poo(bank) do
    foo(bank, 1, -1, 0)
  end

  def foo(_, n, _, acc) when n == @num_batt + 1, do: acc
  def foo(bank, n, prev_i, acc) do
    start_i = prev_i + 1

    # The window for the first battery is every digit except the last 11.
    # The window for the second battery is every digit between the first battery and the last 10.
    # And so on...
    window =
      bank
      |> Enum.drop(start_i)
      |> Enum.drop(-@num_batt + n)

    {batt, batt_i} = find_n(window, start_i, 0, start_i)
    batt_num = batt * Integer.pow(10, @num_batt - n)

    foo(bank, n + 1, batt_i, acc + batt_num)
  end

  def find_n([], _, acc, acc_i), do: {acc, acc_i}
  def find_n([curr | next], i, acc, _) when curr > acc, do: find_n(next, i + 1, curr, i)
  def find_n([_ | next], i, acc, acc_i), do: find_n(next, i + 1, acc, acc_i)

  # Shared
  def parse_file!() do
    "inputs/3.txt"
    |> File.read!()
    |> String.split()
    |> Enum.map(&parse!/1)
  end

  @spec parse!(String.t()) :: nonempty_list(pos_integer())
  def parse!(s), do: Enum.map(String.graphemes(s), &String.to_integer/1)
end

IO.puts(Go.go1())
IO.puts(Go.go2())
