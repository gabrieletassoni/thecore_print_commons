class Endpoints::Printer < NonCrudEndpoints
    self.desc :print_single_barcode, {
        post: {
            summary: "Print a single barcode",
            description: "Print a single barcode",
            operationId: "print_single_barcode",
            tags: ["Printer"],
            requestBody: {
                required: true,
                content: {
                    "application/json": {
                        schema: {
                            type: "object",
                            properties: {
                                id: { type: "integer" },
                                quantity: { type: "integer" },
                                description: { type: "string" },
                                location: { type: "string" },
                                serial: { type: "string" }
                            }
                        }
                    }
                }
            },
            responses: {
                200 => {
                    description: "The openAPI json schema for this action",
                    content: {
                        "application/json": {
                            schema: {
                                type: "object",
                                properties: {
                                    info: { type: "string" }
                                }
                            }
                        }
                    }
                },
                501 => {
                    error: :string,
                }
            }
        }
    }
    def print_single_barcode params
        # Example Usage:
        # item = ::Item.joins(:projects).where(projects: {id: params[:order_id].to_i}).first
        # printer = ::Printer.where(supplier_id: current_user.supplier_id, default: true).first
        # single_text = "#{printer.print_template.template.gsub("%DESCRIPTION%", item.description)}"
        # text = single_text * params[:quantity].to_i
        # # Preso l'ordine mi recupero l'item e ne stampo la quantità richiesta
        # ::PrintWorker.perform_async('192.168.0.1', 9100, "We all love DJ")

        printer = Printer.find(params[:id])
        result = base_template = printer.print_template.template.dup
        result = printer.print_template.translation_matrix.lines.map(&:strip).inject(base_template) do |base_template, replacement|
            base_template.gsub("$#{replacement}", params[replacement]) unless replacement.blank? && params[replacement].blank?
        end if printer.print_template.translation_matrix.present?
        ::PrintWorker.perform_async(printer.ip, printer.port, result)
        return { info: "Print job sent in background to #{printer.ip} on port #{printer.port}" }, 200
    end
end