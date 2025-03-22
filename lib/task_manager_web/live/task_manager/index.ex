defmodule TaskManagerWeb.TaskManagerLive.Index do
  use TaskManagerWeb, :live_view

  @impl true
  def mount(_params, _sessions, socket) do
    dummy_tasks = [
      %{id: 0, name: "Go to Mars", status: false},
      %{id: 1, name: "By a rocket", status: true},
      %{id: 2, name: "Clean your base", status: false}
    ]

    {:ok,
     socket
     |> assign(:tasks, dummy_tasks)
     |> assign(:form, to_form(%{"id" => 0, "name" => "", "status" => false}))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.task_input form={@form} />
    <.tasks_table tasks={@tasks} />
    """
  end

  attr :form, :string, required: true

  def task_input(assigns) do
    ~H"""
    <.simple_form for={@form} id="task-form" phx-submit="save">
      <.input field={@form[:name]} type="text" label="Task" />
    </.simple_form>
    """
  end

  attr :tasks, :list, required: true

  def tasks_table(assigns) do
    ~H"""
    <div class="mt-11">
      <div class="text-xl grid-cols-[3fr_1fr_0.5fr] grid grid-cols-3 gap-2 pt-2 pb-2 text-left text-zinc-500">
        <div class="auto-cols-max">Task</div>
        <div>status</div>
        <div></div>
      </div>
      <div
        :for={task <- @tasks}
        id={["task-", task.id]}
        class="text-lg grid grid-cols-3 grid-cols-[3fr_1fr_0.5fr] gap-2 pt-2 pb-2 hover:bg-zinc-50 border-t"
        phx-click={JS.push("toggle", value: %{id: task.id})}
      >
        <div>{task.name}</div>
        <div>{task.status}</div>
        <div>
          <.link phx-click={JS.push("delete", value: %{id: task.id})}>
            X
          </.link>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("save", %{"name" => task_name}, socket) do
    id =
      socket.assigns.tasks
      |> Enum.reduce(0, fn task, acc ->
        if task.id > acc, do: task.id, else: acc
      end)

    tasks = socket.assigns.tasks ++ [%{id: id + 1, name: task_name, status: false}]

    {:noreply,
     socket
     |> assign(tasks: tasks)
     |> assign(
       :form,
       to_form(%{"id" => 0, "name" => "", "status" => false})
     )}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    tasks =
      socket.assigns.tasks
      |> Enum.filter(fn task -> task.id != id end)

    {:noreply,
     socket
     |> assign(:tasks, tasks)}
  end

  @impl true
  def handle_event("toggle", %{"id" => id}, socket) do
    tasks =
      socket.assigns.tasks
      |> Enum.map(fn task ->
        task =
          if task.id == id, do: Map.update!(task, :status, fn status -> !status end), else: task

        task
      end)

    {:noreply,
     socket
     |> assign(:tasks, tasks)}
  end
end
