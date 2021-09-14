class Printer < ApplicationRecord
  include Api::Printer
  include RailsAdmin::Printer
  #serialize :translation, Hash
  
  # before_save :check_if_unique_default
  # validates :qty, presence: true, numericality: { only_integer: true, greater_than: 0 }
  # validates :translation, presence: true
  
  # def template_enum
  #   PrintTemplate.descendants
  # end
  #
  # # Array holding all the roles
  # USED = %i[
  #   bundle
  #   commission
  # ]
  #
  # def used_in_enum
  #   # Do not EDIT below this line
  #   USED.each_with_index.map {|a,i| [I18n.t("used_in.#{a.to_sym}"), (i+1).to_s]}
  # end
  # def has_section? section
  #     # example called from cancan's app/models/ability.rb
  #     # if user.has_role? :admin
  #
  #     # for roles array stored in db... take each value, see if it matches the second column in the roles_enum array, if so, retu the 1st col of the enum as a uprcase,space_to_underscore,symbol .
  #     USED[self.used_in.to_i - 1].to_s == section.to_s
  # end
  #
  # def self.assigned_to section
  #   where(used_in: (USED.index(section.to_sym) + 1))
  # end
  
  # Usable with CUPS (STUB)
  # def ip_enum
  #   # Getting from CUPS the list of configured printers
  #   if Settings.ns(:printer_commons).cups_server.blank? || ['127.0.0.1', 'localhost'].include?(Settings.ns(:printer_commons).cups_server)
  #     # Local Cups server
  #     CupsPrinter.get_all_printer_names
  #   else
  #     # Remote Cups server
  #     CupsPrinter.get_all_printer_names hostname: Settings.ns(:printer_commons).cups_server
  #   end 
  # end
  
  belongs_to :print_template, inverse_of: :printers
  has_many :print_jobs, dependent: :destroy, inverse_of: :printer
  
  validates :name, presence: true
  validates :ip, presence: true
  validates :port, presence: true
  validates :print_template, presence: true
  
  def online?
    begin
      s = TCPSocket.new(self.ip, 9100)
      s.puts("~hs")
      s.close
    rescue
      return false
    end
    true
  end
  
  
  # private
  # def check_if_unique_default
  #   if self.default?
  #     Printer.where.not(id: self.id)
  #   end
  # end
end
