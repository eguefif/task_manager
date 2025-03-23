alias TaskManager.Repo
alias TaskManager.Todo.Task

tasks = [
  %{name: "Groceries to Fruiterie", status: false},
  %{name: "Make you tax returns", status: false},
  %{name: "Call your mother", status: true},
  %{name: "Go on the moon", status: true},
  %{name: "Travel to Mars", status: false}
]

Enum.each(tasks, fn task ->
  %Task{}
  |> Task.changeset(task)
  |> Repo.insert!()
end)
