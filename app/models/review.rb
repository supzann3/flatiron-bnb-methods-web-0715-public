class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates_presence_of :rating, :description, :reservation_id
  validate :valid_review

  private
  def valid_review
    if reservation && reservation.status=="accepted" && reservation.checkout > Date.today
      errors.add(:review, "Invalid review")
    end
  end

end
