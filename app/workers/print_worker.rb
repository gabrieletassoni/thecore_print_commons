require 'ipaddr'
require 'socket'
class PrintWorker
    include Sidekiq::Worker
    sidekiq_options retry: false
    
    # ZPL print
    def perform ip, port, text
        @pjob = PrintJob.create(printer_id: Printer.find_by(ip: ip), finished: false, iserror: false, total: 0, printed: 0)
        status = check_status(ip)
        print_job_status = false
        if status == "OK"
            begin
                streamSock = TCPSocket.new ip, port
                streamSock.send text, 0
                streamSock.close
                print_job_status = true
            rescue
                @pjob.update(iserror: true, description: "PRINTER ERROR: TIMEOUT")
                print_job_status = false
            end
        else
            @pjob.update(iserror: true, description: "PRINTER ERROR: #{status}")
            print_job_status = false
        end
        # '~hs alla posizione 56 per 8 caratteri la quantità di etichette rimaste'
        total = text.scan(/~PQ(\d+)/).last.first.to_i rescue 0
        @pjob.update(printed: (print_job_status ? total : 0)) # Se risultato true, allora ha stampato tutto, altrimenti non ha stampato nulla
        @pjob.update(total: total) # In realtà è inutile, ora manda tutto quello che può alla stampante, solo lei può andare storta
        @pjob.update(finished: print_job_status)
    end
    
    def check_status printer
        begin
            s = TCPSocket.new(printer, 9100)
            # Must create intepolation between item and template
            # Printer.template può essere anche
            # una parola di comando epr chiedere lo stato della stampante, solo nel caso sia ok,
            # Allora mando la stampa
            s.puts("~hs")
            # Attende per la risposta (si mette in wait)
            response = []
            while (response_text = s.gets)
                response << response_text
                break if response.count == 3
            end
            s.close
            Rails.logger.info "PrintIt: RESPONSE: #{response.inspect}"
            first = response[0].split(",")
            second = response[1].split(",")
            return "HEAD UP" if second[2].to_i == 1
            return "RIBBON OUT" if second[3].to_i == 1
            return "PAPER OUT" if first[1].to_i == 1
            return "PAUSE" if first[2].to_i == 1
            return "OK"
        rescue
            Rails.logger.info "PrintIt: STATUS: UNREACHABLE"
            return "UNREACHABLE"
        end
    end
    
    # This is for cups only
    # def perform printer_cups_name, text
    #     # if Settings.ns(:printer_commons).cups_server.blank? || ['127.0.0.1', 'localhost'].contains(Settings.ns(:printer_commons).cups_server)
    #     #     printer = CupsPrinter.new printer_cups_name
    #     #     printer.print_data text, 'text/plain'
    #     #     printer.close
    #     # else
    #     print_file = "/tmp/print-#{printer_cups_name}-#{Time.now.strftime '%Y%m%d%H%M%S%L'}"
    #     puts "Creating temp file: #{print_file}"
    #     IO.write(print_file, text)
    #     # CupsPrinter.new printer_cups_name, hostname: Settings.ns(:printer_commons).cups_server
    #     # printer.print_data text, 'text/plain', hostname: Settings.ns(:printer_commons).cups_server
    #     puts "Printing with lp command on #{printer_cups_name} of #{Settings.ns(:printer_commons).cups_server} "
    #     `cupsenable "#{printer_cups_name}";lp -d "#{printer_cups_name}" -h "#{Settings.ns(:printer_commons).cups_server}" -o raw "#{print_file}"`
    #     File.delete print_file
    #     # end
    # end
end