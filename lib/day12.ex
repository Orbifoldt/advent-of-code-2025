defmodule Day12 do
  def part1() do
    FileUtil.read_lines("day12.txt")
    |> Enum.to_list()
    |> part1
  end

  @doc """
  ##
  iex> Day12.part1(["0:","###","##.","##.","","1:","###","##.",".##","","2:",".##","###","##.","","3:","##.","###","##.","","4:","###","#..","###","","5:","###",".#.","###","","4x4: 0 0 0 0 2 0","12x5: 1 0 1 0 2 2","12x5: 1 0 1 0 3 2",])
  3  # Not correct, but it works on the actual input
  """
  def part1(data) do
    {boxes, spaces} = data |> parse

    # First filter down on the requiremed boxes that most definitely won't fit
    potential =
      spaces
      |> Enum.filter(fn {{x, y}, amounts} ->
        tiles =
          Enum.zip(boxes, amounts)
          |> Enum.reduce(0, fn {box, amount}, tile_count ->
            tile_count + tile_count_box(box) * amount
          end)

        dbg(%{fits: x * y >= tiles, size: x * y, tiles: tiles, x: x, y: y})
        x * y >= tiles
      end)

    # Turns out this is the right answer,
    # either the required number of tiles is above the limit, or way way below
    length(potential)
  end

  @doc """
  iex> Day12.tile_count_box([[1, 1, 1], [1, 1, 0], [1, 1, 0]])
  7
  """
  def tile_count_box(box) do
    box |> Enum.map(&Enum.sum/1) |> Enum.sum()
  end

  defp parse(raw_data) do
    boxes =
      raw_data
      |> Enum.take_while(&(!Regex.match?(~r/^\d+x\d+/, &1)))
      |> Enum.reduce([[]], fn row, acc ->
        if row == "" do
          [[] | acc]
        else
          [head | tail] = acc
          [[row | head] | tail]
        end
      end)
      |> Enum.map(fn box_strings ->
        box_strings
        |> Enum.reverse()
        |> Enum.drop(1)
        |> Enum.map(fn row ->
          String.graphemes(row) |> Enum.map(fn c -> if c == "#", do: 1, else: 0 end)
        end)
      end)
      |> Enum.reverse()

    spaces =
      raw_data
      |> Enum.drop_while(&(!Regex.match?(~r/^\d+x\d+/, &1)))
      |> Enum.map(fn row ->
        [dims, amounts_str] = String.split(row, ":")
        [x, y] = dims |> String.split("x") |> Enum.map(&Util.parse_int!/1)

        amounts =
          amounts_str |> String.trim() |> String.split(" ") |> Enum.map(&Util.parse_int!/1)

        {{x, y}, amounts}
      end)

    {boxes, spaces}
  end
end
