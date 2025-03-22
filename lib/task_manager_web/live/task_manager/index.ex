defmodule TaskManagerWeb.TaskManagerLive.Index do
  use TaskManagerWeb, :live_view

  @impl true
  def mount(_params, _sessions, socket) do
    {:ok, assign(socket, :hello, "Hello, World")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <p class="text-xl">{@hello}</p>
    """
  end
end
