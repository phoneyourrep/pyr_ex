defmodule PYRExWeb.ErrorViewTest do
  use PYRExWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.json" do
    assert render(PYRExWeb.ErrorView, "404.json", []) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500.json" do
    assert render(PYRExWeb.ErrorView, "500.json", []) ==
             %{errors: %{detail: "Internal Server Error"}}
  end

  test "renders 404.html" do
    assert render(PYRExWeb.ErrorView, "404.html", []) == "Not Found"
  end

  test "renders 500.html" do
    assert render(PYRExWeb.ErrorView, "500.html", []) == "Internal Server Error"
  end
end
