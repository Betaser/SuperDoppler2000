class Subpage1Controller < ApplicationController
  def self.calc_cardinal(data)
    cardinals = [ "North", "Northeast", "East", "Southeast", "South", "Southwest", "West", "Northwest" ]
    angle = (data + 22.5) % 360
    ind1 = (angle / 45).to_i

    # N 0 - 22.5
    # NNE 22.5 - 45
    # NE 45 - 67.5
    # ESE 67.5 - 90
    angle2 = (data + 11.25) % 360
    ind2 = (angle2 / 45).to_i
    # puts "data for angle2 #{data} angle2 #{angle2}"
    if (angle2 / 22.5).to_i % 2 == 1 then
      if ind2 % 2 == 1 then
        cardinal = "#{cardinals[(ind2 + 1) % 8]}-#{cardinals[ind2]}"
      else
        cardinal = "#{cardinals[ind2]}-#{cardinals[(ind2 + 1) % 8]}"
      end
    else
      cardinal = cardinals[ind1]
    end
    return cardinal
  end

  def self.set_values(values)
    @latest_data = values[-1].split(",")
    # ideally would be t, h, p, a, w
    for data, data_type in @latest_data.zip([ "temperature", "humidity" ]) do
      data = data.to_f().round(2)
      locals = { data: data }
      if data_type == "angle" then
        cardinal = self.calc_cardinal(data)
        locals = { data: data, cardinal: cardinal }
      end
      Turbo::StreamsChannel.broadcast_replace_to(
        "latest_#{data_type}_channel",
        partial: "subpage1/latest_#{data_type}",
        target: "latest_#{data_type}",
        locals: locals
      )
    end
  end

  def index
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

# for i in 0..360 do
#   puts "i: #{i} cardinal: #{Subpage1Controller.calc_cardinal(i)}"
# end
