# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  api_token              :string
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  failed_attempts        :integer          default(0), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  locked_at              :datetime
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  unlock_token           :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_api_token             (api_token)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  before_create :generate_api_token
  before_save :generate_api_token, if: :reset_api_token?

  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable,
         :trackable, :lockable

  attribute :reset_api_token, :boolean, default: :false

  private

  def generate_api_token
    self.api_token ||= SecureRandom.hex(20)
  end
  
end
