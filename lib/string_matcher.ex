defmodule StringMatcher do
  @moduledoc ~S"""
  StringMatcher allows you to pass multiple regular expressions and a string and get values back.

  ## Example

  Let's say you have a text that is:

  ```
  Del 5 av 6. Shakespeare är mycket nöjd med sin senaste pjäs, Så tuktas en argbigga. Men av någon anledning uppskattas inte berättelsen om hur en stark kvinna förnedras av en man av kvinnorna i Shakespeares närhet.

  Originaltitel: Upstart Crow.
  Produktion: BBC 2017.
  ```

  First we would split the text into an array based on `\n` and `.` so that we can loop over the long text, as our matches only returns the first match back.

  Then you would do:

  ```
  StringMatcher.new()
  |> StringMatcher.add_regexp(~r/Del\s+(?<episode_num>[0-9]+?)\s+av\s+(?<of_episodes>[0-9]+?)/i,  %{})
  |> StringMatcher.add_regexp(~r/Originaltitel:\s+(?<original_title>.*?)/i,  %{})
  |> StringMatcher.add_regexp(~r/Produktion:\s+(?<producer>.*?) (?<episode_num>[0-9]+?)/i,  %{})
  |> StringMatcher.match_captures(string)
  ```

  This should return a tuple with a map. The map is returned value of the regular expressions.
  If no match is found you will receive `{:error, "no match"}`
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
