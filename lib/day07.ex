defmodule Day07 do
  def part1() do
    FileUtil.read_lines("day07.txt")
    |> Enum.to_list()
    |> part1
  end

  @doc """
  ##
  iex> Day07.part1([".......S.......","...............",".......^.......","...............","......^.^......","...............",".....^.^.^.....","...............","....^.^...^....","...............","...^.^...^.^...","...............","..^...^.....^..","...............",".^.^.^.^.^...^.","...............",])
  21
  """
  def part1(data) do
    {splitters, start, width} = data |> parse

    {_, split_count} = propagate(splitters, start, width)
    split_count
  end

  @spec parse(list(String.t())) ::
          {
            splitter_indices :: list(list(non_neg_integer())),
            start_idx :: non_neg_integer(),
            width :: non_neg_integer()
          }
  defp parse(raw_data) do
    splitters =
      raw_data
      |> Enum.map(fn row ->
        String.graphemes(row) |> Enum.map(fn c -> c == "^" end)
      end)

    start = Enum.at(raw_data, 0) |> String.graphemes() |> Enum.find_index(fn c -> c == "S" end)
    width = String.length(Enum.at(raw_data, 0))
    {splitters, start, width}
  end

  defp propagate(splitters, start_index, width) do
    start_light_map =
      0..(width - 1)
      |> Enum.map(fn i -> if i == start_index, do: {i, 1}, else: {i, 0} end)
      |> Map.new()

    splitters
    |> Enum.reduce({start_light_map, 0}, fn splitter_indices, {prev_light_map, split_count} ->
      next_row(splitter_indices, prev_light_map, split_count)
    end)
  end

  defp next_row(splitter_indices, prev_light_map, split_count) do
    # For each column, determine the result of any potential beam travelling downwards
    next =
      Enum.zip(splitter_indices, prev_light_map)
      |> Enum.map(fn {is_splitter, {index, light_count}} ->
        # NB: input is nice, so light cannot be out of bounds (index < 0 or >= width)
        light_beam_next_row(index, light_count, is_splitter)
      end)

    num_splits = Enum.count(next, &elem(&1, 0))

    # Gather results of each column into a single light map
    next_light_map =
      next
      |> Enum.reduce(%{}, fn {_, light_level_map}, acc ->
        Map.merge(acc, light_level_map, fn _k, v1, v2 -> v1 + v2 end)
      end)

    {next_light_map, split_count + num_splits}
  end

  defp light_beam_next_row(index, 0, _is_split), do: {false, %{index => 0}}
  defp light_beam_next_row(index, light_count, false), do: {false, %{index => light_count}}

  defp light_beam_next_row(index, light_count, true),
    do: {true, %{(index - 1) => light_count, index => 0, (index + 1) => light_count}}

  def part2() do
    FileUtil.read_lines("day07.txt")
    |> Enum.to_list()
    |> part2
  end

  @doc """
  ##
  iex> Day07.part2([".......S.......","...............",".......^.......","...............","......^.^......","...............",".....^.^.^.....","...............","....^.^...^....","...............","...^.^...^.^...","...............","..^...^.....^..","...............",".^.^.^.^.^...^.","...............",])
  40
  """
  def part2(data) do
    {splitters, start, width} = data |> parse

    {final_row, _} = propagate(splitters, start, width)
    final_row |> Enum.map(fn {_k, v} -> v end) |> Enum.sum()
  end
end
