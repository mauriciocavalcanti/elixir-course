defmodule DiscussWeb.Plugs.SetUser do
  import Plug.Conn

  alias Discuss.Posts

  def init(_params) do

  end

  def call(conn, _params) do
    user = get_session(conn, :current_user)
    cond do
      user = user && Posts.get_user(user.id) ->
        assign(conn, :current_user, user)
      true ->
        assign(conn, :current_user, nil)
    end
  end

end
