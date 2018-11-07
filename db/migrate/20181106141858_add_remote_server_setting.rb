class AddRemoteServerSetting < ActiveRecord::Migration[5.2]
    def up
        Settings.ns(:printer_commons).cups_server = 'localhost'
    end
  end
  