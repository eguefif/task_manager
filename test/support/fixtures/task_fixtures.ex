defmodule TaskManager.TasksFixtures do
  def task_fixture(attrs \\ %{}) do
    {:ok, task} =
      attrs
      |> Enum.into(%{
        name: "some description",
        status: false
      })
      |> TaskManager.Todo.create_task()

    task
  end
end
