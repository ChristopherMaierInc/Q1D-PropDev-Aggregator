# Marketing/Propery Development Aggregator App
# --------------------------------------------

# Gems required
require 'Nokogiri'
require 'open-uri'
require 'net_http_ssl_fix'
require 'filemagic'

# Create the output file
output = File.new('output.txt', 'w+')

# Array of all URLs
links = [
  'http://ee24.com',
  'http://www.core-me.com',
  'http://off-planproperties.ae',
  'https://www.theurbandeveloper.com',
  'https://www.reidin.com/en-AE',
  # 'https://www.masterbuilders.com.au/', creates incorrect header check error
  'https://propertyeu.info',
  'https://europroperty.com',
  'https://pie-mag.com',
  'https://www.asteco.com'
]

# Array of crawled results
results = []

# Web crawler logic
links.each do |url|
  @imagesArray = []
  @doc = Nokogiri::HTML(open(url))
  @title = @doc.xpath('//head//title').first.content
  @title = @title.squeeze(" ").gsub(/[^a-zA-Z0-9. ]/, '')
  if @title[0] == " "
    @title = @title.strip
  end
  @images = @doc.xpath('//img//@src')
  @images.each do |image|
    if image.content.slice(0, 4) != "http"
      image = "#{url}#{image.content}"
      if FileMagic.open(:mime) { |fm|
        fm.file(image, true)
      } == "image/jpeg"
        @imagesArray << image
      end
    end
  end
  results << {name: @title, images: @imagesArray}
end

# Output all crawled data to text file
output.write(results)

# Prints contents of titles and images arrays to the screen
puts results
