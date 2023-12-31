class Task < ApplicationRecord
    validates :name, presence: true
    validates :status, inclusion: { in: %w(onprogress done),
                                    message: "%{value} is not a valid" }
    validate :past_date

    belongs_to :user

    def past_date
        if self.deadline.present? && self.deadline.past?
            errors.add(:deadline, 'is past')
        end
    end
end