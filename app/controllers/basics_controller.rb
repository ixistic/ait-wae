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

  def quotations
    @quotation = Quotation.new
    query = Quotation.all
    if params[:q]
      query = Quotation.search(params[:q].downcase).order(:created_at)
    end
    if params[:sort_by] == "date"
      @quotations = query.order(:created_at)
    else
      @quotations = query.order(:category)
    end
  end

  def quotation_new

    @quotation = Quotation.new(quotation_params)

    respond_to do |format|
      if @quotation.save
        format.html { redirect_to quotations_show_path, notice: 'Quotation was successfully created.' }
        format.json { render quotations_show_path, status: :created }
      else
        format.html { render quotations_show_path }
        format.json { render json: @quotation.errors, status: :unprocessable_entity }
      end
    end

  end

  def quotation_params
    params.require(:quotation).permit(:author_name, :category, :quote)
  end



end
