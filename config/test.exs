import Config

# Only in tests, remove the complexity from the password hashing algorithm
config :bcrypt_elixir, :log_rounds, 1

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :sf_food_trucks, SFFoodTrucks.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "sf_food_trucks_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :sf_food_trucks, SFFoodTrucksWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "1A/YX2vRFbTgnjAKC0NQTz4MIF364xFk1pB762rr02abNW60Z3gaQwtQbx4Frpx4",
  server: false

config :sf_food_trucks, Oban, testing: :inline

# In test we don't send emails.
config :sf_food_trucks, SFFoodTrucks.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
