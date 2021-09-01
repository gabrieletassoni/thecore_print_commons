module RailsAdmin::Printer
    extend ActiveSupport::Concern
    included do
        # Here You can define the RailsAdmin DSL
        rails_admin do
            navigation_label I18n.t("admin.settings.label")
            navigation_icon 'fa fa-print'
            
            field :print_template
            field :name
            field :ip
            field :port do
                default_value do
                    9100
                end
            end
            field :default, :toggle
            field :temperature
            field :description
            
            list do
                configure :description do
                    visible false
                end
            end
        end
    end
end