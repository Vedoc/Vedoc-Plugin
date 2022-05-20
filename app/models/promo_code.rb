class PromoCode < ApplicationRecord
  belongs_to :shop

  validates :shop, :email, presence: true

  def expired?
    sent_at && ( sent_at + Setting.promo_code_duration < Time.now.utc )
  end

  def set_code_token
    raw, enc = Devise.token_generator.generate self.class, :code_token

    self.code_token = enc
    self.sent_at = Time.now.utc
    save validate: false

    raw
  end

  def self.with_code_token( token )
    code_token = Devise.token_generator.digest self, :code_token, token

    to_adapter.find_first code_token: code_token, activated_at: nil
  end
end
