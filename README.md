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
iex(1)> logline = ~s(1.2.3.4 - - [22/Apr/2017:15:17:39 +0200] "GET / HTTP/1.0" 200 765)
iex(2)> logformat = :common
iex(3)> AccessLogParser.parse(logline, logformat)
%{
  date: "22/Apr/2017:15:17:39",
  ip: "1.2.3.4",
  length: 765,
  method: "GET",
  path: "/",
  protocol: "HTTP/1.0",
  status: 200,
  timezone: "+0200",
  userid: "-"
}
```

More details are available in the `AccessLogParser` module documentation.

## Benchmark

A (minimal) benchmark script is included. Please refer to the Mixfile or `mix help` output for the name.

## License

[Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0)
