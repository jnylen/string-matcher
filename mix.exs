defmodule StringMatcher.MixProject do
  use Mix.Project

  @name :string_matcher
  @version "0.1.1"
  @deps [
    {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
  ]
  @description "StringMatcher allows you to pass multiple regular expressions and a string and get values back."

  def project do
    [
      app: @name,
      version: @version,
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: @deps,
      package: package(),
      description: @description,
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp docs do
    [
      source_ref: "master",
      main: "StringMatcher",
      canonical: "http://hexdocs.pm/string_matcher",
      source_url: "https://gitlab.com/jnylen/string-matcher",
      extras: [
        "README.md"
      ]
    ]
  end

  defp package() do
    [
      # This option is only needed when you don't want to use the OTP application name
      name: "string_matcher",
      # These are the default files included in the package
      files: ~w(lib .formatter.exs mix.exs README* LICENSE*),
      licenses: ["MIT"],
      links: %{"GitLab" => "https://gitlab.com/jnylen/string-matcher"}
    ]
  end
end
