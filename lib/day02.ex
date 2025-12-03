defmodule Day02 do
  def part1() do
    FileUtil.read_lines("day02.txt")
    |> Enum.to_list()
    |> Enum.at(0)
    |> part1()
  end

  @doc """
  ##
  iex>Day02.part1("11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124")
  1227775554
  """
  def part1(content) do
    String.split(content, ",", trim: true)
    |> Enum.map(fn range -> String.split(range, "-", trim: true) end)
    |> Enum.map(fn [first, last] ->
      {Integer.parse(first) |> elem(0), Integer.parse(last) |> elem(0)}
    end)
    |> Enum.map(fn {first, last} -> sum_invalids(first, last) end)
    |> Enum.sum()
  end

  @doc """
  ##
  iex> Day02.sum_invalids(11, 22)
  33
  iex> Day02.sum_invalids(95,115)
  99
  iex> Day02.sum_invalids(1188511880, 1188511890)
  1188511885
  iex> Day02.sum_invalids(1698522, 1698528)
  0
  """
  def sum_invalids(first, last) do
    first..last
    |> Enum.filter(&is_invalid/1)
    |> Enum.sum()
  end

  @doc """
  ##
  iex>Day02.is_invalid(11)
  true
  iex>Day02.is_invalid(15)
  false
  iex>Day02.is_invalid(1188511885)
  true
  iex>Day02.is_invalid(38593862)
  false
  """
  def is_invalid(num) do
    chars = Integer.to_charlist(num)
    size = length(chars)
    middle = div(size, 2)
    first = Enum.take(chars, middle)
    last = Enum.drop(chars, middle)
    first == last
  end

  def part2() do
    FileUtil.read_lines("day02.txt")
    |> Enum.to_list()
    |> Enum.at(0)
    |> part2()
  end

  @doc """
  ##
  iex>Day02.part2("11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124")
  4174379265
  """
  def part2(content) do
    String.split(content, ",", trim: true)
    |> Enum.map(fn range -> String.split(range, "-", trim: true) end)
    |> Enum.map(fn [first, last] ->
      {Integer.parse(first) |> elem(0), Integer.parse(last) |> elem(0)}
    end)
    |> Enum.map(fn {first, last} -> sum_invalids_pt2(first, last) end)
    |> Enum.sum()
  end

  @doc """
  ##
  iex> Day02.sum_invalids_pt2(11, 22)
  33
  iex> Day02.sum_invalids_pt2(95,115)
  99+111
  iex> Day02.sum_invalids_pt2(1188511880, 1188511890)
  1188511885
  iex> Day02.sum_invalids_pt2(1698522, 1698528)
  0
  """
  def sum_invalids_pt2(first, last) do
    first..last
    |> Enum.filter(&is_invalid_pt2/1)
    |> Enum.sum()
  end

  @doc """
  ##
  iex>Day02.is_invalid_pt2(11)
  true
  iex>Day02.is_invalid_pt2(15)
  false
  iex>Day02.is_invalid_pt2(1188511885)
  true
  iex>Day02.is_invalid_pt2(38593862)
  false
  iex>Day02.is_invalid_pt2(111)
  true
  iex>Day02.is_invalid_pt2(824824824)
  true
  iex>Day02.is_invalid_pt2(7)
  false
  """
  def is_invalid_pt2(num) do
    chars = Integer.to_charlist(num)
    size = length(chars)

    if size == 1 do
      false
    else
      1..div(size, 2)
      |> Enum.filter(fn x -> rem(size, x) == 0 end)
      |> Enum.find(fn chunk_size -> has_repeating_chunks(chars, chunk_size) end) != nil
    end
  end

  defp has_repeating_chunks(chars, chunk_size) do
    chunks = Enum.chunk_every(chars, chunk_size)
    first = Enum.at(chunks, 0)
    Enum.all?(chunks, fn chunk -> chunk == first end)
  end
end
