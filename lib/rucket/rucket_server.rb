require 'sinatra'
require 'erb'

require "./rucket"

class RucketServer < Sinatra::Base
  set :port, 4200


  attr_reader :rucket

  def initialize &block
    @rucket = Rucket.new &block
    self.run!
  end

  get '/' do
    @rucket.update
    erb :index
  end
 
  get '/fans/:action' do
    if params[:action] == 'on'
      @rucket.turn_fans_on
    else
      @rucket.turn_fans_off
    end
    redirect '/'
  end
end