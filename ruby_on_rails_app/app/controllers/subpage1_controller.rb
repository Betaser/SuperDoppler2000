class Subpage1Controller < ApplicationController
  def self.set_temperature(data)
    @latest_temperature_data = data[-1][1]
    Turbo::StreamsChannel.broadcast_replace_to(
      "latest_temperature_channel",
      partial: "subpage1/latest_temperature",
      target: "latest_temperature",
      locals: { data: @latest_temperature_data }
    )
  end

  def index
    @latest_temperature_data = nil
    @container_width = 500
    @container_height = 350
    # Consider matching all files in a folder instead of hardcoded names
    # Sure, use the "subpage/" folder, name can be changed ofc
    # . is inside ruby_on_rails_app
    dir = Dir.new("./app/assets/subpage")
    @imgs = []
    dir.each_child do |item| 
      # Get the image size of stuff?
      png_extension = item[-3..-1]
      if png_extension == nil or png_extension != "png"
        puts "non png image ", item
        next
      end

      @imgs << item
    end
  end
end
