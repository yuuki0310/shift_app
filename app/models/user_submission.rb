class UserSubmission < ApplicationRecord
  belongs_to :user
  belongs_to :shift_section
end
