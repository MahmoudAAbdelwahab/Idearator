require 'rest_client'

module Coolster

  @@online_user_ids = []

  # Adds user id to online_user_ids
  # Params:
  # +user_id+:: the parameter is an id of a string passed through the Coolster#add_online_user.
  # Author: Amina Zoheir
  def self.add_to_online_users(user_id)
    unless @@online_user_ids.include?(user_id)
      @@online_user_ids << user_id
    end
  end

  # Removes user id from online_user_ids
  # Params:
  # +user_id+:: the parameter is an id of a string passed through the Coolster#remove_online_user.
  # Author: Amina Zoheir
  def self.remove_from_online_users(user_id)
    @@online_user_ids.delete(user_id)
  end

  # Sends http post request to CoolsterApp /push_to_all with script parameter
  # Params:
  # +script+:: the parameter is a string (javascript).
  # Author: Amina Zoheir
  def self.update_all(script)
    begin
      RestClient.post 'http://localhost:9292/push_to_all', {script: script, multipart: true}
    rescue => e
    end
  end

  # Sends http post request to CoolsterApp /push with script, user ids intersected with online user ids as parameters
  # Params:
  # +user_ids+:: the parameter is an array of strings.
  # +script+:: the parameter is a string (javascript).
  # Author: Amina Zoheir
  def self.update(user_ids, script)
    scripts = {}
    user_ids = @@online_user_ids & user_ids
    begin
      RestClient.post 'http://localhost:9292/push', {script: script, users: user_ids, multipart: true}
    rescue => e
    end
  end

  # Sends http post request to CoolsterApp /push_to_each with a hash of user ids pointing to scripts as parameters
  # Params:
  # +user_ids+:: the parameter is an array of strings.
  # +&block+:: the parameter is a block.
  # Author: Amina Zoheir
  def self.update_each(user_ids, &block)
    scripts = {}
    user_ids = @@online_user_ids & user_ids
    case block.arity
    when 0
      script = yield
      user_ids.each do |user_id|
        scripts[user_id] = script
      end
    when 1
      user_ids.each do |user_id|
        script = yield user_id
        scripts[user_id] = script
      end
    else
      raise Exception
    end
    begin
      RestClient.post 'http://localhost:9292/push_to_each', {scripts: scripts, multipart: true}
    rescue => e
    end
  end

  def self.online_user_ids
    @@online_user_ids
  end

end
