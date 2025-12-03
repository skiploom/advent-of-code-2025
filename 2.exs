defmodule Go do
  def go1() do
    goo1(parse_file!(), 0)
  end

  def goo1([], acc), do: acc
  def goo1([range | next], acc) do
    sum_invalid_ids = gooo1(Enum.to_list(range), 0)
    goo1(next, acc + sum_invalid_ids)
  end

  def gooo1([], acc), do: acc
  def gooo1([id | next], acc) do
    add = if is_invalid(id), do: id, else: 0
    gooo1(next, acc + add)
  end

  def is_invalid(id) do
    id_str = Integer.to_string(id)
    len = String.length(id_str)

    if len > 0 && Integer.mod(len, 2) == 0 do
      case String.split_at(id_str, div(len, 2)) do
        {same, same} -> true
        _ -> false
      end
    else
      false
    end
  end

  def parse_file!() do
    "inputs/2.txt"
    |> File.read!()
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&parse!/1)
  end

  @spec parse!(String.t()) :: Range.t()
  def parse!(s) do
    case String.split(s, "-") do
      [first, last] -> String.to_integer(first)..String.to_integer(last)
      _ -> raise "Failed to parse."
    end
  end
end

IO.puts(Go.go1())
