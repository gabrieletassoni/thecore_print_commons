module RailsAdmin::Printer
    extend ActiveSupport::Concern
    included do
        # Here You can define the RailsAdmin DSL
        rails_admin do
            navigation_label I18n.t("admin.settings.label")
            navigation_icon 'fa fa-print'
            
            field :name
            field :print_template
            field :ip
            field :port do
                default_value do
                    9100
                end
            end
            
            if Object.const_defined?('RailsAdminToggleable')
                field :default, :toggle
            else
                field :default
            end
            
            show do
                field :temperature
                field :description
            end
            
            edit do
                field :temperature
                field :description
            end
            
            field :is_online do
                read_only true
                formatted_value do # used in form views
                    (value ? "<strong style='color:green'>👍</strong>" : "<strong style='color:red'>👎</strong>").html_safe
                end
                
                pretty_value do # used in list view columns and show views, defaults to formatted_value for non-association fields
                    (value ? "<strong style='color:green'>👍</strong>" : "<strong style='color:red'>👎</strong>").html_safe
                end
                
                export_value do
                    value ? "OK" : "KO" # used in exports, where no html/data is allowed
                end
            end
        end
    end
end