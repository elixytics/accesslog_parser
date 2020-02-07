# credo:disable-for-this-file Credo.Check.Readability.MaxLineLength
defmodule AccessLogParserTest do
  use ExUnit.Case, async: true

  test ":common" do
    assert AccessLogParser.parse(
             ~s(1.2.3.4 - someuser [22/Apr/2017:15:17:39 +0200] "GET / HTTP/1.0" 200 765),
             :common
           ) ==
             %{
               "date" => "22/Apr/2017:15:17:39",
               "ip" => "1.2.3.4",
               "length" => 765,
               "path" => "/",
               "status" => 200,
               "timezone" => "+0200",
               "userid" => "someuser"
             }
  end

  test ":common_complete" do
    assert AccessLogParser.parse(
             ~s(www.example.com 1.2.3.4 - someuser [22/Apr/2017:15:17:39 +0200] "GET / HTTP/1.0" 200 765 "-" "Mozilla/5.0 \(X11; Linux x86_64\) AppleWebKit/535.11 \(KHTML, like Gecko\) Chrome/17.0.963.56 Safari/535.11"),
             :common_complete
           ) ==
             %{
               "date" => "22/Apr/2017:15:17:39",
               "host" => "www.example.com",
               "ip" => "1.2.3.4",
               "length" => "765",
               "path" => "/",
               "referrer" => "-",
               "status" => "200",
               "timezone" => "+0200",
               "user_agent" =>
                 "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/535.11 (KHTML, like Gecko) Chrome/17.0.963.56 Safari/535.11",
               "userid" => "someuser"
             }
  end

  test ":common_vhost" do
    assert AccessLogParser.parse(
             ~s(www.example.com 1.2.3.4 - someuser [22/Apr/2017:15:17:39 +0200] "GET / HTTP/1.0" 200 765),
             :common_vhost
           ) ==
             %{
               "date" => "22/Apr/2017:15:17:39",
               "host" => "www.example.com",
               "ip" => "1.2.3.4",
               "length" => "765",
               "path" => "/",
               "status" => "200",
               "timezone" => "+0200",
               "userid" => "someuser"
             }
  end

  test ":extended" do
    assert AccessLogParser.parse(
             ~s(1.2.3.4 - someuser [22/Apr/2017:15:17:39 +0200] "GET / HTTP/1.0" 200 765 "-" "Mozilla/5.0 \(X11; Linux x86_64\) AppleWebKit/535.11 \(KHTML, like Gecko\) Chrome/17.0.963.56 Safari/535.11"),
             :extended
           ) ==
             %{
               "date" => "22/Apr/2017:15:17:39",
               "ip" => "1.2.3.4",
               "length" => "765",
               "path" => "/",
               "referrer" => "-",
               "status" => "200",
               "timezone" => "+0200",
               "user_agent" =>
                 "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/535.11 (KHTML, like Gecko) Chrome/17.0.963.56 Safari/535.11",
               "userid" => "someuser"
             }
  end
end
