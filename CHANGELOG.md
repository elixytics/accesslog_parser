# Changelog

## v0.3.0-dev

- Enhancements
    - NCSA extended/combined log format can be parsed using either `:combined` or `:extended` format specifiers

- Backwards incompatible changes
    - Minimum required Elixir version is now `~> 1.9`

## v0.2.0 (2020-02-21)

- Enhancements
    - Parsing is now done using `NimbleParsec` instead of regular expressions. As a result the parser is more strict (e.g. one space between log parts instead of one-or-more) and purely numeric values like response length or status code are now returned as integers. The result map now also has atom instead of binary keys.

- Backwards incompatible changes
    - Minimum required Elixir version is now `~> 1.7`

## v0.1.0 (2017-04-28)

- Initial Release
