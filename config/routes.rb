Rails.application.routes.draw do
  get 'home/index'

  scope '/basics' do
    scope '/1' do
      get '/', to: 'basics#task1', as: 'task1_index'
      get '/exception', to: 'basics#exception'
      get '/exception-explanation', to: 'basics#exception_explanation'
      get '/youtube-top-ten', to: 'basics#youtube_top_ten'
    end
    scope '/2' do
      get '/', to: 'basics#quotations', as: 'quotations_show'
      post '/new', to: 'basics#quotation_new', as: 'quotation_new'
      get '/json', to: 'basics#quotations_json', as: 'quotations_json'
      get '/xml', to: 'basics#quotations_xml', as: 'quotations_xml'
      delete '/kill/:id', to: 'basics#kill_quote', as: 'kill'
      delete '/clear', to: 'basics#clear_cookie', as: 'clear_cookie'
    end
  end

  root 'home#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
