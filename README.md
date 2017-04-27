# Access Log Parser

## Setup

Add the library as a dependency to your `mix.exs` file:

```elixir
defp deps do
  [{ :accesslog_parser, "~> 0.1" }]
end
```

You should also update your applications to include all necessary projects:

```elixir
def application do
  [ applications: [ :accesslog_parser ]]
end
```


## Usage

Grab a line from your accesslog and parse it using `AccessLogParser.parse/2`.

See the module itself for details on supported formats and arguments.


## License

[Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0)
