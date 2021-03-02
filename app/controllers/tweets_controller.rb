class TweetsController < ApplicationController
    get '/tweets' do
        if logged_in?
          @tweets = Tweet.all
          erb :index
        else
        #   flash[:message] = "You must be logged in to view tweets."
          redirect :'/login'
        end
      end
    
      get '/tweets/new' do

        redirect '/login' unless current_user

        erb :'/tweets/create_tweet'
      end
    
      post '/tweets' do

        redirect '/login' unless current_user

        if params[:content].empty?
        #   flash[:message] = "Your tweet is empty!"
          redirect :'/tweets/new'
        else
          @tweet = Tweet.create(params)
          @tweet.user_id = session[:user_id]
          @tweet.save
        #   flash[:message] = "Successfully tweeted!"
          redirect :"tweets/#{@tweet.id}"
        end
      end
    
      get '/tweets/:id' do
        redirect '/login' unless current_user

        @tweet = Tweet.find_by_id(params[:id])
        erb :'/tweets/show_tweet'
      end
    
      get '/tweets/:id/edit' do
        redirect '/login' unless current_user

        @tweet = Tweet.find(params[:id])
        if @tweet && session[:user_id] == @tweet.user_id
        erb :'/tweets/edit_tweet'
        else
        # flash[:message] = "You must be the tweet owner to edit."
        redirect :'/tweets'
        end  
      end
    
      patch '/tweets/:id' do
        @tweet = Tweet.find_by_id(params[:id])
    
        if params[:content].empty?
        #   flash[:message] = "Your tweet is empty!"
          redirect :"/tweets/#{@tweet.id}/edit"
        elsif params[:content] == @tweet.content
        #   flash[:message] = "There has been no changes to the tweet!"
          redirect :"/tweets/#{@tweet.id}"
        else
          @tweet.content = params[:content]
          @tweet.save
        #   flash[:message] = "Successfully edited tweet!"
          redirect :"/tweets/#{@tweet.id}"
        end
      end
    
      #DELETE TWEETS
        post '/tweets/:id/delete' do
            redirect '/login' unless current_user

            @tweet = Tweet.find(params[:id])
            if @tweet && @tweet.user_id == session[:user_id]
              @tweet.delete
            #   flash[:message] = "Successfully deleted tweet!"
              redirect :'/tweets'
            else
            #   flash[:message] = "You do not have permission to delete this tweet."
              redirect :'/tweets'
            end
        end

end
