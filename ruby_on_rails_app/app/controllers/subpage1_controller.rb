class Subpage1Controller < ApplicationController
  def self.set_temperature(data)
    @latest_temperature_data = data[-1].split(",")[0].to_f
    Turbo::StreamsChannel.broadcast_replace_to(
      "latest_temperature_channel",
      partial: "subpage1/latest_temperature",
      target: "latest_temperature",
      locals: { data: @latest_temperature_data }
    )
  end

  def self.set_humidity(data)
    @latest_data = data[-1].split(",")[1].to_f
    Turbo::StreamsChannel.broadcast_replace_to(
      "latest_humidity_channel",
      partial: "subpage1/latest_humidity",
      target: "latest_humidity",
      locals: { data: @latest_data }
    )
  end

  def self.set_values(values)
    @latest_data = values[-1].split(",")
    for data, data_type in @latest_data.zip(["temperature", "humidity", "pressure"]) do
      data = data.to_f
      Turbo::StreamsChannel.broadcast_replace_to(
        "latest_#{data_type}_channel",
        partial: "subpage1/latest_#{data_type}",
        target: "latest_#{data_type}",
        locals: { data: data }
      )
    end
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
