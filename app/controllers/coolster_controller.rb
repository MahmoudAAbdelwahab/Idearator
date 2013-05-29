class CoolsterController < ApplicationController

  # Adds user id to online users list in coolster library.
  # Params:
  # +user_ids+:: the parameter is an string passed through CoolsterApp /poll.
  # Author: Amina Zoheir
  def add_online_user
    Coolster.add_to_online_users(params[:user])
    render text: "ok"
  end

  # Removes user id from online users list in coolster library.
  # Params:
  # +user_ids+:: the parameter is an string passed through CoolsterApp /update.
  # Author: Amina Zoheir
  def remove_online_user
    Coolster.remove_from_online_users(params[:user])
    render text: "ok"
  end

end
