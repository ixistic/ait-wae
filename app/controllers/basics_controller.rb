class BasicsController < ApplicationController
  def index
    doc = Nokogiri::HTML(open('https://www.youtube.com/feed/trending',:proxy=>'http://192.41.170.23:3128'), nil, Encoding::UTF_8.to_s)
              .css('li.expanded-shelf-content-item-wrapper')


    @result = doc.css('a.yt-uix-sessionlink.yt-uix-tile-link.yt-ui-ellipsis.yt-ui-ellipsis-2.spf-link')
                  .take(10)
                  .map {|video|
                      video_id = video['href'].split('=')[1]
                      [
                        video['title'],
                       'http://www.youtube.com'+video['href'],
                       'http://img.youtube.com/vi/'+video_id+'/default.jpg'
                      ]}

    # @thumbnails = @doc.css('span.yt-thumb-simple').css('img').map {|img| img['src']}

    # @title_and_link.each_with_index do |video,index|
    #   video.push(@thumbnails.at(index))
    # end

    # @result = @title_and_link

  end
end
