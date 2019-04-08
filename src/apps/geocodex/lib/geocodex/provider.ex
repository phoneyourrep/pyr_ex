defmodule Geocodex.Provider do
  @moduledoc """
  A behaviour for geocoder service providers.

  You can implement the behaviour by using it in a module:

      defmodule MyApp.Provider do
        use Geocodex.Provider
      end

  The following options are available to the `use` line:

    * `:base_url` - The base url of the geocoding service
    * `:default_params` - The default params that should be added to every request.
    * `:default_headers` - The default headers that should be added to every request.

  Here's an example from `Geocodex.Provider.USCB`:

        use Geocodex.Provider,
          base_url: "https://geocoding.geo.census.gov/geocoder/locations/onelineaddress",
          default_headers: [{"Accept", "application/json"}],
          default_params: [benchmark: "Public_AR_Current"]

  """

  @type address :: Geocodex.address()
  @type coordinates :: Geocodex.coordinates()

  @doc """
  Invoked to geocode an address into x/y coordinates
  """
  @callback coordinates(address) :: {:ok, coordinates}

  @doc false
  defmacro __using__(opts) do
    quote location: :keep, bind_quoted: [opts: opts] do
      use HTTPoison.Base

      @behaviour Geocodex.Provider

      @base_url Keyword.get(opts, :base_url, "")
      @default_headers Keyword.get(opts, :default_headers, [])
      @default_params Keyword.get(opts, :default_params, [])

      @doc false
      def process_request_url(url) do
        @base_url <> url
      end

      @doc false
      def process_request_headers(headers) do
        @default_headers ++ headers
      end

      @doc false
      def process_request_options(options) do
        update_in(options, [:params], fn x -> Keyword.merge(x, @default_params) end)
      end
    end
  end
end
