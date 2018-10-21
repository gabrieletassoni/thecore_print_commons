require 'ipaddr'
class PrintWorker
    include Sidekiq::Worker
    def perform  printer, text
        # Checking status only for telnet printers, samba ones cannot be checked
        is_telnet_printer? = IPAddr.new(printer).ipv4? rescue false
        status = if is_telnet_printer?
            check_status(printer)
        else
            "OK"
        end 
        if status == "OK"
            begin
                if is_telnet_printer?
                    # Use TCPSocket
                    TCPSocket.new(printer, 9100) do |s|
                        # Rails.logger.debug "TEMPERATURE: #{text}"
                        s.puts(text)
                    end
                    # @printed += 1
                    return true
                else
                    # Use File.open to print on a windows share
                    # Must be in this format: "\\\\host\\share"
                    # remember to escape \
                    File.open(printer) do |f|
                        f.print(text)
                    end
                end
            rescue
                @pjob.update(iserror: true, description: "PRINTER ERROR: TIMEOUT")
                return false
            end
        else
          @pjob.update(iserror: true, description: "PRINTER ERROR: #{status}")
          return false
        end
      end
    
      def check_status printer
        begin
          s = TCPSocket.new(printer, 9100)
          # Must create intepolation between item and template
          # Printer.template può essere anche
          # una parola di comando epr chiedere lo stato della stampante, solo nel caso sia ok,
          # Allora mando la stampa
          s.puts("~HS")
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
    end