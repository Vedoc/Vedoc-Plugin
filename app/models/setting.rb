class Setting < RailsSettings::Base
  source Rails.root.join( 'config/app.yml' )
end
