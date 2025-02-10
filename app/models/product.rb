# == Schema Information
#
# Table name: products
#
#  id         :bigint           not null, primary key
#  chuds      :integer
#  sku        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Product < ApplicationRecord
end
