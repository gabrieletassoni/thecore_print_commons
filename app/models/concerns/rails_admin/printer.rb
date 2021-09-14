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
            field :online? do
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
            
            list do
                configure :description do
                    visible false
                end
                configure :temperature do
                    visible false
                end
            end
        end
    end
end