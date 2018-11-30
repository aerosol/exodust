# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Customize non-Elixir parts of the firmware. See
# https://hexdocs.pm/nerves/advanced-configuration.html for details.

config :nerves, :firmware, rootfs_overlay: "rootfs_overlay"

# Use shoehorn to start the main application. See the shoehorn
# docs for separating out critical OTP applications such as those
# involved with firmware updates.

config :shoehorn,
  init: [:nerves_runtime, :nerves_init_gadget],
  app: Mix.Project.config()[:app]

config :nerves_firmware_ssh,
authorized_keys: [
  File.read!(Path.join(System.user_home!, ".ssh/id_rsa.pub"))
]

key_mgmt = System.get_env("NERVES_NETWORK_KEY_MGMT") || "WPA-PSK"

config :nerves_network, :default,
  wlan0: [
    ssid: String.trim(File.read!(Path.join(System.user_home!, ".exodust_ssid"))),
    psk: String.trim(File.read!(Path.join(System.user_home!, ".exodust_psk"))),
    key_mgmt: String.to_atom(key_mgmt)
  ],
  eth0: [
    ipv4_address_method: :dhcp
  ]

# Use Ringlogger as the logger backend and remove :console.
# See https://hexdocs.pm/ring_logger/readme.html for more information on
# configuring ring_logger.

config :logger, 
  backends: [RingLogger, :console]

# Configures the endpoint
config :ui, UiWeb.Endpoint,
  url: [host: "localhost"],
  http: [port: 4000],
  debug_errors: true,
  server: true,
  code_reloader: true,
  secret_key_base: "mjI6jctBDtEoGKb8UdcHM1+/YWr4WomQ/3Er5UQJoNC0/KT3fQv1pc8LD/+3kIfb",
  render_errors: [view: UiWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Ui.PubSub, adapter: Phoenix.PubSub.PG2],
  watchers: [
    node: [
      "node_modules/webpack/bin/webpack.js",
      "--mode",
      "development",
      "--watch-stdin",
      cd: Path.expand("../../ui/assets", __DIR__)
    ]
  ]

config :ui, UiWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{lib/ui_web/views/.*(ex)$},
      ~r{lib/ui_web/templates/.*(eex)$}
    ]
  ]

config :phoenix, :stacktrace_depth, 20
config :phoenix, :plug_init_mode, :runtime

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason
