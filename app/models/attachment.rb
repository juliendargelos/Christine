# == Schema Information
#
# Table name: attachments
#
#  id                :integer          not null, primary key
#  file_file_name    :string
#  file_content_type :string
#  file_file_size    :integer
#  file_updated_at   :datetime
#  product_id        :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Attachment < ActiveRecord::Base
    belongs_to :product

    has_attached_file :file, styles: {normal: "100x100#"}

    validates_attachment :file, presence: true, content_type: /\Aimage\//
end
