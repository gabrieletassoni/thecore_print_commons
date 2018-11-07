require 'ipaddr'
class PrintWorker
    include Sidekiq::Worker
    def perform printer_cups_name, text
        begin
            printer = if Settings.ns(:printer_commons).cups_server.blank? || ['127.0.0.1', 'localhost'].contains(Settings.ns(:printer_commons).cups_server)
                CupsPrinter.new printer_cups_name
            else
                CupsPrinter.new printer_cups_name, hostname: Settings.ns(:printer_commons).cups_server
            end
            printer.print_data text, 'text/plain'
        rescue => error
            Rails.logger.debug("PRINTER #{printer_cups_name} ERROR: #{$!.message}")
            Rails.logger.debug($!.backtrace)
        end
    end
end