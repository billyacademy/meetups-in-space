require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'omniauth-github'

require_relative 'config/application'

Dir['app/**/*.rb'].each { |file| require_relative file }

helpers do
  def current_user
    user_id = session[:user_id]
    @current_user ||= User.find(user_id) if user_id.present?
  end

  def signed_in?
    current_user.present?
  end
end

def set_current_user(user)
  session[:user_id] = user.id
end

def authenticate!
  unless signed_in?
    flash[:notice] = 'You need to sign in if you want to do that!'
    redirect '/'
  end
end

get '/' do
  redirect '/meetups'
end

get '/meetups' do
  @meetups = Meetup.all
  erb :index
end

get '/meetups/:id' do

  @meetups = Meetup.find(params[:id])
  @users = User.all
  @rsvps = Rsvp.where(meetup_id: params[:id])
  @current_user_rsvp_list = Rsvp.find_by(user_id: current_user, meetup_id: params[:id])
    erb :meetups
end

get '/new_meetup' do
  @meetups = Meetup.all
  erb :new_meetup
end

post '/meetups/:id' do
  @user_id = current_user.id
  @meetup_id = params[:id]
  @meetup = Meetup.find(@meetup_id)
  rsvp = Rsvp.create(user_id: @user_id, meetup_id: @meetup.id)
  flash[:notice] = "You have successfully joined the meetup!"
    redirect "/meetups/#{@meetup_id}"
end

post '/leave_meetup' do
  @user_id = current_user[:id]
  @meetup_id = params[:meetup]
  @current_user_rsvp_list = Rsvp.find_by(user_id: @user_id, meetup_id: @meetup_id)
  @current_user_rsvp_list.destroy
  flash[:notice] = "You have successfully left the meetup!"
  redirect "/meetups/#{@meetup_id}"
end


post '/new_meetup' do
  @name = params[:name]
  @description = params[:description]
  @location = params[:location]
  @all = Meetup.create(name: @name, description: @description, location: @location)

  if @name.empty? || @description.empty? || @location.empty?
    flash[:notice] = 'All fields must be populated to create a meetup.'
    redirect "/new_meetup"
  else
    flash[:notice] = 'You have successfully posted a new meetup!'
    redirect "/meetups/#{@all[:id]}"
  end

end


get '/auth/github/callback' do
  auth = env['omniauth.auth']

  user = User.find_or_create_from_omniauth(auth)
  set_current_user(user)
  flash[:notice] = "You're now signed in as #{user.username}!"

  redirect '/'
end

get '/sign_out' do
  session[:user_id] = nil
  flash[:notice] = "You have been signed out."

  redirect '/'
end

get '/example_protected_page' do
  authenticate!
end
