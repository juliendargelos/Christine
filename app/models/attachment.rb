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
    include HasExtendedJson

    belongs_to :product

    has_attached_file :file, styles: {normal: "500x500", medium: "150x150", thumb: "200x50"}

    validates_attachment :file, presence: true, content_type:  { content_type: ["image/jpeg", "image/gif", "image/png"] }

    def as_json options = {}
        options = json_options options
        json = base_as_json options[:base]
        if options[:extended].has_key? :file
            json[:file] = {} unless json[:file].is_a? Hash
            if options[:extended][:file].has_key? :url
                file_options = options[:extended][:file]
                json[:file][:url] = file.url(file_options[:url]) if file_options.has_key? :url
            end
        end

        json
    end
end
