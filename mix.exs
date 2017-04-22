defmodule AccessLogParser.Mixfile do
  use Mix.Project

  def project do
    [app:     :accesslog_parser,
     version: "0.1.0-dev",
     elixir:  "~> 1.4",

     build_embedded:  Mix.env == :prod,
     start_permanent: Mix.env == :prod]
  end
end
