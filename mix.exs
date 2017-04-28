defmodule AccessLogParser.Mixfile do
  use Mix.Project

  @url_github "https://github.com/elixytics/accesslog_parser"

  def project do
    [app:     :accesslog_parser,
     version: "0.1.0",
     elixir:  "~> 1.4",
     deps:    deps(),

     build_embedded:  Mix.env == :prod,
     start_permanent: Mix.env == :prod,

     preferred_cli_env: [
       coveralls:          :test,
       'coveralls.detail': :test,
       'coveralls.travis': :test
     ],

     description:   "Access Log Parser",
     docs:          docs(),
     package:       package(),
     test_coverage: [ tool: ExCoveralls ]]
  end

  defp deps do
    [{ :ex_doc,      ">= 0.0.0", only: :dev },
     { :excoveralls, "~> 0.6",   only: :test }]
  end

  defp docs do
    [extras:     [ "CHANGELOG.md", "README.md" ],
     main:       "readme",
     source_ref: "v0.1.0",
     source_url: @url_github]
  end

  defp package do
    %{files:       [ "CHANGELOG.md", "LICENSE", "mix.exs", "README.md", "lib" ],
      licenses:    [ "Apache 2.0" ],
      links:       %{ "GitHub" => @url_github },
      maintainers: [ "Marc Neudert" ]}
  end
end
