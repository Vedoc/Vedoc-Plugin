class Account < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable,
         :omniauthable, :trackable, :lockable, :timeoutable
  include ::DeviseTokenAuth::Concerns::User if defined? ::DeviseTokenAuth

  scope :clients, -> { where accountable_type: 'Client' }
  scope :business_owners, -> { where accountable_type: 'Shop' }

  belongs_to :accountable, polymorphic: true, autosave: true
  has_many :devices, dependent: :destroy

  # Callbacks
  after_create :ensure_approved

  # Delegations
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

  def send_reset_password_instructions(opts = {})
    token = set_reset_code

    opts[:client_config] ||= 'default'
    send_devise_notification :reset_password_instructions, token, opts

    token
  end

  def active_for_authentication?
    true
  end

  private

  def approved?
    Rails.logger.debug("Account #{id} check - Type: #{accountable_type}, Accountable: #{accountable.inspect}")
    
    if client?
      approved = accountable&.approved?
      Rails.logger.debug("Client approval status: #{approved}")
      return approved
    elsif business_owner?
      approved = accountable&.approved?
      Rails.logger.debug("Business owner approval status: #{approved}")
      return approved
    end
  
    Rails.logger.debug("No valid accountable type found")
    false
  end
  

  def ensure_approved
    return unless accountable.present?
    
    if client?
      accountable.update_column(:approved, true) unless accountable.approved?
    elsif business_owner?
      accountable.update_column(:approved, true) unless accountable.approved?
    end
  end

  def set_reset_code
    code = random_reset_code
    $redis.setex email, Setting.find_by(var: 'password_reset_duration').value.to_i, code
    code
  end

  def random_reset_code
    (SecureRandom.random_number(9e6) + 1e6).to_i
  end
end