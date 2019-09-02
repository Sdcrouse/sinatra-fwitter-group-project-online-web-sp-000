class TweetsController < ApplicationController
  # Note: Make sure that nobody can create a new tweet from ANY account except their own.

  #tweets index page
  get '/tweets' do
    if logged_in?
      @tweets = Tweet.all
      erb :'/tweets/tweets'
    else
      redirect to '/login'
    end
  end

  #creates new tweet
  get '/tweets/new' do
    if logged_in?
      erb :'tweets/new'
    else
      redirect to '/login'
    end
  end

  #if logged in, and the tweet is empty, go to create new tweet
  # else allow user to create and save tweet with tweet slug and redirect to new tweet w/slug
  # else go back to create new tweet
  post '/tweets' do
    if logged_in?
     if params[:content] == ""
      redirect to '/tweets/new'
    else
      @tweet = current_user.tweets.build(content: params[:content])
      if @tweet.save
        redirect to "/tweets/#{@tweet.id}"
      else
        redirect to '/tweets/new'
      end
    end
  else
    redirect to '/login'
  end
  end

  #displays info for a single tweet
  get '/tweets/:id' do
    if logged_in?
      @tweet =Tweet.find(params[:id])
      erb :'tweets/show'
    else
      redirect to '/login'
    end
  end

  # Allows a user to edit their own tweet (and ONLY their own) if they're logged in.
  # Redirects the user to /tweets if they try to edit someone else's tweet (or if they try to edit a nonexistent tweet).
  # Redirects the user to the login page if they're logged out.
  get '/tweets/:id/edit' do 

    if logged_in?
      @tweet = Tweet.find_by_id(params[:id])
      if @tweet && @tweet.user == current_user
        erb :'tweets/edit'
      else # The tweet does not exist, or the user is trying to edit someone else's tweet.
        redirect to '/tweets'
      end
    else # The user is not logged in.
      redirect to '/login' # I wonder if we should put a flash message here?
    end

  end

  # Lets a user edit their own tweet if they are logged in.
  # Does not let a user edit a text with blank content.
  # For extra safety: Redirect the user if they're not logged in, or if they try to edit someone else's tweet.
  patch '/tweets/:id' do
    if logged_in?
      tweet = Tweet.find_by_id(params[:id])
      if tweet.user == current_user
        if params[:content].blank? # params[:content] == nil, "", " ", "  ", etc.
          redirect to "/tweets/#{params[:id]}/edit"
        else
          tweet.update(content: params[:content])
          redirect to "/tweets/#{params[:id]}"
        end
      else # Someone else tried to edit this tweet.
        redirect to "/tweets"
      end
    else # The user is not logged in.
      redirect to "/login"
    end
  end

  delete '/tweets/:id/delete' do
    # I should add safeguards here: redirect the user if they are logged out or if they try to delete someone else's tweet.
    # Logged in:
    # lets a user delete their own tweet if they are logged in
    # does not let a user delete a tweet they did not create
    #   If a user tries to do this, redirect them to /tweets without deleting the tweet.
    "You have deleted the tweet."
  end

  # Remember to delete the .sqlite files before committing and pushing.
  # Also, clear the session, User.all, and Tweet.all
end
