# ConMon

This is a Elixir Nerves application to monitor and log Internet downtime by pinging a list of hosts.

## Prerequisites
- Elixir
- Nerves

## Targets

Nerves applications produce images for hardware targets based on the
`MIX_TARGET` environment variable. If `MIX_TARGET` is unset, `mix` builds an
image that runs on the host (e.g., your laptop). This is useful for executing
logic tests, running utilities, and debugging. Other targets are represented by
a short name like `rpi3` that maps to a Nerves system image for that platform.
All of this logic is in the generated `mix.exs` and may be customized. For more
information about targets see:

https://hexdocs.pm/nerves/targets.html#content

## Getting Started
- Clone repository

- To start your Nerves app:
  * `export MIX_TARGET=my_target` or prefix every command with
    `MIX_TARGET=my_target`. For example, `MIX_TARGET=rpi3`
  * Install dependencies with `mix deps.get`
  * Create firmware with `mix firmware`
  * Burn to an SD card with `mix firmware.burn`
  * OR run on host with `iex -S mix`

- To ssh to the pi and access console on your local network you can run: `ssh con_mon.local`
- To check logs: Run `ConMon.StateServer.get_state` in the iex console


### Note
After ssh use this to auth pi with firewall
```
a = "{\"user\":\"USERNAME\",\"submit\":\"Login\",\"passwd\":\"PASSWORD\",\"actualUrl\":\"8.8.8.8\"}"
:hackney.post("http://172.16.1.254/userSense", [], a, [])
```
After update this is the new way to auth:
```
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
url= "http://172.16.1.254/userSense?user=USERNAME&passwd=PASSWORD&otp=&submit=Login&actualurl=http%3A%2F%2F8.8.8.8%2F"
:hackney.post(url, headers, [], []) 
```

## Contributors:
- [Aaron Colaco](http://aaroncolaco.com)

## License:
MIT