class Asset < ActiveRecord::Base
  belongs_to :paper
  has_attached_file :image
end
