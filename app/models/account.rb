class Account < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include ::DeviseTokenAuth::Concerns::User if defined? ::DeviseTokenAuth

  scope :clients, -> { where accountable_type: 'Client' }
  scope :business_owners, -> { where accountable_type: 'Shop' }

  belongs_to :accountable, polymorphic: true, autosave: true
  has_many :devices, dependent: :destroy

  delegate :vehicles, to: :accountable, allow_nil: true
  delegate :service_requests, to: :accountable, allow_nil: true
  delegate :name, to: :accountable, allow_nil: true
  delegate :location, to: :accountable, allow_nil: true

  def client?
    accountable_type == 'Client'
  end

  def business_owner?
    accountable_type == 'Shop'
  end

  def send_reset_password_instructions( opts = {} )
    token = set_reset_code

    opts[ :client_config ] ||= 'default'
    send_devise_notification :reset_password_instructions, token, opts

    token
  end

  def active_for_authentication?
    super && approved?
  end

  private

  def approved?
    return true if client?

    accountable.approved?
  end

  def set_reset_code
    code = random_reset_code

    Redis.current.setex email, Setting.password_reset_duration, code

    code
  end

  def random_reset_code
    ( SecureRandom.random_number( 9e6 ) + 1e6 ).to_i
  end
end
