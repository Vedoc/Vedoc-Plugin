# RailsSettings Model
class Setting < RailsSettings::Base
  # cache_prefix { "v1" }
  defaults[:my_awesome_settings] = 'This is my settings'
   
  # scope :application do
  #   field :app_name, default: "Rails Settings", validates: { presence: true, length: { in: 2..20 } }
  #   field :host, default: "http://example.com", readonly: true
  #   field :default_locale, default: "zh-CN", validates: { presence: true, inclusion: { in: %w[zh-CN en jp] } }, option_values: %w[en zh-CN jp], help_text: "Bla bla ..."
  #   field :admin_emails, type: :array, default: %w[admin@rubyonrails.org]

  #   # lambda default value
  #   field :welcome_message, type: :string, default: -> { "welcome to #{self.app_name}" }, validates: { length: { maximum: 255 } }
  #   # Override array separator, default: /[\n,]/ split with \n or comma.
  #   field :tips, type: :array, separator: /[\n]+/
  # end

  # scope :limits do
  #   field :user_limits, type: :integer, default: 20
  #   field :exchange_rate, type: :float, default: 0.123
  #   field :captcha_enable, type: :boolean, default: true
  # end

  # field :notification_options, type: :hash, default: {
  #   send_all: true,
  #   logging: true,
  #   sender_email: "foo@bar.com"
  # }

  # field :readonly_item, type: :integer, default: 100, readonly: true
end
