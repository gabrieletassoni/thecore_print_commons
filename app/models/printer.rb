class Printer < ApplicationRecord
  include Api::Printer
  include RailsAdmin::Printer
  
  belongs_to :print_template, inverse_of: :printers
  
  validates :name, presence: true
  validates :ip, presence: true
  validates :port, presence: true
  validates :print_template, presence: true
  
  def online?
    begin
      Socket.tcp(self.ip, self.port, connect_timeout: 0.5).close
    rescue
      return false
    end
    true
  end

end
