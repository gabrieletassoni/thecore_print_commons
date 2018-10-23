# require 'uri'
# uri = URI.parse(ENV['RAILS_RELATIVE_URL_ROOT'] || "http://#{Socket.ip_address_list[1].ip_address}")

# # Not so good, but let's try
# RailsAdmin.config do |config|
#     (config.navigation_static_links ||= {}).merge! "CUPS Printers" => "#{uri.scheme}://#{uri.host}:631"
# end