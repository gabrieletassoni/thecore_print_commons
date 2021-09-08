module RailsAdmin::PrintJob
    extend ActiveSupport::Concern
    included do
        # Here You can define the RailsAdmin DSL
        rails_admin do
            # rails_admin do
            navigation_label I18n.t("admin.settings.label")
            navigation_icon 'fa fa-check-square'
            parent Printer
            
            field :printer
            field :created_at
            field :description
            list do
                field :printed_on_total
            end
        end
    end
end