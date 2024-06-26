# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :sf_food_trucks,
  ecto_repos: [SFFoodTrucks.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :sf_food_trucks, SFFoodTrucksWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: SFFoodTrucksWeb.ErrorHTML, json: SFFoodTrucksWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: SFFoodTrucks.PubSub,
  live_view: [signing_salt: "ETFhNTq1"]

# Configures Oban
config :sf_food_trucks, Oban,
  engine: Oban.Engines.Basic,
  queues: [default: 2],
  repo: SFFoodTrucks.Repo,
  plugins: [
    {Oban.Plugins.Pruner, max_age: 60 * 60 * 24 * 7},
    {Oban.Plugins.Cron,
     crontab: [
       {"@daily", SFFoodTrucks.Workers.FetchVendorsWorker, max_attempts: 2}
     ]}
  ]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :sf_food_trucks, SFFoodTrucks.Mailer, adapter: Swoosh.Adapters.Local

config :sf_food_trucks, :fetch_vendor_url, "https://data.sfgov.org/api/odata/v4/rqzj-sfat"

config :sf_food_trucks, :google_api_key, "<put google api key here>"

config :sf_food_trucks, :api_token, "<put api token here>"

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  sf_food_trucks: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.0",
  sf_food_trucks: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
