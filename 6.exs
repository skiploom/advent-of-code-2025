defmodule Go do
  # Part 1
  def go1() do
    parse_file!()
    |> Enum.map(fn [op | nums] -> Enum.reduce(nums, op) end)
    |> Enum.sum()
  end

  def parse_file!() do
    "inputs/6.txt"
    |> File.read!()
    |> String.split("\n")
    |> Enum.drop(-1)
    |> Enum.map(&String.split/1)
    |> Enum.zip_with(&parse_col!(&1, []))
  end

  def parse_col!([], acc), do: acc
  def parse_col!([curr | rest], acc), do: parse_col!(rest, [parse_cell!(curr) | acc])

  def parse_cell!("+"), do: &+/2
  def parse_cell!("*"), do: &*/2
  def parse_cell!(x), do: String.to_integer(x)

  # Part 2
  def go2() do
    "inputs/6.txt"
    |> File.read!()
    |> String.split("\n")
    |> Enum.drop(-1)
    |> Enum.map(&String.graphemes/1)
    |> Enum.zip_with(& &1)
    |> solve!()
  end

  def solve!(cols) do
    scan!(cols, {0, {nil, []}})
  end

  def scan!([last], {solved, {op, nums}}) do
    case col!(last, "") do
      {new_op, x} -> solved + Enum.reduce([x | nums], new_op)
      :blank_line -> solved + Enum.reduce(nums, op)
      x -> solved + Enum.reduce([x | nums], op)
    end
  end

  def scan!([col | rest], {solved, {op, nums}}) do
    case col!(col, "") do
      {new_op, x} -> scan!(rest, {solved, {new_op, [x | nums]}})
      :blank_line -> scan!(rest, {solved + Enum.reduce(nums, op), {nil, []}})
      x -> scan!(rest, {solved, {op, [x | nums]}})
    end
  end

  def col!([" "], ""), do: :blank_line
  def col!([" "], acc), do: String.to_integer(acc)
  def col!(["+"], acc), do: {&+/2, String.to_integer(acc)}
  def col!(["*"], acc), do: {&*/2, String.to_integer(acc)}
  def col!([" " | rest], acc), do: col!(rest, acc)
  def col!([curr | rest], acc), do: col!(rest, acc <> curr)
end

IO.puts(Go.go1())
IO.puts(Go.go2())
