defmodule Day11 do
  def part1() do
    FileUtil.read_lines("day11.txt")
    |> Enum.to_list()
    |> part1
  end

  @doc """
  ##
  iex> Day11.part1(["aaa: you hhh","you: bbb ccc","bbb: ddd eee","ccc: ddd eee fff","ddd: ggg","eee: out","fff: out","ggg: out","hhh: ccc fff iii","iii: out",])
  5
  """
  def part1(data) do
    adj = data |> parse
    count_paths(adj, "you", "out")
  end

  defp count_paths(adj, current, final), do: elem(count_paths(adj, current, final, %{}), 0)

  defp count_paths(adj, current, final, cache) do
    cached_value = Map.get(cache, {current, final})

    if cached_value != nil do
      {cached_value, cache}
    else
      {total, cache_after_iterations} =
        if current == final do
          {1, cache}
        else
          Map.get(adj, current, [])
          |> Enum.reduce({0, cache}, fn neighbor, {sum, cur_cache} ->
            {count, updated_cache} = count_paths(adj, neighbor, final, cur_cache)
            {sum + count, updated_cache}
          end)
        end

      updated_cached = Map.put(cache_after_iterations, {current, final}, total)
      {total, updated_cached}
    end
  end

  defp parse(raw_data) do
    raw_data
    |> Enum.map(fn row ->
      [node, neighbors_str] = String.split(row, ":")
      neighbors = String.split(String.trim(neighbors_str), " ")
      {node, neighbors}
    end)
    |> Map.new()
  end

  def part2() do
    FileUtil.read_lines("day11.txt")
    |> Enum.to_list()
    |> part2
  end

  @doc """
  ##
  iex> Day11.part2(["svr: aaa bbb","aaa: fft","fft: ccc","bbb: tty","tty: ccc","ccc: ddd eee","ddd: hub","hub: fff","eee: dac","dac: fff","fff: ggg hhh","ggg: out","hhh: out",])
  2
  """
  def part2(data) do
    adj = data |> parse

    fft_to_dac = count_paths(adj, "fft", "dac")
    dac_to_fft = count_paths(adj, "dac", "fft")

    # Exactly one of fft_to_dac and dac_to_fft is nil, else the problem has no solution
    if fft_to_dac != 0 do
      svr_to_fft = count_paths(adj, "svr", "fft")
      dac_to_out = count_paths(adj, "dac", "out")
      svr_to_fft * fft_to_dac * dac_to_out
    else
      svr_to_dac = count_paths(adj, "svr", "dac")
      fft_to_out = count_paths(adj, "fft", "out")
      svr_to_dac * dac_to_fft * fft_to_out
    end
  end
end
