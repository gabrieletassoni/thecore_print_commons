module ThecorePrintCommons
  class Engine < ::Rails::Engine

    initializer 'thecore_print_commons.add_to_migrations' do |app|
      unless app.root.to_s.match root.to_s
        # APPEND TO MAIN APP MIGRATIONS FROM THIS GEM
        config.paths['db/migrate'].expanded.each do |expanded_path|
          app.config.paths['db/migrate'] << expanded_path
        end
      end
    end

  end
end
