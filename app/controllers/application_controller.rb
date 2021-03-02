require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, 'secret'
  end

   def current_user
        User.find_by(id: session[:user_id])
    end

    def logged_in?
        # puts session.to_json
        session.key?(:user_id)
    end

    def redirect_if_not_logged_in
      redirect '/login' unless current_user
    end

end 