require 'sinatra'
require 'erb'

module RucketServer
  extend self

  attr_reader :rucket

  def start &block
    @rucket = Rucket.new &block
  end

  class App < Sinatra::Base
    configure do
      set :port, 4200
    end

    get '/' do
      RucketServer.rucket.update
      erb :index
    end

    get '/fans/:action' do
      if params[:action] == 'on'
        RucketServer.rucket.turn_on_fans
      else
        RucketServer.rucket.turn_off_fans
      end
      redirect '/'
    end
  end
end