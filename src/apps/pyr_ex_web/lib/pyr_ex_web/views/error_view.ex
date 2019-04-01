defmodule PYRExWeb.ErrorView do
  use PYRExWeb, :view

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  # def render("500.json", _assigns) do
  #   %{errors: %{detail: "Internal Server Error"}}
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".
  def template_not_found("404.json" = template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end

  def template_not_found("500.json" = template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end

  def template_not_found(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end

  def render("invalid_key.json", %{key: key}) do
    %{errors: %{detail: "Invalid API key: #{key}"}}
  end

  def render("no_key.json", _assigns) do
    %{errors: %{detail: "API key required"}}
  end
end
