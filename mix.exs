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
      deps: @deps,
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp package() do
    [
      # This option is only needed when you don't want to use the OTP application name
      name: "string_matcher",
      # These are the default files included in the package
      files: ~w(lib priv .formatter.exs mix.exs README* readme* LICENSE*
                license* CHANGELOG* changelog*),
      licenses: ["MIT"],
      links: %{"GitLab" => "https://gitlab.com/jnylen/string-matcher"}
    ]
  end
end
