defmodule TaskManager.TodoTest do
  use TaskManager.DataCase
  alias TaskManager.Todo
  alias TaskManager.TasksFixtures

  describe "todo" do
    test "list_tasks/1 return all tasks" do
      task = TasksFixtures.task_fixture()

      tasks = Todo.list_tasks()
      assert tasks == [task]
    end

    test "delete_tasks/1 delete tasks" do
      task = TasksFixtures.task_fixture()

      Todo.delete_task(task.id)

      tasks = Todo.list_tasks()
      assert tasks == []
    end

    test "toggle_task/0 toggle the done value" do
      before_task = %{name: "Hello1", status: false}
      task = TasksFixtures.task_fixture(before_task)

      Todo.toggle_task(task.id)

      result = Todo.get_task(task.id)
      assert result.status == !task.status
    end
  end

  describe "task schema" do
    alias TaskManager.Todo.Task

    test "title must be at least two characters long" do
      changeset = Task.changeset(%Task{}, %{name: "I"})
      assert %{name: ["should be at least 4 character(s)"]} = errors_on(changeset)
    end
  end
end
