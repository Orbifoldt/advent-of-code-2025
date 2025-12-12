defmodule Day09 do
  def part1() do
    FileUtil.read_lines("day09.txt")
    |> Enum.to_list()
    |> part1
  end

  @doc """
  ##
  iex> Day09.part1(["7,1","11,1","11,7","9,7","9,5","2,5","2,3","7,3",])
  50
  """
  def part1(data) do
    data
    |> parse
    |> max_square
  end

  defp parse(data) do
    data
    |> Enum.map(fn row ->
      result = Regex.run(~r/(\d+),(\d+)/, row)

      if result == nil do
        nil
      else
        x = Util.parse_int!(Enum.at(result, 1))
        y = Util.parse_int!(Enum.at(result, 2))
        {x, y}
      end
    end)
  end

  defp max_square(coords) do
    for v <- coords, w <- coords do
      area(v, w)
      # dbg([v, w, area])
    end
    |> Enum.max()
  end

  def area({x_a, y_a}, {x_b, y_b}) do
    dx = abs(x_a - x_b) + 1
    dy = abs(y_a - y_b) + 1

    dx * dy
  end

  def part2() do
    FileUtil.read_lines("day09.txt")
    |> Enum.to_list()
    |> part2
  end

  @doc """
  ##
  iex> Day09.part2(["7,1","11,1","11,7","9,7","9,5","2,5","2,3","7,3",])
  24
  """
  def part2(data) do
    data
    |> parse
    |> max_square_green
  end

  defp max_square_green(coords) do
    lines = Enum.chunk_every(coords, 2, 1, [Enum.at(coords, 0)])

    for v <- coords, w <- coords, v != w do
      {v, w}
    end
    |> Enum.reduce(-1, fn {v, w}, cur_max ->
      area = area(v, w)

      if area <= cur_max do
        cur_max
      else
        # Given any square
        # (vx, vy) --- (wx, vy)
        #    |            |
        # (vx, wy) --- (wx, wy)
        {vx, vy} = v
        {wx, wy} = w

        # Get lower left and upper right corners
        # (sx, ty) --- (tx, ty)
        #    |            |
        # (sx, sy) --- (tx, sy)
        {sx, sy} = {min(vx, wx), min(vy, wy)}
        {tx, ty} = {max(vx, wx), max(vy, wy)}

        no_intersections =
          Enum.all?(lines, fn [{lax, lay}, {lbx, lby}] ->
            # Given now a line {lax, lay} --- {lbx, lby}
            # It does not intersect above square if:

            # right endpoint of l is to the left of left edge
            # left endpoint of l is to the right of right edge
            # top endpoint of l is below the bottom edge
            # bottom endpoint of l is above the top edge
            max(lax, lbx) <= sx ||
              tx <= min(lax, lbx) ||
              max(lay, lby) <= sy ||
              ty <= min(lay, lby)
          end)

        if no_intersections do
          max(cur_max, area)
        else
          cur_max
        end
      end
    end)
  end
end
