require 'ipaddr'
require 'socket'
class PrintWorker
    include Sidekiq::Worker
    sidekiq_options retry: false
    
    # ZPL print
    def perform ip, port, text
        @pjob = PrintJob.create(printer_id: Printer.find_by(ip: ip), finished: false, iserror: false, total: 0, printed: 0)
        streamSock = Socket.tcp ip, port, connect_timeout: 0.5
        streamSock.send text, 0
        streamSock.close
        # '~hs alla posizione 56 per 8 caratteri la quantità di etichette rimaste'
        total = text.scan(/~PQ(\d+)/).last.first.to_i rescue 0
        @pjob.update(printed: total) # Se risultato true, allora ha stampato tutto, altrimenti non ha stampato nulla
        @pjob.update(total: total) # In realtà è inutile, ora manda tutto quello che può alla stampante, solo lei può andare storta
        @pjob.update(finished: true)
    end
end