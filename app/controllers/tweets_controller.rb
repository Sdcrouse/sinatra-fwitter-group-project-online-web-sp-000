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
  post '/tweets/new' do
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
  # Redirect the user to /tweets if they try to edit someone else's tweet.
  # Redirects users to the login page if they're logged out.
  get '/tweets/:id/edit' do
    "You have edited the tweet!"
    # Logged in:
    # lets a user view tweet edit form if they are logged in
    # does not let a user edit a tweet they did not create
      # From the tests, it looks like the logged in user should be able to view other people's tweets AND the Edit Tweet button.
      # However, when they click Edit Tweet, they should be redirected to /tweets. 

    # Logged out:
    # does not load -- requests user to login
      # Redirect them to the login page.

  end

  patch '/tweets/:id' do
    # lets a user edit their own tweet if they are logged in
    # does not let a user edit a text with blank content
      # If the tweet's content is blank, don't change it; redirect the user to /tweets/:id/edit.
    # I should probably add this extra safeguard: to redirect the user if they're not logged in, or if they try to edit someone else's tweet.
  end

  post '/tweets/:id/delete' do
    # I should add safeguards here: redirect the user if they are logged out or if they try to delete someone else's tweet.
    # Logged in:
    # lets a user delete their own tweet if they are logged in
    # does not let a user delete a tweet they did not create
    #   If a user tries to do this, redirect them to /tweets without deleting the tweet.
  end

end
