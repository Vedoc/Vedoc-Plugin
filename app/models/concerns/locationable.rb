require 'active_support/concern'

module Locationable
  extend ActiveSupport::Concern

  included do
    scope :nearest, lambda { | source, ordering = :asc, limit = nil |
      source_point = sanitize_sql_array [ 'ST_SetSRID(ST_MakePoint(?, ?), 4326)', source.lon, source.lat ]
      table_name = name.tableize

      # Arel.sql is used to supress deprecation warning
      select( "#{ table_name }.*, ST_Distance(#{ table_name }.location, #{ source_point }) AS distance" )
        .order( Arel.sql( "ST_Distance(#{ table_name }.location, #{ source_point })" ) => ordering ).limit limit
    }

    scope :within_distance, lambda { | source, distance = Setting.default_radius, ordering = :asc, limit = 30 |
      source_point = sanitize_sql_array [ 'ST_SetSRID(ST_MakePoint(?, ?), 4326)', source.lon, source.lat ]
      table_name = name.tableize

      # Arel.sql is used to supress deprecation warning
      nearest( source, ordering, limit ).where(
        Arel.sql( "ST_DWithin(#{ table_name }.location, #{ source_point }, :distance)" ), distance: distance
      )
    }

    validates :address, presence: true, if: -> { location.present? }
  end

  def pretty_location
    return nil unless location

    {
      'long' => location.lon,
      'lat' => location.lat
    }
  end

  def location=( data )
    data ||= {}

    super "POINT(#{ data[ 'long' ] } #{ data[ 'lat' ] })"
  end

  def distance_in_miles
    ( attributes[ 'distance' ] * 0.000621371 ).round( 2 ) if attributes[ 'distance' ]
  end
end
