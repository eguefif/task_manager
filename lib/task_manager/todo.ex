defmodule TaskManager.Todo do
  alias TaskManager.Repo
  alias TaskManager.Todo.Task

  def list_tasks() do
    Repo.all(Task)
  end

  def create_task(attrs \\ %{}) do
    %Task{}
    |> change_task(attrs)
    |> Repo.insert()
  end

  def change_task(%Task{} = task, attrs \\ %{}) do
    Task.changeset(task, attrs)
  end

  def delete_task(id) do
    task = Repo.get!(Task, id)
    Repo.delete(task)
  end

  def toggle_task(id) do
    task = Repo.get!(Task, id)

    task
    |> Task.changeset(%{status: !task.status})
    |> Repo.update!()
  end
end
