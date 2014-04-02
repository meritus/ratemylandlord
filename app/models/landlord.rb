class Landlord < ActiveRecord::Base
  #Gets all of the ratings for the landlord
  def ratings
    Rating.where(landlord_id: id)
  end

  #Calculates the average ratings for the landlord
  def average_ratings
    avgs = Hash.new(0)
    rs = ratings
    rs.each do |r|
      Rating.categories.each { |c| avgs[c] += r.send(c) }
    end

    avgs.each { |k, v| avgs[k] = rs.empty? ? 0 : v/rs.length }

    return avgs
  end

  #Searches for landlords whose name contains the given string
  # results are sorted by the position of the string in the name
  def self.search(string)
    landlords = Landlord.where("name LIKE :search", search: "%#{string}%")
    sorted = []
    landlords.each do |l|
      pos = l.name.index(string)
      next if pos.nil?
      sorted << [l, pos]
    end
    sorted.sort! { |a, b| a[1] <=> b[1] }
    sorted.map {|a| a[0] }
  end
end