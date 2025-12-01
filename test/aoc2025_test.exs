defmodule Aoc2025Test do
  use ExUnit.Case
  doctest Aoc2025

  test "greets the world" do
    assert Aoc2025.hello() == :world
  end

  test "two too" do
    assert Aoc2025.hello2() == :two
  end
end
