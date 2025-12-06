defmodule Util do
  @doc """
  Parse numeric prefix of string to integer, or raise if not a numeric string
  ##
  iex> Util.parse_int!("123")
  123
  """
  def parse_int!(str), do: elem(Integer.parse(str), 0)

  @doc """
  Transpose an enumerable of enumerables
  ##
  iex> Util.transpose([[1, 2, 3], [4, 5, 6]])
  [[1,4], [2,5], [3,6]]
  """
  def transpose(enum), do: Enum.zip_with(enum, & &1)
end
