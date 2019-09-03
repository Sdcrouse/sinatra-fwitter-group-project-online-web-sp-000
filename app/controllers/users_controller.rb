class UsersController < ApplicationController
  # Note: feel free to delete these comments once the routes have been written.
  
  # get '/signup' do
  #   binding.pry
  #   "You are now signed up!"
  # end
# 

# Be sure to delete all of this and replace it with the other code.
  get '/login' do
    erb :'/users/login'
  end

  post '/login' do
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect to '/tweets'
    else
      "Oops! Invalid credentials."
    end
  end

  get '/logout' do
    erb :"users/logout"
  end

  post '/logout' do
    session.clear
    redirect to '/'
  end
  # Delete everything above.
end
