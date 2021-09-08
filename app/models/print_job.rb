class PrintJob < ApplicationRecord
    include Api::PrintJob
    include RailsAdmin::PrintJob

    belongs_to :printer, inverse_of: :print_jobs
    
    def printed_on_total
        "#{printed}/#{total}"
    end
end