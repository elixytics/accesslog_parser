# Changelog

## v0.2.0-dev

- Enhancements
    - Parsing is now done using `NimbleParsec` instead of regular expressions. As a result the parser is more strict (e.g. one space between log parts instead of one-or-more) and purely numeric values like response length or status code are now returned as integers.

- Backwards incompatible changes
    - Minimum required Elixir version is now `~> 1.7`

## v0.1.0 (2017-04-28)

- Initial Release
