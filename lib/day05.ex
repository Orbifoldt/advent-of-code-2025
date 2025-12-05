defmodule Day05 do
  def part1() do
    FileUtil.read_lines("day05.txt")
    |> Enum.to_list()
    |> part1
  end

  @doc """
  ##
  iex> Day05.part1(["3-5","10-14","16-20","12-18","","1","5","8","11","17","32",])
  3
  """
  def part1(data) do
    {ranges, ids} = data |> parse
    count_fresh(ranges, ids)
  end

  defp count_fresh(ranges, ids) do
    ids
    |> Enum.count(fn id ->
      Enum.any?(ranges, fn range -> id in range end)
    end)
  end

  defp parse(raw_data) do
    raw_data
    |> Enum.reduce({[], []}, fn row, {ranges, ids} ->
      cond do
        row == "" -> {ranges, ids}
        (range = parse_range(row)) != nil -> {[range | ranges], ids}
        true -> {ranges, [elem(Integer.parse(row), 0) | ids]}
      end
    end)
  end

  defp parse_range(str) do
    result = Regex.run(~r/(\d+)-(\d+)/, str)

    if result == nil do
      nil
    else
      a = elem(Integer.parse(Enum.at(result, 1)), 0)
      b = elem(Integer.parse(Enum.at(result, 2)), 0)
      a..b
    end
  end

  def part2() do
    FileUtil.read_lines("day05.txt")
    |> Enum.to_list()
    |> part2
  end

  @doc """
  ##
  iex> Day05.part2(["3-5","10-14","16-20","12-18","","1","5","8","11","17","32",])
  14
  """
  def part2(data) do
    {ranges, _ids} = data |> parse

    combine_overlapping(ranges)
    |> Enum.map(fn range -> Range.size(range) end)
    |> Enum.sum()
  end

  @doc """
  ##
  iex> Day05.combine_overlapping([0..10, 5..15])
  [0..15]
  iex> Day05.combine_overlapping([12..17, 0..10, 5..15])
  [0..17]
  iex> Day05.combine_overlapping([1..4, 8..10])
  [1..4, 8..10]
  iex> Day05.combine_overlapping([1..2, 3..4, 5..6, 1..6])
  [1..6]
  """
  def combine_overlapping(ranges) do
    Stream.iterate(0, &(&1 + 1))
    |> Enum.reduce_while(ranges, fn _, cur ->
      next = combine_overlapping_single_pass(cur)

      if length(next) == length(cur) do
        {:halt, cur}
      else
        {:cont, next}
      end
    end)
  end

  defp combine_overlapping_single_pass(ranges) do
    ranges
    |> Enum.reduce([], fn range, acc ->
      first = range.first
      last = range.last
      a = Enum.find(acc, fn r -> first in r end)
      b = Enum.find(acc, fn r -> last in r end)

      if a == nil && b == nil do
        [range | acc]
      else
        removed_old = Enum.filter(acc, fn r -> r != a && r != b end)

        if a != nil && b != nil do
          [combine_ranges(a, b) | removed_old]
        else
          if a == nil && b != nil do
            [combine_ranges(range, b) | removed_old]
          else
            [combine_ranges(range, a) | removed_old]
          end
        end
      end
    end)
  end

  @doc """
  Combines two range, assuming they overlap
  ##
  iex>Day05.combine_ranges(0..5, 3..8)
  0..8
  iex>Day05.combine_ranges(3..8, 0..5)
  0..8
  iex>Day05.combine_ranges(3..13, 5..9)
  3..13
  iex>Day05.combine_ranges(5..9, 3..13)
  3..13
  """
  def combine_ranges(a..b//1, c..d//1) do
    Enum.min([a, c])..Enum.max([b, d])
  end
end
