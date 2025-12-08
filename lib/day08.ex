defmodule Day08 do
  def part1() do
    FileUtil.read_lines("day08.txt")
    |> Enum.to_list()
    |> part1(1000)
  end

  @doc """
  ##
  iex> Day08.part1(["162,817,812","57,618,57","906,360,560","592,479,940","352,342,300","466,668,158","542,29,236","431,825,988","739,650,466","52,470,668","216,146,977","819,987,18","117,168,530","805,96,715","346,949,466","970,615,88","941,993,340","862,61,35","984,92,344","425,690,689"])
  40
  """
  def part1(data, max_connected \\ 10) do
    coords = data |> parse

    components =
      coords
      |> sorted_distance_graph()
      |> connect_closest(length(coords), max_connected)
      |> connected_components()

    Enum.sort_by(components, &MapSet.size/1, :desc)
    |> Enum.take(3)
    |> Enum.map(&MapSet.size/1)
    |> Enum.product()
  end

  defp connected_components({vertices, edges}) do
    adj_map =
      vertices
      |> Enum.map(fn v ->
        neighbors =
          Enum.filter(edges, fn {i, j} -> v == i || v == j end)
          |> Enum.map(fn {i, j} -> if v == i, do: j, else: i end)

        {v, neighbors}
      end)
      |> Map.new()

    adj = &Map.get(adj_map, &1)

    {_, components} =
      Enum.reduce(vertices, {MapSet.new(), []}, fn v, {visited, components} ->
        if not MapSet.member?(visited, v) do
          component = dfs(adj, v, MapSet.new())
          new_visited = MapSet.union(visited, component)
          {new_visited, [component | components]}
        else
          {visited, components}
        end
      end)

    components
  end

  def dfs(adj, v, discovered) do
    neighbors = adj.(v)

    neighbors
    |> Enum.reduce(MapSet.put(discovered, v), fn w, new_discovered ->
      if not MapSet.member?(new_discovered, w) do
        dfs(adj, w, new_discovered)
      else
        new_discovered
      end
    end)
  end

  defp connect_closest(sorted_dist_graph, n_vertices, max_connected) do
    vertices = 0..(n_vertices - 1)

    edges =
      sorted_dist_graph |> Enum.take(max_connected) |> Enum.map(fn {i, j, _dist} -> {i, j} end)

    {vertices, edges}
  end

  defp sorted_distance_graph(coords) do
    indexed_coords = coords |> Enum.with_index()

    dist_graph =
      for {v_a, i_a} <- indexed_coords, {v_b, i_b} <- indexed_coords, i_a < i_b do
        {i_a, i_b, squared_distance(v_a, v_b)}
      end

    dist_graph |> Enum.sort_by(fn {_i, _j, dist} -> dist end)
  end

  def squared_distance({x_a, y_a, z_a}, {x_b, y_b, z_b}) do
    dx = x_a - x_b
    dy = y_a - y_b
    dz = z_a - z_b

    dx * dx + dy * dy + dz * dz
  end

  defp parse(data) do
    data
    |> Enum.map(fn row ->
      result = Regex.run(~r/(\d+),(\d+),(\d+)/, row)

      if result == nil do
        nil
      else
        x = elem(Integer.parse(Enum.at(result, 1)), 0)
        y = elem(Integer.parse(Enum.at(result, 2)), 0)
        z = elem(Integer.parse(Enum.at(result, 3)), 0)
        {x, y, z}
      end
    end)
  end

  # Given solution for part 1 this was my brute force solution for part 2...
  #
  # Improvements:
  # - Figure out how to profile code
  # - fix DFS to not build so many MapSets, seems like a lot of memory
  # - Or could use some other
  # - grow adj function with iterations, don't recreate it every time
  # - Better yet, combine the graph creation with the connectedness check
  #    - when adding an edge need to only check and update components based on that
  #    - probably not even needed to keep all edges, just merge components...
  #    => So:
  # init: components = [MapSet([v]) for v in vertices]
  # for (v, w) in edges:
  #     comp_v = find(components, comp -> v in comp)
  #     if w in comp_v:
  #         continue
  #     comp_w = find(components, comp -> w in comp)
  #     components.remove(comp_v, comp_w)    <-- need to find out how expensive this is in elixir
  #     components.add(union(comp_v, comp_w))
  def part2() do
    FileUtil.read_lines("day08.txt")
    |> Enum.to_list()
    |> part2
  end

  @doc """
  ##
  iex> Day08.part2(["162,817,812","57,618,57","906,360,560","592,479,940","352,342,300","466,668,158","542,29,236","431,825,988","739,650,466","52,470,668","216,146,977","819,987,18","117,168,530","805,96,715","346,949,466","970,615,88","941,993,340","862,61,35","984,92,344","425,690,689"])
  25272
  """
  def part2(data) do
    coords = data |> parse
    dist_graph = sorted_distance_graph(coords)
    num_vertices = length(coords)

    connections_required =
      Stream.iterate(10, &(&1 + 1))
      |> Enum.find(fn m ->
        if rem(m, 1000) == 0 do
          dbg(m)
        end

        dist_graph
        |> connect_closest(num_vertices, m)
        |> all_connected?(num_vertices)
      end)

    {i, j, _dist} = Enum.at(dist_graph, connections_required - 1)
    dbg(Enum.at(coords, i))
    dbg(Enum.at(coords, j))
    {x_a, _, _} = Enum.at(coords, i)
    {x_b, _, _} = Enum.at(coords, j)
    x_a * x_b
  end

  defp all_connected?({vertices, edges}, num_vertices) do
    adj_map =
      vertices
      |> Enum.map(fn v ->
        neighbors =
          Enum.filter(edges, fn {i, j} -> v == i || v == j end)
          |> Enum.map(fn {i, j} -> if v == i, do: j, else: i end)

        {v, neighbors}
      end)
      |> Map.new()

    adj = &Map.get(adj_map, &1)

    # Create connected component of vertex '0'
    component = dfs(adj, 0, MapSet.new())
    # Graph is connected iff component of '0' is same size as the graph
    MapSet.size(component) == num_vertices
  end
end
