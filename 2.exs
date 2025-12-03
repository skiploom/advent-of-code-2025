defmodule Go do
  # Part 1
  def go1() do
    goo(parse_file!(), &is_invalid1/1, 0)
  end

  def is_invalid1(id) do
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

  # Part 2
  def go2() do
    goo(parse_file!(), &is_invalid2/1, 0)
  end

  def is_invalid2(id) do
    id_str = Integer.to_string(id)
    len = String.length(id_str)

    len > 0 && is_repeated(id_str, len, len - 1)
  end

  def is_repeated(_, _, 0), do: false
  def is_repeated(str, len, maybe_factor) do
    if Integer.mod(len, maybe_factor) == 0 do
      factor1 = maybe_factor
      factor2 = div(len, factor1)
      {substr, _} = String.split_at(str, factor1)
      if repeat(substr, factor2) == str do
        true
      else
        is_repeated(str, len, maybe_factor - 1)
      end
    else
      is_repeated(str, len, maybe_factor - 1)
    end
  end

  def repeat(str, n), do: append(str, n, "")

  def append(_, 0, acc), do: acc
  def append(str, n, acc), do: append(str, n - 1, acc <> str)

  # Shared
  def goo([], _, acc), do: acc
  def goo([range | next], p, acc) do
    sum_invalid_ids = gooo(Enum.to_list(range), p, 0)
    goo(next, p, acc + sum_invalid_ids)
  end

  def gooo([], _, acc), do: acc
  def gooo([id | next], p, acc) do
    add = if p.(id), do: id, else: 0
    gooo(next, p, acc + add)
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
IO.puts(Go.go2())
