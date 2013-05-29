class FacebookApiVote

  # After creatng a vote, this method is called which sends the idea voted on as an object to the facebook Api and thus a create post is
  # shared on the user's facebook account.
  # Params:
  # +vote+:: It's is the vote created passed to this class by the Vote model
  # Author: Mohamed Sameh
  def after_save(vote)
    if !vote.user.nil? && vote.user.provider == "facebook" && vote.user.facebook_share
      graph = Koala::Facebook::API.new(vote.user.authentication_token)
      Thread.new {
        graph.put_connections("me", "idearator:vote", idea: "http://idearator.pagekite.me/ideas/#{vote.idea.id}")
      }
    end
  end
end
