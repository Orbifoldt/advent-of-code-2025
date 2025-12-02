defmodule FileUtil do
  def read_lines(path) do
    Path.join([:code.priv_dir(:aoc2025), path])
    |> File.stream!()
    |> Stream.map(&String.trim/1)
  end
end
