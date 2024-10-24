# == Schema Information
#
# Table name: preferences
#
#  id          :bigint           not null, primary key
#  name        :string
#  description :text
#  restriction :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer
#
class Preference < ApplicationRecord
    MAX_PREFERENCES = 5 
    validates :name, presence: true 
    validates :description, presence: true 
    validates :restriction, inclusion: { in: [true, false] } 
    
    belongs_to :user 
end


