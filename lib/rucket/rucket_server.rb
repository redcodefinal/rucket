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
        RucketServer.rucket.turn_fans_on
      else
        RucketServer.rucket.turn_fans_off
      end
      redirect '/'
    end
  end
end