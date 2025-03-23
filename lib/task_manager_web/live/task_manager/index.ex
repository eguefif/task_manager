defmodule TaskManagerWeb.TaskManagerLive.Index do
  use TaskManagerWeb, :live_view
  alias TaskManager.Todo
  alias TaskManager.Todo.Task

  @impl true
  def mount(_params, _sessions, socket) do
    tasks = Todo.list_tasks()

    {:ok,
     socket
     |> assign(:tasks, tasks)
     |> assign(:form, to_form(Todo.change_task(%Task{})))}
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
    <.simple_form for={@form} id="task-form" phx-submit="save" phx-change="validate">
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
  def handle_event("save", %{"task" => task}, socket) do
    {:ok, task} = Todo.create_task(task)
    tasks = socket.assigns.tasks ++ [task]

    {:noreply,
     socket
     |> assign(tasks: tasks)
     |> assign(:form, to_form(Todo.change_task(%Task{})))}
  end

  @impl true
  def handle_event("validate", %{"task" => task}, socket) do
    form =
      %Task{}
      |> Todo.change_task(task)
      |> to_form(action: :validate)

    {:noreply,
     socket
     |> assign(:form, form)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    Todo.delete_task(id)

    tasks =
      socket.assigns.tasks
      |> Enum.filter(fn task -> task.id != id end)

    {:noreply,
     socket
     |> assign(:tasks, tasks)
     |> assign(:form, to_form(Todo.change_task(%Task{})))}
  end

  @impl true
  def handle_event("toggle", %{"id" => id}, socket) do
    Todo.toggle_task(id)
    tasks = Todo.list_tasks()

    {:noreply,
     socket
     |> assign(:tasks, tasks)
     |> assign(:form, to_form(Todo.change_task(%Task{})))}
  end
end
