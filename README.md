# StringMatcher

This library allows you to pass multiple regular expressions and a string and get values back.

## Example

Let's say you have a text that is:

```
Del 5 av 6. Shakespeare är mycket nöjd med sin senaste pjäs, Så tuktas en argbigga. Men av någon anledning uppskattas inte berättelsen om hur en stark kvinna förnedras av en man av kvinnorna i Shakespeares närhet.

Originaltitel: Upstart Crow.
Produktion: BBC 2017.
```

First we would split the text into an array based on `\n` and `.` so that we can loop over the long text, as our matches only returns the first match back.

Then you would do:

```elixir
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
```

This should return a tuple with a map. The map is returned value of the regular expressions.
If no match is found you will receive `{:error, "no match"}`

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `string_matcher` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:string_matcher, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/string_matcher](https://hexdocs.pm/string_matcher).

## Tests

Currently the tests are failing for some reason, the library is working though and is stable.
It's used in production.
