defmodule Day01 do
  def part1() do
    FileUtil.read_lines("day01.txt")
    |> Enum.to_list()
    |> part1
  end

  @doc """
  ##
  iex> Day01.part1(["L68", "L30", "R48", "L5", "R60", "L55", "L1", "L99", "R14", "L82",])
  3
  """
  def part1(entries) do
    entries
    |> Enum.map(&parse_rotation/1)
    |> count_final_zeroes
  end

  @doc """
  ##
  iex> Day01.parse_rotation("L68")
  -68
  iex> Day01.parse_rotation("R48")
  48
  """
  def parse_rotation(string) do
    case(string) do
      "L" <> num -> -String.to_integer(num)
      "R" <> num -> String.to_integer(num)
    end
  end

  def count_final_zeroes(input) do
    count_final_zeroes(0, 50, input)
  end

  defp count_final_zeroes(count, _current_sum, []) do
    count
  end

  defp count_final_zeroes(count, current_sum, [x | tail]) do
    next_sum = Integer.mod(current_sum + x, 100)
    next_count = count + if next_sum == 0, do: 1, else: 0
    count_final_zeroes(next_count, next_sum, tail)
  end

  def part2() do
    FileUtil.read_lines("day01.txt")
    |> Enum.to_list()
    |> part2
  end

  @doc """
  ##
  iex> Day01.part2(["L68", "L30", "R48", "L5", "R60", "L55", "L1", "L99", "R14", "L82",])
  6
  iex> Day01.part2(["L50", "R101"])  # 50 =L50=> 0 =R101=> 101=1
  2
  iex> Day01.part2(["L150"])
  2
  iex> Day01.part2(["L50", "R101", "L101"])  # 50 =L50=> 0 =R101=> 101=1 =L101=> -100=0
  4
  """
  def part2(entries) do
    entries
    |> Enum.map(&parse_rotation/1)
    |> count_all_zeroes
  end

  def count_all_zeroes(entries) do
    count_all_zeroes(0, 50, entries)
  end

  defp count_all_zeroes(count, _current_sum, []) do
    count
  end

  defp count_all_zeroes(count, current_sum, [x | tail]) do
    next_sum = current_sum + x

    next_count =
      count + abs(div(next_sum, 100)) + if current_sum != 0 && next_sum <= 0, do: 1, else: 0

    count_all_zeroes(next_count, Integer.mod(next_sum, 100), tail)
  end

  @doc """
  ##
  iex> Day01.positive_div_mod(77, 100)
  {0, 77}
  iex> Day01.positive_div_mod(188, 100)
  {1, 88}
  iex> Day01.positive_div_mod(-95, 100)
  {-1, 5}
  iex> Day01.positive_div_mod(-183, 100)
  {-2, 17}
  """
  def positive_div_mod(dividend, divisor) do
    result = div(dividend, divisor)
    remainder = rem(dividend, divisor)

    if remainder < 0 do
      {result - 1, remainder + divisor}
    else
      {result, remainder}
    end
  end
end
