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
      redirect '/status'
    end

    get '/status' do
      RucketServer.rucket.update
      erb :status
    end

    get '/fans' do
      RucketServer.rucket.update
      erb :fans
    end

    get "/fans/:name/toggle" do |name|
      RucketServer.rucket.fans[name.to_sym].toggle
      redirect "/fans"
    end  

    get '/lights' do 
      RucketServer.rucket.update
      erb :lights
    end

    get "/lights/:name/toggle" do |name|
      RucketServer.rucket.lights[name.to_sym].toggle
      redirect "/lights"
    end  

    get "/control" do
      RucketServer.rucket.update
      erb :control
    end

    post "/modules/:name" do |name|
      if RucketServer.rucket[name].is_a? Timer
        RucketServer.rucket[name].start_time = "#{params["start_hour"]}:#{params["start_minute"]}"
        RucketServer.rucket[name].end_time = "#{params["end_hour"]}:#{params["end_minute"]}"
      end

      RucketServer.rucket.update
      
      redirect "/control"
    end
  end
end