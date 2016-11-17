# == Schema Information
#
# Table name: products
#
#  id          :integer          not null, primary key
#  name        :string
#  price       :integer
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Product < ActiveRecord::Base
	has_many :attachments

	validates :name, presence: true
	validates :price, presence: true, numericality: { greater_than: 0 }
	validates :description, presence: true
end
