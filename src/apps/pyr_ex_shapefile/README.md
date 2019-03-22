# PYRExShapefile

Read and parse shapefiles.

### TODO: Write script to programmatically download shapefiles.

Something like this should work:

```elixir
path = "shp/cb_2017_05_sldu_500k.zip"
url = 'http://www2.census.gov/geo/tiger/GENZ2017/#{path}'

Application.ensure_all_started :inets

{:ok, resp} = :httpc.request(:get, {url, []}, [], [body_format: :binary])
{{_, 200, 'OK'}, _headers, body} = resp

File.write!(path, body)
```