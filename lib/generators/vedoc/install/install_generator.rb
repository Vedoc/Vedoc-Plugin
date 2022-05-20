require 'rails/generators/migration'

module Vedoc
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      include Rails::Generators::Migration
      source_root File.expand_path( 'templates', __dir__ )
      desc 'add the migrations'

      def self.next_migration_number( _path )
        if @prev_migration_nr
          @prev_migration_nr += 1
        else
          @prev_migration_nr = Time.now.utc.strftime( '%Y%m%d%H%M%S' ).to_i
        end

        @prev_migration_nr.to_s
      end

      def copy_migrations
        migration_template 'devise_create_admin_users.rb', 'db/migrate/devise_create_admin_users.rb'
        migration_template 'create_shops.rb', 'db/migrate/create_shops.rb'
        migration_template 'devise_token_auth_create_accounts.rb', 'db/migrate/devise_token_auth_create_accounts.rb'
        migration_template 'create_clients.rb', 'db/migrate/create_clients.rb'
        migration_template 'create_pictures.rb', 'db/migrate/create_pictures.rb'
        migration_template 'create_promo_codes.rb', 'db/migrate/create_promo_codes.rb'
        migration_template 'create_vehicles.rb', 'db/migrate/create_vehicles.rb'
        migration_template 'create_car_makes.rb', 'db/migrate/create_car_makes.rb'
        migration_template 'create_car_models.rb', 'db/migrate/create_car_models.rb'
        migration_template 'create_model_years.rb', 'db/migrate/create_model_years.rb'
        migration_template 'create_car_categories.rb', 'db/migrate/create_car_categories.rb'
        migration_template 'create_service_requests.rb', 'db/migrate/create_service_requests.rb'
        migration_template 'create_offers.rb', 'db/migrate/create_offers.rb'
        migration_template 'create_ratings.rb', 'db/migrate/create_ratings.rb'
        migration_template 'create_devices.rb', 'db/migrate/create_devices.rb'
        migration_template 'create_settings.rb', 'db/migrate/create_settings.rb'
        migration_template 'add_paid_to_offers.rb', 'db/migrate/add_paid_to_offers.rb'
      end
    end
  end
end
