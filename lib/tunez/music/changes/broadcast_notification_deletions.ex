defmodule Tunez.Music.Changes.BroadcastNotificationDeletions do
  use Ash.Resource.Change
  require Ash.Query

  @impl true
  def atomic(_changeset, _opts, _context) do
    {:not_atomic, "Must read notifications before broadcasting"}
  end

  @impl true
  def change(changeset, _opts, _context) do
    Ash.Changeset.before_action(changeset, fn changeset ->
      album = changeset.data

      Tunez.Accounts.Notification
      |> Ash.Query.filter(album_id == ^album.id)
      |> Ash.Query.select([:id, :user_id, :album_id])
      |> Ash.read!(authorize?: false)
      |> Enum.each(fn notification ->
        TunezWeb.Endpoint.broadcast!(
          "notifications:#{notification.user_id}",
          "destroy",
          Map.take(notification, [:id, :user_id, :album_id])
        )
      end)

      changeset
    end)
  end
end
