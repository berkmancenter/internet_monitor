module ApplicationHelper
  # return supplied title, base refinery controller name (e.g., blog from /refinery/blog/posts)
  def get_title( title, params )
    if ( title != "" )
      title.downcase
    else
      controller = params[:controller]

      if ( controller.match( /^refinery/ ) != nil )
        parts = controller.split( "/" )

        if ( parts[ 1 ] == "pages" )
          params[ :path ]
        else
          parts[ 1 ]
        end
      else
        controller
      end
    end
  end
end
