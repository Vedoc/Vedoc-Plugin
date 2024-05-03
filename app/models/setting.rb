# class Setting < RailsSettings::Base
#   source Rails.root.join( 'config/app.yml' )
# end
class Settings < RailsSettings::CachedSettings
  defaults[:my_awesome_settings] = 'This is my settings'
end