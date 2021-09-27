module Api::Printer
    extend ActiveSupport::Concern
    
    included do
        # Use @@json_attrs to drive json rendering for 
        # API model responses (index, show and update ones).
        # For reference:
        # https://api.rubyonrails.org/classes/ActiveModel/Serializers/JSON.html
        # The object passed accepts only these keys:
        # - only: list [] of model fields to be shown in JSON serialization
        # - except: exclude these fields from the JSON serialization, is a list []
        # - methods: include the result of some method defined in the model
        # - include: include associated models, it's an object {} which also accepts the keys described here
        cattr_accessor :json_attrs
        @@json_attrs = ::ModelDrivenApi.smart_merge (json_attrs || {}), {}
        
        # Here you can add custom actions to be called from the API
        # The action must return an serializable (JSON) object.
        # Here you can find an example, in the API could be called like:
        # 
        # GET /api/v2/:model/:id?do=test&custom_parameter=hello
        #
        # Please uncomment it to test with a REST client.
        # Please take note on the fact that, if the do params is test, the custom
        # action definition must be, like below self.custom_action_test.
        # def self.custom_action_test id=nil, params=nil
        #     { test: [ :first, :second, :third ], id: id, params: params}
        # end

        def self.custom_action_print_single_barcode params
            # Example Usage:
            # item = ::Item.joins(:projects).where(projects: {id: params[:order_id].to_i}).first
            # printer = ::Printer.where(supplier_id: current_user.supplier_id, default: true).first
            # single_text = "#{printer.print_template.template.gsub("%DESCRIPTION%", item.description)}"
            # text = single_text * params[:quantity].to_i
            # # Preso l'ordine mi recupero l'item e ne stampo la quantità richiesta
            # ::PrintWorker.perform_async('192.168.0.1', 9100, "We all love DJ")

            printer = Printer.find(params[:id])
            base_template = printer.print_template.template.dup
            result = printer.print_template.translation_matrix.lines.map(&:strip).inject(base_template) do |base_template, replacement|
                base_template.gsub("$#{replacement}", params[replacement]) unless replacement.blank? && params[replacement].blank?
            end
            ::PrintWorker.perform_async(printer.ip, printer.port, result)
            { info: "Print job sent in background to #{printer.ip} on port #{printer.port}" }
        end

        def self.custom_action_printer_status params
            printer = Printer.find(params[:id])
            ip = printer.ip
            port = printer.port
            begin
                s = Socket.tcp ip, port, connect_timeout: 0.5
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
                # Rails.logger.info "PrintIt: RESPONSE: #{response.inspect}"
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
end
