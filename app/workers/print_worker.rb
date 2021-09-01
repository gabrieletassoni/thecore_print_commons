require 'ipaddr'
require 'socket'
class PrintWorker
    include Sidekiq::Worker
    sidekiq_options retry: false
    
    # ZPL print
    def perform ip, port, text
        streamSock = TCPSocket.new ip, port
        streamSock.send text, 0
        streamSock.close
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