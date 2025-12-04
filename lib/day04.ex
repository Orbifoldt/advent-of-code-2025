defmodule Day04 do
  def part1() do
    FileUtil.read_lines("day04.txt")
    |> Enum.to_list()
    |> part1
  end

  @doc """
  ##
  iex> Day04.part1(["..@@.@@@@.","@@@.@.@.@@","@@@@@.@.@@","@.@@@@..@.","@@.@@@@.@@",".@@@@@@@.@",".@.@.@.@@@","@.@@@.@@@@",".@@@@@@@@.","@.@.@@@.@.",])
  13
  """
  def part1(data) do
    data
    |> parse()
    |> filter_can_be_moved()
    |> Enum.count()
  end

  defp parse(raw_data) do
    data = Enum.map(raw_data, &String.graphemes/1)
    h = length(data)
    w = length(Enum.at(data, 0))

    0..(h - 1)
    |> Enum.reduce(MapSet.new(), fn y, paper_locs ->
      row = Enum.at(data, y)

      0..(w - 1)
      |> Enum.reduce(paper_locs, fn x, paper_locs_nested ->
        value = Enum.at(row, x)

        if value == "@" do
          MapSet.put(paper_locs_nested, {x, y})
        else
          paper_locs_nested
        end
      end)
    end)
  end

  def filter_can_be_moved(map, max \\ 3) do
    map |> Enum.filter(fn {x, y} -> count_neighbors(map, {x, y}) <= max end)
  end

  def count_neighbors(map, {x, y}) do
    nbs = for nx <- -1..1, ny <- -1..1, {nx, ny} != {0, 0}, do: {x + nx, y + ny}
    nbs |> Enum.count(fn c -> MapSet.member?(map, c) end)
  end

  def move_out_all(initial_map, max \\ 3) do
    Stream.iterate(0, &(&1 + 1))
    |> Enum.reduce_while({initial_map, []}, fn _, {map, removed} ->
      movable = map |> filter_can_be_moved(max)

      if length(movable) == 0 do
        {:halt, {map, removed}}
      else
        new_map = MapSet.difference(map, MapSet.new(movable))
        {:cont, {new_map, removed ++ movable}}
      end
    end)
  end

  def part2() do
    FileUtil.read_lines("day04.txt")
    |> Enum.to_list()
    |> part2
  end

  @doc """
  ##
  iex> Day04.part2(["..@@.@@@@.","@@@.@.@.@@","@@@@@.@.@@","@.@@@@..@.","@@.@@@@.@@",".@@@@@@@.@",".@.@.@.@@@","@.@@@.@@@@",".@@@@@@@@.","@.@.@@@.@.",])
  43
  """
  def part2(data) do
    {_final_map, removed} =
      data
      |> parse()
      |> move_out_all()

    length(removed)
  end
end
