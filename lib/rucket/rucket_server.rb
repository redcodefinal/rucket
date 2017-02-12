require 'sinatra'
require 'erb'

module RucketServer
  extend self

  def start &block
    Rucket.start &block
    Rucket::LOG.info "Starting Web Server!"
  end

  class App < Sinatra::Base
    configure do
      set :port, 4200
    end

    get '/' do
      redirect '/status'
    end

    get '/status' do
      Rucket.update
      erb :status
    end

    get '/fans' do
      Rucket.update
      erb :fans
    end

    get "/fans/:name/toggle" do |name|
      Rucket.fans[name.to_sym].toggle
      redirect "/fans"
    end  

    get '/lights' do 
      Rucket.update
      erb :lights
    end

    get "/lights/:name/toggle" do |name|
      Rucket.lights[name.to_sym].toggle
      redirect "/lights"
    end  

    get "/control" do
      Rucket.update
      erb :control
    end

    post "/modules/:name" do |name|
      mod = Rucket[name.to_sym]
      if mod.is_a? Timer
        mod.start_time = "#{params["start_hour"]}:#{params["start_minute"]}"
        mod.end_time = "#{params["end_hour"]}:#{params["end_minute"]}"
      end

      redirect "/control"
    end

    get "/modules/:name/*" do |name, splat|
      action = splat
      mod = Rucket[name.to_sym]
      if action == "toggle"
        mod.send(action)
      elsif mod.is_a?(Timer) && (action == "turn_on" || action == "turn_off")
        mod.send(action)
        mod.disable
      end
      redirect "/control"
    end

    get "/logs" do
      erb :logs
    end  
  end
end