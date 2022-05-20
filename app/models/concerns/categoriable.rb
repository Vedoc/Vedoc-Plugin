require 'active_support/concern'

module Categoriable
  extend ActiveSupport::Concern

  # rubocop:disable Style/RescueModifier

  # To allow string representation of integer as category value
  def category=( value )
    int = Integer( value ) rescue nil

    int ? super( int ) : super
  end

  # rubocop:enable Style/RescueModifier
end
