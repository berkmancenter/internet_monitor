# Note: not in use, left here for a few commits
# in case we need to change Cache-Control anyway
#
#Refinery::Blog::PostsController.class_eval do
#  def show
#    puts '** this is my show!**'
#    
#    if stale? last_modified: @post.updated_at.utc, etag: @post.cache_key, public: true
#      @comment = Refinery::Blog::Comment.new 
#   
#      @canonical = refinery.url_for(:locale => Refinery::I18n.current_frontend_locale) if canonical? 
#      @post.increment!(:access_count, 1) 
#
#      respond_with (@post) do |format| 
#        format.html { present(@post) } 
#        format.js { render :partial => 'post', :layout => false } 
#      end 
#    end
#  end
#end
#
