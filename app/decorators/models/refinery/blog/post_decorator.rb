Refinery::Blog::Post.class_eval do
  def increment!(attribute, by = 1)
    increment(attribute, by).update_column(attribute, self[attribute])
  end
end


