defmodule LiveViewStudioWeb.CountdownTimer do
  use LiveViewStudioWeb, :live_view


  def mount(_params, _session, socket) do
    if connected?(socket) do
      :timer.send_interval(1000, self(), :tick)
    end

    expiration_time = Timex.shift(Timex.now(), hours: 1)

    socket =
      assign(socket,
        expiration_time: expiration_time,
        time_remaining: time_remaining(expiration_time)
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <p>
      <%= if @time_remaining >= 0  do %>
        <%= format_time(@time_remaining) %>
      <% else %>
        Expired!!
      <% end %>
    </p>
    """
  end

  def handle_info(:tick, socket) do
    expiration_time = socket.assigns.expiration_time
    socket =
      assign(socket,
        time_remaining: time_remaining(expiration_time)
      )
      {:noreply, socket}
  end

  defp time_remaining(expiration_time) do
    DateTime.diff(expiration_time, Timex.now())
  end

  defp format_time(time) do
    time
    |> Timex.Duration.from_seconds()
    |> Timex.format_duration(:humanized)
  end
end
