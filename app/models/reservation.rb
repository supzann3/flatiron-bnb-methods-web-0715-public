class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  delegate :hosts, to: :listing
  validates :checkin, :checkout, presence: true, uniqueness: true
  validate :same_ids, :same_dates,:date_unavailable, :checkout_before_checkin

  def duration
    checkout-checkin
  end

  def total_price
    listing.price * duration
  end

  private

  def same_ids
    if listing.host_id == guest_id
      errors.add(:same_ids,"You cannot reserve under your listing")
    end
  end

  def same_dates
    if checkin && checkout
      if checkin==checkout
        errors.add(:same_dates, "You cannot checkin and checkout on the same date")
      end
    end
  end

  def date_unavailable
    if checkin && checkout
      listing.reservations.each do |reservation|
        if reservation.checkout > checkin && reservation.checkin < checkout
        errors.add(:date_unavailable,"These dates are unavailable")
        end
      end
    end
  end

  def checkout_before_checkin
    if checkin && checkout
      if duration < 0
      errors.add(:checkout_before_checkin,"You cannot checkout before your checkin date")
      end
    end
  end

 end
