defmodule StringMatcher.MixProject do
  use Mix.Project

  @name :string_matcher
  @version "0.1.0"
  @deps []

  def project do
    [
      app: @name,
      version: @version,
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: @deps
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end
end
