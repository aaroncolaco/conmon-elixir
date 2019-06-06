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
a = "{\"user\":\"<username>\",\"submit\":\"Login\",\"passwd\":\"<password>\",\"actualUrl\":\"8.8.8.8\"}"
:hackney.post("http://172.16.1.254/userSense", [], a, [])
```

## Contributors:
- [Aaron Colaco](http://aaroncolaco.com)

## License:
MIT