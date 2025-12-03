defmodule Day03 do
  def part1() do
    FileUtil.read_lines("day03.txt")
    |> Enum.to_list()
    |> part1
  end

  @doc """
  ##
  iex> Day03.part1(["987654321111111", "811111111111119", "234234234234278", "818181911112111"])
  357
  """
  def part1(data) do
    data |> Enum.map(&joltage/1) |> Enum.sum()
  end

  @doc """
  ##
  iex> Day03.joltage("987654321111111")
  98
  iex> Day03.joltage("811111111111119")
  89
  iex> Day03.joltage("234234234234278")
  78
  iex> Day03.joltage("818181911112111")
  92
  iex> Day03.joltage("987654321111111", 12)
  987654321111
  iex> Day03.joltage("811111111111119", 12)
  811111111119
  iex> Day03.joltage("234234234234278", 12)
  434234234278
  iex> Day03.joltage("818181911112111", 12)
  888911112111
  """
  def joltage(battery_bank, len \\ 2) do
    values =
      battery_bank
      |> String.graphemes()
      |> Enum.map(&Integer.parse(&1, 10))
      |> Enum.map(&elem(&1, 0))

    n = length(values)

    len..1//-1
    |> Enum.reduce({-1, 0}, fn x, acc ->
      {prev_max_idx, total} = acc

      {max, max_idx} =
        values
        |> Enum.slice((prev_max_idx + 1)..(n - x))
        |> max_with_index

      new_total = total * 10 + max
      {max_idx + prev_max_idx + 1, new_total}
    end)
    |> elem(1)
  end

  defp max_with_index(enumerable) do
    enumerable
    |> Enum.with_index()
    |> Enum.max_by(&elem(&1, 0))
  end

  def part2() do
    FileUtil.read_lines("day03.txt")
    |> Enum.to_list()
    |> part2
  end

  @doc """
  ##
  iex> Day03.part2(["987654321111111", "811111111111119", "234234234234278", "818181911112111"])
  3121910778619
  """
  def part2(data) do
    data |> Enum.map(&joltage(&1, 12)) |> Enum.sum()
  end
end
