class Setting < RailsSettings::Base
  store Rails.root.join( 'config/app.yml' )
end