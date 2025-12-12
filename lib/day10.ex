defmodule Day10 do
  import Bitwise

  def part1() do
    FileUtil.read_lines("day10.txt")
    |> Enum.to_list()
    |> part1
  end

  @doc """
  ##
  iex> Day10.part1(["[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}",])
  2
  iex> Day10.part1(["[...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}",])
  3
  iex> Day10.part1(["[.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}",])
  2
  iex> Day10.part1(["[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}","[...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}","[.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}",])
  7
  """
  def part1(raw_data) do
    raw_data |> parse |> sum_minimal_button_presses
  end

  defp sum_minimal_button_presses(data) do
    data
    |> Enum.map(fn {n, lights, buttons, _} ->
      0..((1 <<< length(buttons)) - 1)
      |> Enum.map(fn mask ->
        final_state = press_buttons(buttons, mask, n)

        if final_state == lights do
          count_1_bits(mask)
        else
          false
        end
      end)
      |> Enum.filter(fn x -> x != false end)
      |> Enum.min()
    end)
    |> Enum.sum()
  end

  # Press the buttons according to the provided bit mask
  defp press_buttons(buttons, mask, num_lights) do
    initial_state = 0..(num_lights - 1) |> Enum.map(fn _ -> 0 end)

    Enum.with_index(buttons)
    |> Enum.reduce(initial_state, fn {button, i}, acc ->
      if (mask &&& 1 <<< i) != 0 do
        # Press the button
        Enum.zip(button, acc) |> Enum.map(fn {b, light} -> rem(b + light, 2) end)
      else
        # Don't press the button
        acc
      end
    end)
  end

  @doc """
  ##
  iex> Day10.count_1_bits(7)
  3
  iex> Day10.count_1_bits(10)
  2
  """
  def count_1_bits(int), do: count_1_bits(int, 0)
  defp count_1_bits(0, total), do: total
  defp count_1_bits(int, total), do: count_1_bits(int >>> 1, total + (int &&& 1))

  defp parse(raw_data) do
    raw_data
    |> Enum.map(fn row ->
      result = Regex.run(~r/\[([#\.]+)\]\s((?:\([\d+\,?]+\)\s)+)\s?{([\d,]+)}/, row)

      lights_str = Enum.at(result, 1)
      buttons_str = Enum.at(result, 2)
      joltage_str = Enum.at(result, 3)

      lights = parse_lights([], lights_str)
      n = length(lights)

      buttons = parse_buttons(buttons_str, n)
      joltage = parse_joltage(joltage_str)
      {n, lights, buttons, joltage}
    end)
  end

  defp parse_lights(acc, ""), do: acc |> Enum.reverse()
  defp parse_lights(acc, "." <> tail), do: parse_lights([0 | acc], tail)
  defp parse_lights(acc, "#" <> tail), do: parse_lights([1 | acc], tail)

  defp parse_buttons(buttons_str, n) do
    result =
      Regex.scan(~r/(?:\(([\d,]+)\))/, buttons_str)
      |> Enum.map(fn match -> Enum.at(match, 1) end)
      |> Enum.map(&Regex.split(~r/,/, &1))
      |> Enum.map(fn button ->
        nums = Enum.map(button, &Util.parse_int!/1) |> MapSet.new()

        0..(n - 1)
        |> Enum.map(fn i ->
          if MapSet.member?(nums, i), do: 1, else: 0
        end)
      end)

    dbg(result)
  end

  defp parse_joltage(joltage_string) do
    String.split(joltage_string, ",") |> Enum.map(&Util.parse_int!/1)
  end

  # See python solution...
  # def part2() do
  #   FileUtil.read_lines("day10.txt")
  #   |> Enum.to_list()
  #   |> part2
  # end

  # @doc """
  # ##
  # iex> Day10.part2(["[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}",])
  # 10
  # iex> Day10.part2(["[...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}",])
  # 12
  # iex> Day10.part2(["[.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}",])
  # 11
  # iex> Day10.part2(["[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}","[...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}","[.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}",])
  # 33
  # """
  # def part2(raw_data) do
  #   raw_data |> parse #|> sum_minimal_button_presses_for_joltage
  #   |> Enum.map(fn {_, _, buttons, joltage} ->
  #     dbg(buttons)
  #     dbg(joltage)
  #   end)
  # end
end
