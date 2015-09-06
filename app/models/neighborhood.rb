class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, :through => :listings

  def neighborhood_openings(date_one,date_two)
      results=[]
      listings.each do |listing|
        results << listing
      end
      results
  end

  def self.highest_ratio_res_to_listings
    cities = {}
    all.each do |city|
      cities[city]=city.reservations.count/city.listings.count unless city.listings.count == 0
    end
    cities.max_by{|k,v| v}.first
  end

  def self.most_res
    cities={}
    all.each do |city|
      cities[city]=city.reservations.count
    end
    cities.max_by{|k,v| v}.first
  end
end
