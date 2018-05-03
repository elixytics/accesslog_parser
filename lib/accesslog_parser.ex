defmodule AccessLogParser do
  @moduledoc """
  Parses access log lines matching a given (known) format.

  ## Usage

  You simply call the parse method with your log line and the format it adheres to:

      iex> AccessLogParser.parse("1.2.3.4 - - [22/Apr/2017:15:17:39 +0200] "GET / HTTP/1.0" 200 765", :common)
      %{
        "date" => "22/Apr/2017:15:17:39",
        "ip" => "1.2.3.4",
        "length" => "765",
        "path" => "/",
        "status" => "200",
        "timezone" => "+0200",
        "userid" => "-"
      }

  ## Formats

  ### Common Log Format (CLF)

  - `:common`
  - Apache configuration: `%h %l %u %t \\"%r\\" %>s %b`

  ### CLF with Virtual Host and Client

  - `:common_complete`
  - Apache configuration: `%v %h %l %u %t \\"%r\\" %>s %b \\"%{Referer}i\\" \\"%{User-agent}i\\"`

  ### CLF with Virtual Host

  - `:common_vhost`
  - Apache configuration: `%v %h %l %u %t \\"%r\\" %>s %b`

  ### NCSA extended/combined log format

  - `:extended`
  - Apache configuration: `%h %l %u %t \\"%r\\" %>s %b \\"%{Referer}i\\" \\"%{User-agent}i\\"`
  """

  @tpl_client ~S/\s+"(?P<referrer>.*?)"\s+"(?P<user_agent>.*?)"/
  @tpl_common ~S/(?P<ip>\S+)\s+\S+\s+(?P<userid>\S+)\s+\[(?P<date>.*?)\s+(?P<timezone>.*?)\]\s+"\S+\s+(?P<path>.*?)\s+\S+"\s+(?P<status>\S+)\s+(?P<length>\S+)/
  @tpl_vhost ~S/(?P<host>[\w\-\.]*)(?::\d+)?\s+/

  @re_common Regex.compile!(@tpl_common)
  @re_common_complete Regex.compile!(@tpl_vhost <> @tpl_common <> @tpl_client)
  @re_common_vhost Regex.compile!(@tpl_vhost <> @tpl_common)
  @re_extended Regex.compile!(@tpl_common <> @tpl_client)

  @type log_format :: :common | :common_complete | :common_vhost | :extended

  @doc """
  Converts a given line into a map matching the defined format.
  """
  @spec parse(String.t(), log_format) :: map
  def parse(line, :common), do: Regex.named_captures(@re_common, line)
  def parse(line, :common_complete), do: Regex.named_captures(@re_common_complete, line)
  def parse(line, :common_vhost), do: Regex.named_captures(@re_common_vhost, line)
  def parse(line, :extended), do: Regex.named_captures(@re_extended, line)
end
