class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood_id

  before_create :change_host_status
  after_destroy :change_host

  def average_review_rating
    reviews.average(:rating).to_f
    # result=Review.all
    # average=[]
    # result.each do |place|
    #   average << place.rating.to_f
    # end
    # average.inject{ |sum, el| sum + el }.to_f / average.size
  end

  private

  def change_host_status
    host.update(host: true)
  end

  def change_host
    if host.listings.count==0
      host.update(host:false)
    end
  end
end
