defmodule DiscussWeb.CommentsChannel do
  use DiscussWeb, :channel

  alias Discuss.Posts

  def join("comments:" <> topic_id, _params, socket) do
    topic_id = String.to_integer(topic_id )
    topic = Posts.get_topic!(topic_id)
    |> Posts.preload_comments

    {:ok, %{comments: topic.comments}, assign(socket, :topic, topic)}
  end

  def handle_in(_name, %{"content" => content}, socket) do
    comment = Ecto.build_assoc(socket.assigns[:topic], :comments, user_id: socket.assigns[:user_id])
    case Posts.create_comment(comment, %{content: content}) do
      {:ok, comment} ->
        broadcast!(socket, "comments:#{socket.assigns.topic.id}:new", %{comment: comment})
        {:reply, :ok, socket}
      {:error, %Ecto.Changeset{} = changeset} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
    {:reply, :ok, socket}
  end
end
