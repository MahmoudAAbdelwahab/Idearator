class FacebookApiCreate

  # After creatng an idea, this method is called which sends the idea as an object to the facebook Api and thus a create post is
  # shared on the user's facebook account.
  # Params:
  # +idea+:: It's is the idea created passed to this class by the Idea model
  # Author: Mohamed Sameh
  def after_save(idea)
    if !idea.user.nil? && idea.user.provider == "facebook" && idea.user.facebook_share
      graph = Koala::Facebook::API.new(idea.user.authentication_token)
      Thread.new {
        graph.put_connections("me", "idearator:create", idea: "http://idearator.pagekite.me/ideas/#{idea.id}")
      }
    end
  end
end
