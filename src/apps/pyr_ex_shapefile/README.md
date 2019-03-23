# PYRExShapefile

Read and parse shapefiles.

### TODO: Write script to programmatically download shapefiles.

This works.

```elixir
path = "shp/cb_2017_05_sldu_500k.zip"
url = "http://www2.census.gov/geo/tiger/GENZ2017/#{path}"

body = HTTPoison.get!(url, [], follow_redirect: true, max_redirects: 1).body

File.write!(path, body)
```

We need to determine the naming conventions for the shapefile types we consume to predict filenames and paths of future updates.