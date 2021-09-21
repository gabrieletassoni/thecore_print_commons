require 'ipaddr'
require 'socket'
class PrintWorker
    include Sidekiq::Worker
    sidekiq_options retry: false, queue: "#{ENV["COMPOSE_PROJECT_NAME"]}_default"
    
    # ZPL print
    def perform ip, port, text
        streamSock = Socket.tcp ip, port, connect_timeout: 0.5
        streamSock.send text, 0
        streamSock.close
    end
end