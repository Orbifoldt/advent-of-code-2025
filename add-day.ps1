param([Int32]$day) 

$day_string = 'day{0:D2}' -f $day
$capital_day_string = 'Day{0:D2}' -f $day

# Create input file
pushd
cd .\priv
touch "$day_string.txt"
popd

# Create the solution and unit test .ex files
pushd
cd .\lib

touch "$day_string.ex"
$solutionTemplate = @"
defmodule $capital_day_string do
  def part1() do
    FileUtil.read_lines("$day_string.txt")
    |> Enum.to_list()
    |> part1
  end

  @doc """
  ##
  iex> $capital_day_string.part1(["..."])
  3
  """
  def part1(data) do
    data
  end

  def part2() do
    FileUtil.read_lines("$day_string.txt")
    |> Enum.to_list()
    |> part2
  end

  @doc """
  ##
  iex> $capital_day_string.part2(["..."])
  0
  """
  def part2(data) do
    data
  end
end

"@ 
$solutionTemplate | Out-File -FilePath "$day_string.ex"

popd
pushd
cd .\test
touch "${day_string}_test.exs"
$testTemplate = @"
defmodule ${capital_day_string}Test do
  use ExUnit.Case
  doctest $capital_day_string
end
"@ 
$testTemplate | Out-File -FilePath "${day_string}_test.exs"

popd