defmodule Go do
  # Part 1
  def go1() do
    num_connections = 1000

    boxes = parse_file!()

    {pairs, _} =
      boxes
      |> dists()
      |> Enum.sort_by(fn {_, dist} -> dist end)
      |> Enum.take(num_connections)
      |> Enum.unzip()

    connectAll!(pairs, boxes)
    |> Enum.map(fn {_, circuit} -> MapSet.size(circuit) end)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.reduce(1, &*/2)
  end

  def connectAll!(pairs, boxes) do
    boxToCircuits = mkBoxToCircuits(boxes, 1, %{})
    circuitToContents = mkCircuitToContents(boxToCircuits)

    connect!(pairs, boxToCircuits, circuitToContents)
  end

  def connect!([], _, circuitToContents), do: circuitToContents

  def connect!([{b1, b2} | rest], boxToCircuits, circuitToContents) do
    case {Map.get(boxToCircuits, b1), Map.get(boxToCircuits, b2)} do
      {nil, _} ->
        raise("oop")

      {_, nil} ->
        raise("oop")

      {same, same} ->
        connect!(rest, boxToCircuits, circuitToContents)

      {old, new} ->
        newBoxToCircuits =
          Map.merge(
            boxToCircuits,
            Map.from_keys(MapSet.to_list(Map.get(circuitToContents, old)), new)
          )

        merged = MapSet.union(Map.get(circuitToContents, old), Map.get(circuitToContents, new))

        newCircuitToContents =
          circuitToContents
          |> Map.replace!(new, merged)
          |> Map.delete(old)

        connect!(rest, newBoxToCircuits, newCircuitToContents)
    end
  end

  # Part 2
  def go2() do
    boxes = parse_file!()

    {pairs, _} =
      boxes
      |> dists()
      |> Enum.sort_by(fn {_, dist} -> dist end)
      |> Enum.unzip()

    {{x1, _, _}, {x2, _, _}} = actuallyConnectAll!(pairs, boxes)
    x1 * x2
  end

  def actuallyConnectAll!(pairs, boxes) do
    boxToCircuits = mkBoxToCircuits(boxes, 1, %{})
    circuitToContents = mkCircuitToContents(boxToCircuits)

    megaConnect!(pairs, boxToCircuits, circuitToContents)
  end

  # This is almost exactly the same as connect!/3 from Part 1.
  # This year, I don't really want to DRY up code between the parts or
  # change anything from the previous part, so that it's easier for me
  # to see exactly what I thought of for each problem.
  def megaConnect!([{b1, b2} | rest], boxToCircuits, circuitToContents) do
    case {Map.get(boxToCircuits, b1), Map.get(boxToCircuits, b2)} do
      {nil, _} ->
        raise("oop")

      {_, nil} ->
        raise("oop")

      {same, same} ->
        megaConnect!(rest, boxToCircuits, circuitToContents)

      {old, new} ->
        newBoxToCircuits =
          Map.merge(
            boxToCircuits,
            Map.from_keys(MapSet.to_list(Map.get(circuitToContents, old)), new)
          )

        merged = MapSet.union(Map.get(circuitToContents, old), Map.get(circuitToContents, new))

        newCircuitToContents =
          circuitToContents
          |> Map.replace!(new, merged)
          |> Map.delete(old)

        if map_size(newCircuitToContents) == 1 do
          {b1, b2}
        else
          megaConnect!(rest, newBoxToCircuits, newCircuitToContents)
        end
    end
  end

  # Shared
  # Calculate distances between all pairs
  def dists(ps), do: distss(ps, [])

  def distss([p1, p2], acc), do: [{{p1, p2}, dist(p1, p2)} | acc]

  def distss([p1 | rest], acc) do
    distss(rest, distsss(p1, rest, []) ++ acc)
  end

  def distsss(_, [], acc), do: acc
  def distsss(p1, [p2 | rest], acc), do: distsss(p1, rest, [{{p1, p2}, dist(p1, p2)} | acc])

  # Calculate distance between a pair
  def dist({x1, y1, z1}, {x2, y2, z2}) do
    ((x1 - x2) ** 2 + (y1 - y2) ** 2 + (z1 - z2) ** 2) ** 0.5
  end

  def mkBoxToCircuits([], _, acc), do: acc
  def mkBoxToCircuits([b | rest], c, acc), do: mkBoxToCircuits(rest, c + 1, Map.put(acc, b, c))

  def mkCircuitToContents(boxToCircuits) do
    Map.new(boxToCircuits, fn {b, c} -> {c, MapSet.new([b])} end)
  end

  def parse_file!() do
    "inputs/8.txt"
    |> File.read!()
    |> String.split()
    |> Enum.map(&p!/1)
  end

  def p!(s) do
    String.split(s, ",")
    |> Enum.map(&String.to_integer/1)
    |> case do
      [x, y, z] -> {x, y, z}
    end
  end
end

IO.puts(Go.go1())
IO.puts(Go.go2())
