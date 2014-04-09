module ApplicationHelper
  include Twitter::Autolink

  # return supplied title, base refinery controller name (e.g., blog from /refinery/blog/posts)
  def get_title( title, params )
    controller = params[:controller]

    if ( title.present? && title != '' )
      title.titleize
    elsif controller.present?
      if ( controller.match( /^refinery/ ) != nil )
        parts = controller.split( "/" )

        if ( parts[ 1 ] == "pages" )
          params[ :path ].titleize unless params[ :path ].nil?
        else
          parts[ 1 ].titleize
        end
      else
        controller.titleize
      end
    else
        ''
    end
  end
end
