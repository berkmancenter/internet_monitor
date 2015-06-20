Refinery::User.class_eval do
  private
    def downcase_username
      self.username if self.username?
    end
end

