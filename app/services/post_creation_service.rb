class PostCreationService
  def initialize(current_user, post_params)
    @current_user = current_user
    @post_params = post_params
  end

  def call
    post = @current_user.posts.build(@post_params)
    if post.save
      DeletePostJob.set(wait: 24.hours).perform_later(post.id)
      [post, nil]
    else
      [nil, post.errors.full_messages]
    end
  end
end
