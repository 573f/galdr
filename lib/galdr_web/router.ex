defmodule GaldrWeb.Router do
  use GaldrWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, html: {GaldrWeb.Layouts, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", GaldrWeb do
    pipe_through(:browser)

    # Make the root path go directly to notes index
    live("/", NoteLive.Index, :index)

    # Note routes
    live("/notes", NoteLive.Index, :index)
    live("/notes/new", NoteLive.Index, :new)
    live("/notes/:id/edit", NoteLive.Index, :edit)
    live("/notes/:id", NoteLive.Show, :show)
    live("/notes/:id/show/edit", NoteLive.Show, :edit)
  end

  # Other scopes may use custom stacks.
  # scope "/api", GaldrWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:galdr, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through(:browser)

      live_dashboard("/dashboard", metrics: GaldrWeb.Telemetry)
      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end
end
