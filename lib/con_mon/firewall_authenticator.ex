defmodule ConMon.FirewallAuthenticator do
  @username "aaron"
  @password "123456"

  def authenticate do
    headers = [
      {"Host", "172.16.1.254"},
      {"Connection", "keep-alive"},
      {"Content-Length", "76"},
      {"Cache-Control", "max-age=0"},
      {"Origin", "http://8.8.8.8"},
      {"Upgrade-Insecure-Requests", "1"},
      {"Content-Type", "application/x-www-form-urlencoded"},
      {"User-Agent",
       "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.100 Safari/537.36"},
      {"Accept",
       "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3"},
      {"Referer", "http://8.8.8.8/"},
      {"Accept-Encoding", "gzip, deflate"},
      {"Accept-Language", "en-US,en;q=0.9"}
    ]

    passwd = "passwd=#{@password}"
    user = "&user=#{@username}"
    meta = "&otp=&submit=Login&actualurl=http%3A%2F%2F8.8.8.8%2F&userdelete=yes"
    data = passwd <> user <> meta

    url = "http://172.16.1.254/userSense"

    HTTPoison.post(url, data, headers)

    Process.sleep(3000)
  end
end
