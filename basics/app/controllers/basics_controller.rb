require 'builder'
class BasicsController < ApplicationController

  def task1

  end

  def task2

  end

  def task3

  end

  def task4

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

  def stocks_i_like
    sql = "with m as (select my_stocks.symbol, sum(my_stocks.n_shares) total_shares, sum(stock_prices.price) total_prices from my_stocks join stock_prices on my_stocks.symbol=stock_prices.symbol where stock_prices.price > 322 group by my_stocks.symbol) select * from m union all select 'Total', sum(my_stocks.n_shares), sum(stock_prices.price) from m, my_stocks, stock_prices;"
    @result = ActiveRecord::Base.connection.execute(sql)
  end

  def quotations

    @quotation = Quotation.new
    query = Quotation.all
    if params[:q]
      query = Quotation.search(params[:q].downcase)
    end

    if cookies[:quotations]
      query = query.where.not(id: JSON.parse(cookies[:quotations]))
    end

    if params[:sort_by] == "category"
      @quotations = query.order(:category)
    else
      @quotations = query.order(:created_at)
    end

  end

  def quotation_new

    if request.headers["Content-Type"] == 'text/xml' || request.headers["Content-Type"] == 'application/xml' || !params['url'].nil?
      if !params['url'].nil?
        data = Nokogiri::XML(open(params['url']))
      else
        data = Nokogiri::XML(request.body)
      end
      if !data.css('quotation').nil?
        data.css('quotation').each do |node|
          children = node.children
          @quotation = Quotation.create(
              :author_name => children.css('author_name').inner_text,
              :category => children.css('category').inner_text,
              :quote => children.css('quote').inner_text
          )
          @quotation.save
        end
      end
      if !data.css('object').nil?
        data.css('object').each do |node|
          children = node.children
          @quotation = Quotation.create(
              :author_name => children.css('author_name').inner_text,
              :category => children.css('category').inner_text,
              :quote => children.css('quote').inner_text
          )
          @quotation.save
        end
      end
    else
      if params[:quotation][:category] == "New Category"
        if params[:post][:category_name] == ""
          params[:quotation][:category] = "Undefined"
        else
          params[:quotation][:category] = params[:post][:category_name]
        end
      end
      @quotation = Quotation.new(quotation_params)
    end


    respond_to do |format|
      if @quotation.save
        format.html { redirect_to quotations_show_path, notice: 'Quotation was successfully created.' }
        format.json { render json: @quotation, status: :created }
        format.xml { render xml: @quotation, status: :created }
      else
        format.html { render quotations_show_path }
        format.json { render json: @quotation.errors, status: :unprocessable_entity }
        format.xml { render xml: @quotation.errors, status: :unprocessable_entity }
      end
    end

  end

  def quotations_json
    quotation = Quotation.all.to_json
    send_data quotation, :type => 'application/json; header=present', :disposition => "attachment; filename=quotations.json"
  end

  def quotations_xml
    xml = Builder::XmlMarkup.new( :indent => 2 )
    xml.instruct! :xml, :version =>'1.0'

    xml.quotations do
      Quotation.all.each do |s|
        xml.quotation do
          xml.id(s.id)
          xml.author_name(s.author_name)
          xml.category(s.category)
          xml.quote(s.quote)
          xml.created_at(s.created_at)
          xml.updated_at(s.updated_at)
        end
      end
    end
    send_data xml.target!, :type => 'text/xml; header=present', :disposition => "attachment; filename=quotations.xml"
  end

  def kill_quote
    if cookies[:quotations].nil?
      array = []
    else
      array = JSON.parse(cookies[:quotations])
    end
    cookies[:quotations] = JSON.generate(array.push(params['quotation_id']))
    respond_to do |format|
      format.html { redirect_to quotations_show_path, notice: 'Quote was successfully killed.' }
    end
  end

  def clear_cookie
    cookies.delete :quotations
    redirect_to quotations_show_path
  end

  def quotation_params
    params.require(:quotation).permit(:author_name, :category, :quote)
  end



end
