# Access Log Parser

## Setup

Add the library as a dependency to your `mix.exs` file:

```elixir
defp deps do
  [
    # ...
    {:accesslog_parser, "~> 0.2.0"},
    # ...
  ]
end
```

## Usage

Grab a line from your accesslog and parse it using `AccessLogParser.parse/2`:

```elixir
logline = ~s(1.2.3.4 - - [22/Apr/2017:15:17:39 +0200] "GET / HTTP/1.0" 200 765)
logformat = :common

AccessLogParser.parse(logline, logformat)
```

More details are available in the `AccessLogParser` module documentation.

## Benchmark

A (minimal) benchmark script is included. Please refer to the Mixfile or `mix help` output for the name.

## License

[Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0)
