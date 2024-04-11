defmodule SFFoodTrucksWeb.Router do
  use SFFoodTrucksWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {SFFoodTrucksWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_cookies
  end

  scope "/api", SFFoodTrucksWeb, as: :api do
    pipe_through :api

    get "/vendors", VendorController, :index
    get "/vendors/:id", VendorController, :show
    post "/vendors", VendorController, :create
    put "/vendors/update", VendorController, :update
    delete "/vendors/:id", VendorController, :delete
  end

  scope "/", SFFoodTrucksWeb do
    pipe_through :browser

    get "/", PageController, :home

    live "/vendors", VendorLive.Index, :index
    live "/vendors/new", VendorLive.Index, :new
    live "/vendors/:id/edit", VendorLive.Index, :edit

    live "/vendors/:id", VendorLive.Show, :show
    live "/vendors/:id/show/edit", VendorLive.Show, :edit
  end

  scope "/api", SFFoodTrucksWeb do
    pipe_through :api

    resources "/vendors", VendorController, except: [:new, :edit]
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:sf_food_trucks, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: SFFoodTrucksWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
