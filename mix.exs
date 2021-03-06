defmodule ConMon.MixProject do
  use Mix.Project

  @app :con_mon
  @all_targets [:rpi3]

  def project do
    [
      app: @app,
      version: "0.1.0",
      elixir: "~> 1.8",
      archives: [nerves_bootstrap: "~> 1.8"],
      start_permanent: Mix.env() == :prod,
      build_embedded: true,
      aliases: [loadconfig: [&bootstrap/1]],
      preferred_cli_target: [run: :host, test: :host],
      releases: [{@app, release()}],
      deps: deps()
    ]
  end

  def release do
    [
      overwrite: true,
      cookie: "#{@app}_cookie",
      include_erts: &Nerves.Release.erts/0,
      steps: [&Nerves.Release.init/1, :assemble],
      strip_beams: Mix.env() == :prod
    ]
  end

  # Starting nerves_bootstrap adds the required aliases to Mix.Project.config()
  # Aliases are only added if MIX_TARGET is set.
  def bootstrap(args) do
    Application.start(:nerves_bootstrap)
    Mix.Task.run("loadconfig", args)
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {ConMon.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # Dependencies for all targets
      {:nerves, "~> 1.6.3", runtime: false},
      {:shoehorn, "~> 0.6"},
      {:ring_logger, "~> 0.8"},
      {:toolshed, "~> 0.2"},
      {:hackney, "~> 1.15.1"},
      {:poison, "~> 4.0"},
      {:plug_cowboy, "~> 2.2.1"},
      {:httpoison, "~> 1.6"},

      # Dependencies for all targets except :host
      {:nerves_runtime, "~> 0.11.1", targets: @all_targets},
      {:nerves_init_gadget, "~> 0.7", targets: @all_targets},
      {:nerves_time, "~> 0.4.1", targets: @all_targets},

      # Dependencies for specific targets
      {:nerves_system_rpi3, "~> 1.11.1", runtime: false, targets: :rpi3}
    ]
  end
end
