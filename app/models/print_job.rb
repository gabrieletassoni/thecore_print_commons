class PrintJob < ApplicationRecord
  belongs_to :printer, inverse_of: :print_jobs

  RailsAdmin.config do |config|
    config.model 'PrintJob' do
    # rails_admin do
      navigation_label I18n.t("admin.settings.label")
      navigation_icon 'fa fa-check-square'
      parent Printer

      field :printer
      field :created_at
      field :description
    end
  end
end
