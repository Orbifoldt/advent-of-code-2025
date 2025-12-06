defmodule Day06 do
  def part1() do
    FileUtil.read_lines("day06.txt")
    |> Enum.to_list()
    |> part1
  end

  @doc """
  ##
  iex> Day06.part1(["123 328  51 64"," 45 64  387 23","  6 98  215 314","*   +   *   +  "])
  4277556
  """
  def part1(data) do
    data |> parse_pt1 |> do_cephalopod_math
  end

  defp parse_pt1(raw_data) do
    {operator_row, number_rows} = List.pop_at(raw_data, -1)
    operators = operator_row |> String.split(" ", trim: true)

    operands =
      number_rows
      |> Enum.map(&String.split(&1, " ", trim: true))
      |> Util.transpose()
      |> Enum.map(&Enum.map(&1, fn x -> Util.parse_int!(x) end))

    {operators, operands}
  end

  # Assumes input of the form: operators=["*", "+", ...] and operands = [[1, 2, 3], [4, 5, 6], ...]
  # with the outcome then being (1*2*3) + (4+5+6)
  defp do_cephalopod_math({operators, operands}) do
    Enum.zip([operators, operands])
    |> Enum.map(fn {operator, nums} -> apply_operator(operator, nums) end)
    |> Enum.sum()
  end

  defp apply_operator("+", nums), do: Enum.sum(nums)
  defp apply_operator("*", nums), do: Enum.product(nums)
  defp apply_operator(op, _), do: raise(ArgumentError, "uh oh: operator unknown '#{inspect(op)}'")

  defp parse_pt2(raw_data) do
    {op_row, number_rows} = List.pop_at(raw_data, -1)

    operators_with_index =
      op_row
      |> String.graphemes()
      |> Enum.with_index(fn c, idx -> {c, idx} end)
      |> Enum.filter(fn {c, _idx} -> c == "*" || c == "+" end)

    operators = Enum.map(operators_with_index, &elem(&1, 0))

    operands =
      operators_with_index
      |> Enum.map(&elem(&1, 1))
      |> Enum.chunk_every(2, 1)
      |> Enum.map(&extract_column(&1, number_rows))
      |> Enum.map(fn col ->
        col
        |> Enum.map(&String.graphemes/1)
        |> Util.transpose()
        |> Enum.map(&(Enum.join(&1) |> String.trim() |> Util.parse_int!()))
      end)

    {operators, operands}
  end

  defp extract_column([idx1, idx2], number_rows) do
    Enum.map(number_rows, &String.slice(&1, idx1..(idx2 - 2)))
  end

  defp extract_column([idx], number_rows) do
    Enum.map(number_rows, &String.slice(&1, idx..String.length(&1)))
  end

  def part2() do
    # Don't trim as trailing whitespace is important
    FileUtil.read_lines("day06.txt", trim: false)
    |> Enum.to_list()
    # We do need to trim trailing new-lines
    |> Enum.map(&String.replace_suffix(&1, "\n", ""))
    |> part2
  end

  @doc """
  ##
  iex> Day06.part2(["123 328  51 64 "," 45 64  387 23 ","  6 98  215 314","*   +   *   +  "])
  3263827
  """
  def part2(data) do
    data |> parse_pt2 |> do_cephalopod_math
  end
end
