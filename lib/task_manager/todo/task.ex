defmodule TaskManager.Todo.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "todo_task" do
    field :status, :boolean, default: false
    field :name, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:name, :status])
    |> validate_required([:name, :status])
    |> validate_length(:name, min: 4, max: 45)
  end
end
