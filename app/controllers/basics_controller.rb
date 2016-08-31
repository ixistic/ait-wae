class BasicsController < ApplicationController

  def task1

  end

  def youtube_top_ten
    @doc = Nokogiri::HTML(open('https://www.youtube.com/feed/trending'), nil, Encoding::UTF_8.to_s)
              .css('li.expanded-shelf-content-item-wrapper')


    @result = @doc.css('a.yt-uix-sessionlink.yt-uix-tile-link.yt-ui-ellipsis.yt-ui-ellipsis-2.spf-link')
                  .take(10)
                  .map {|video|
                      @video_id = video['href'].split('=')[1]
                      [
                        video['title'],
                       'http://www.youtube.com'+video['href'],
                       'http://img.youtube.com/vi/'+@video_id+'/default.jpg'
                      ]}

  end

  # About to divide bt 0
  def exception

    # ZeroDivisionError (divided by 0):
    # app/controllers/basics_controller.rb:20:in `/'
    # app/controllers/basics_controller.rb:20:in `exception'
    # Rendering /Users/ixistic/.rvm/gems/ruby-2.3.1@rails5.0/gems/actionpack-5.0.0.1/lib/action_dispatch/middleware/templates/rescues/diagnostics.html.erb within rescues/layout
    # Rendering /Users/ixistic/.rvm/gems/ruby-2.3.1@rails5.0/gems/actionpack-5.0.0.1/lib/action_dispatch/middleware/templates/rescues/_source.html.erb
    # Rendered /Users/ixistic/.rvm/gems/ruby-2.3.1@rails5.0/gems/actionpack-5.0.0.1/lib/action_dispatch/middleware/templates/rescues/_source.html.erb (4.1ms)
    # Rendering /Users/ixistic/.rvm/gems/ruby-2.3.1@rails5.0/gems/actionpack-5.0.0.1/lib/action_dispatch/middleware/templates/rescues/_trace.html.erb
    # Rendered /Users/ixistic/.rvm/gems/ruby-2.3.1@rails5.0/gems/actionpack-5.0.0.1/lib/action_dispatch/middleware/templates/rescues/_trace.html.erb (3.1ms)
    # Rendering /Users/ixistic/.rvm/gems/ruby-2.3.1@rails5.0/gems/actionpack-5.0.0.1/lib/action_dispatch/middleware/templates/rescues/_request_and_response.html.erb
    # Rendered /Users/ixistic/.rvm/gems/ruby-2.3.1@rails5.0/gems/actionpack-5.0.0.1/lib/action_dispatch/middleware/templates/rescues/_request_and_response.html.erb (1.0ms)
    # Rendered /Users/ixistic/.rvm/gems/ruby-2.3.1@rails5.0/gems/actionpack-5.0.0.1/lib/action_dispatch/middleware/templates/rescues/diagnostics.html.erb within rescues/layout (80.0ms)

    @result = 1/0

  end

end
