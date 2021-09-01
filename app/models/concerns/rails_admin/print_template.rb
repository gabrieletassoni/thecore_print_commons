module RailsAdmin::PrintTemplate
    extend ActiveSupport::Concern
    included do
        # Here You can define the RailsAdmin DSL
        rails_admin do
            navigation_label I18n.t("admin.settings.label")
            navigation_icon 'fa fa-file-text'
            parent Printer
            
            field :name
            field :description
            
            edit do
                field :template
                field :translation_matrix
            end
            
            show do
                field :template
                field :translation_matrix
            end
        end
    end
end