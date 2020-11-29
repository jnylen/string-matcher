defmodule StringMatcherTest do
  use ExUnit.Case

  test "returns an empty list" do
    assert StringMatcher.new() === []
  end

  test "adding a regex returns a list of regex" do
    # assert StringMatcher.add_regexp([], ~r/S(?<season_num>\d+)E(?<episode_num>\d+)/i, %{}) === [
    #          {~r/S(?<season_num>\d+)E(?<episode_num>\d+)/i, %{}}
    #        ]
  end

  test "can parse a long string" do
    string = """
    Del 5 av 6. Shakespeare är mycket nöjd med sin senaste pjäs, Så tuktas en argbigga. Men av någon anledning uppskattas inte berättelsen om hur en stark kvinna förnedras av en man av kvinnorna i Shakespeares närhet.\n
    \n
    Originaltitel: Upstart Crow.\n
    Produktion: BBC 2017.
    """

    ## Lets run through the splitted string and capture the wanted details
    ## and then merge them into a single map.
    result =
      String.split(string, "\n")
      |> Enum.map(fn string ->
        StringMatcher.new()
        |> StringMatcher.add_regexp(
          ~r/Del\s+(?<episode_num>[0-9]+?)\s+av\s+(?<of_episodes>[0-9]+?)/i,
          %{}
        )
        |> StringMatcher.add_regexp(~r/Originaltitel: (?<original_title>.*)\./i, %{})
        |> StringMatcher.add_regexp(
          ~r/Produktion: (?<production_company>.*?) (?<production_year>[0-9]+)\./i,
          %{}
        )
        |> StringMatcher.match_captures(string)
        |> case do
          {:ok, map} -> map
          _ -> %{}
        end
      end)
      |> Enum.reduce(%{}, &Map.merge/2)

    assert result === %{
             "episode_num" => "5",
             "of_episodes" => "6",
             "original_title" => "Upstart Crow",
             "production_company" => "BBC",
             "production_year" => "2017"
           }
  end

  test "can parse with a single regex" do
    result =
      StringMatcher.new()
      |> StringMatcher.add_regexp(~r/S(?<season_num>\d+)E(?<episode_num>\d+)/i, %{})
      |> StringMatcher.match("Prison Break E01")

    assert result === {:error, "no match"}
  end

  test "can match captures with a single regex" do
    result =
      StringMatcher.new()
      |> StringMatcher.add_regexp(~r/S(?<season_num>\d+)E(?<episode_num>\d+)/i, %{})
      |> StringMatcher.match_captures("Prison Break S01E01")

    assert result === {:ok, %{"episode_num" => "01", "season_num" => "01"}}
  end

  test "returns the custom specified value" do
    result =
      StringMatcher.new()
      |> StringMatcher.add_regexp(~r/S(?<season_num>\d+)E(?<episode_num>\d+)/i, %{
        "name" => "Fargo"
      })
      |> StringMatcher.match("Prison Break S01E01")

    assert result === {:ok, %{"name" => "Fargo"}}
  end

  test "can capture matchings" do
    result =
      StringMatcher.new()
      |> StringMatcher.add_regexp(~r/S(?<season_num>\d+)E(?<episode_num>\d+)/i, %{})
      |> StringMatcher.match_captures("Prison Break S01E01")

    assert result === {:ok, %{"episode_num" => "01", "season_num" => "01"}}
  end

  test "if passing a custom value to match captures we use the custom value" do
    result =
      StringMatcher.new()
      |> StringMatcher.add_regexp(~r/S(?<season_num>\d+)E(?<episode_num>\d+)/i, %{
        "name" => "Fargo"
      })
      |> StringMatcher.match_captures("Prison Break S01E01")

    assert result === {:ok, %{"name" => "Fargo"}}
  end
end
