require 'ipaddr'
class PrintWorker
    include Sidekiq::Worker
    def perform printer_cups_name, text
        begin
            printer = CupsPrinter.new printer_cups_name
            printer.print_data text, 'text/plain'
        rescue
            Rails.logger.debug("PRINTER #{printer_cups_name} ERROR: TIMEOUT")
        end
    end
end