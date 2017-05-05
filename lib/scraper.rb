require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    arr = []
    student_reader = Nokogiri::HTML(File.read(index_url)).css("div.student-card")
    student_reader.each do |student|
      arr << {
        name: student.css("h4.student-name").text,
        location: student.css("p.student-location").text,
        profile_url: student.css("a").attribute("href").text
      }
    end
    arr
  end

  def self.scrape_profile_page(profile_url)
    profile_reader = Nokogiri::HTML(File.read(profile_url))
    hash = {}
    profile_reader.css("div.social-icon-container a").each do |link|
      value = link.attribute("href").text
      arr = value.split(".").collect { |fracture| fracture.split("/") }.flatten
      sym = arr.find { |frac| frac == "twitter" || frac == "linkedin" || frac == "github" }
      sym ||= "blog"
      hash[sym.to_sym] = value
    end
    hash[:bio] = profile_reader.css("div.description-holder p").text
    hash[:profile_quote] = profile_reader.css("div.profile-quote").text
    hash
  end

end
