defmodule AccessLogParser do
  @moduledoc """
  Parses access log lines.
  """

  @tpl_client ~S/\s+"(?P<referrer>.*?)"\s+"(?P<user_agent>.*?)"/
  @tpl_common ~S/(?P<ip>\S+)\s+\S+\s+(?P<userid>\S+)\s+\[(?P<date>.*?)\s+(?P<timezone>.*?)\]\s+"\S+\s+(?P<path>.*?)\s+\S+"\s+(?P<status>\S+)\s+(?P<length>\S+)/
  @tpl_vhost  ~S/(?P<host>[\w\-\.]*)(?::\d+)?\s+/

  @re_common          Regex.compile!(@tpl_common)
  @re_common_complete Regex.compile!(@tpl_vhost <> @tpl_common <> @tpl_client)
  @re_common_vhost    Regex.compile!(@tpl_vhost <> @tpl_common)
  @re_extended        Regex.compile!(@tpl_common <> @tpl_client)

  @doc """
  Converts a given line into a map matching the defined format.

  ## Examples

      iex> parse(~s(1.2.3.4 - someuser [22/Apr/2017:15:17:39 +0200] "GET / HTTP/1.0" 200 765), :common)
      %{
        "date"     => "22/Apr/2017:15:17:39",
        "ip"       => "1.2.3.4",
        "length"   => "765",
        "path"     => "/",
        "status"   => "200",
        "timezone" => "+0200",
        "userid"   => "someuser"
      }

      iex> parse(~s(www.example.com 1.2.3.4 - someuser [22/Apr/2017:15:17:39 +0200] "GET / HTTP/1.0" 200 765), :common_vhost)
      %{
        "date"     => "22/Apr/2017:15:17:39",
        "host"     => "www.example.com",
        "ip"       => "1.2.3.4",
        "length"   => "765",
        "path"     => "/",
        "status"   => "200",
        "timezone" => "+0200",
        "userid"   => "someuser"
      }

      iex> parse(~s(1.2.3.4 - someuser [22/Apr/2017:15:17:39 +0200] "GET / HTTP/1.0" 200 765 "-" "Mozilla/5.0 \\(X11; Linux x86_64\\) AppleWebKit/535.11 \\(KHTML, like Gecko\\) Chrome/17.0.963.56 Safari/535.11"), :extended)
      %{
        "date"       => "22/Apr/2017:15:17:39",
        "ip"         => "1.2.3.4",
        "length"     => "765",
        "path"       => "/",
        "referrer"   => "-",
        "status"     => "200",
        "timezone"   => "+0200",
        "user_agent" => "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/535.11 (KHTML, like Gecko) Chrome/17.0.963.56 Safari/535.11",
        "userid"     => "someuser"
      }

      iex> parse(~s(www.example.com 1.2.3.4 - someuser [22/Apr/2017:15:17:39 +0200] "GET / HTTP/1.0" 200 765 "-" "Mozilla/5.0 \\(X11; Linux x86_64\\) AppleWebKit/535.11 \\(KHTML, like Gecko\\) Chrome/17.0.963.56 Safari/535.11"), :common_complete)
      %{
        "date"       => "22/Apr/2017:15:17:39",
        "host"       => "www.example.com",
        "ip"         => "1.2.3.4",
        "length"     => "765",
        "path"       => "/",
        "referrer"   => "-",
        "status"     => "200",
        "timezone"   => "+0200",
        "user_agent" => "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/535.11 (KHTML, like Gecko) Chrome/17.0.963.56 Safari/535.11",
        "userid"     => "someuser"
      }
  """
  @spec parse(String.t, atom) :: map
  def parse(line, :common),          do: Regex.named_captures(@re_common, line)
  def parse(line, :common_complete), do: Regex.named_captures(@re_common_complete, line)
  def parse(line, :common_vhost),    do: Regex.named_captures(@re_common_vhost, line)
  def parse(line, :extended),        do: Regex.named_captures(@re_extended, line)
end
