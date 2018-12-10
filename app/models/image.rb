class Image < ApplicationRecord
  has_attached_file :submission, 
                    styles: {
                      medium: '300x300>'
                    }

  # Validate the attached image is image/jpg, image/png, etc
  validates_attachment_content_type :submission, :content_type => /\Aimage\/.*\Z/
                  
  SITES = ["MACHRIE", "HOLYROOD"]
  SOURCE = ["TWITTER", "INSTAGRAM", "UPLOAD"]
  MACHRIE_CATGORIES = %w(negligible light moderate heavy extensive n/a)

  scope :reliable, -> { where(reliable: true) }

  def self.to_csv
    attributes = %w{id site category record_taken url source watson_info weather_info reliable record_taken insta_user_id twitter_user_id created_at updated_at}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |image|
        csv << attributes.map do |attr|
          if attr == 'weather_info'
            set_weather_attribute(image, attr)
          elsif attr == 'record_taken'
            set_record_taken_attribute(image, attr)
          else
           image.send(attr)
          end
        end
      end
    end
  end

  def self.set_weather_attribute(image, attr)
    !image.send(attr).nil? ? image.send(attr)["data"][0]["icon"].gsub('-',' ') : image.send(attr)
  end

  def self.set_record_taken_attribute(image, attr)
    !image.send(attr).nil? ? image.send(attr).to_date : image.send(attr)
  end

  def machrie?
    self.site == "MACHRIE"
  end

  def holyrood?
    self.site == "HOLYROOD"
  end

  def other_locations
    Image::SOURCE.reject { |i| i == self.source.upcase }
  end
end
