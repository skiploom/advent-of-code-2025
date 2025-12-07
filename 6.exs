defmodule Go do
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
end

IO.puts(Go.go1())
