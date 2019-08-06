defmodule StringMatcher do
  @moduledoc """
  Documentation for StringMatcher.
  """

  @doc """
  Create a new list for strings

  Returns `[]`

  ## Examples

      iex> StringMatcher.new()
      []

  """
  def new do
    []
  end

  @doc """
  Add a regexp to the list if its the correct format.

  Returns a list of regular expressions.

  ## Examples

    iex> StringMatcher.add_regexp([], ~r/S(?<season_num>\d+)E(?<episode_num>\d+)/i, %{})
    [{~r/S(?<season_num>\d+)E(?<episode_num>\d+)/i, %{}}]

  """
  def add_regexp(list, %Regex{} = regexp, result) when is_list(list) and is_map(result) do
    list
    |> Enum.concat([{regexp, result}])
  end

  def add_regexp(_, _, _), do: {:error, "wrong format"}

  @doc """
  Match a string to a regexp.

  Returns the values that are passed as the second argument.

  ## Examples

      iex> StringMatcher.add_regexp([], ~r/S(?<season_num>\d+)E(?<episode_num>\d+)/i, %{}) |> StringMatcher.match("Prison Break E01")
      {:error, "no match"}

      iex> StringMatcher.add_regexp([], ~r/S(?<season_num>\d+)E(?<episode_num>\d+)/i, %{}) |> StringMatcher.match_captures("Prison Break S01E01")
      {:ok, %{"episode_num" => "01", "season_num" => "01"}}

      iex> StringMatcher.add_regexp([], ~r/S(?<season_num>\d+)E(?<episode_num>\d+)/i, %{"name" => "Fargo"}) |> StringMatcher.match("Prison Break S01E01")
      {:ok, %{"name" => "Fargo"}}
  """
  def match(list, string) when is_list(list) and is_binary(string) do
    Enum.reduce(list, nil, fn
      {regexp, result}, nil ->
        if Regex.match?(regexp, string) do
          {:ok, result}
        end

      _, matched ->
        matched
    end)
    |> case do
      {:ok, result} -> {:ok, result}
      _ -> {:error, "no match"}
    end
  end

  def match(_, _), do: {:error, "wrong format"}

  @doc """
  Match a string to a regexp.

  Returns either the values passed as the second argument otherwise it returns the captures.

  ## Examples

      iex> StringMatcher.add_regexp([], ~r/S(?<season_num>\d+)E(?<episode_num>\d+)/i, %{}) |> StringMatcher.match_captures("Prison Break S01E01")
      {:ok, %{"episode_num" => "01", "season_num" => "01"}}

      iex> StringMatcher.add_regexp([], ~r/S(?<season_num>\d+)E(?<episode_num>\d+)/i, %{"name" => "Fargo"}) |> StringMatcher.match_captures("Prison Break S01E01")
      {:ok, %{"name" => "Fargo"}}
  """
  def match_captures(list, string) when is_list(list) and is_binary(string) do
    Enum.reduce(list, nil, fn
      {regexp, result2}, nil ->
        if Regex.match?(regexp, string) do
          empty?(result2, regexp, string)
        end

      _, matched ->
        matched
    end)
    |> case do
      {:ok, result} -> {:ok, result}
      _ -> {:error, "no match"}
    end
  end

  def match_captures(_, _), do: {:error, "wrong format"}

  defp empty?(result, regexp, string) do
    if Enum.empty?(result) do
      {:ok, Regex.named_captures(regexp, string)}
    else
      {:ok, result}
    end
  end
end
