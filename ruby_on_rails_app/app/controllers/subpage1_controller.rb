class Subpage1Controller < ApplicationController
  def new
    @container_width = 500
    @container_height = 350
    @imgs = [
      Img.new("coast.jpg", 600, 400, @container_width),
      Img.new("lights.jpg", 600, 278, @container_width),
      Img.new("forest.jpg", 300, 400, @container_width),
      Img.new("mountains.jpg", 299, 400, @container_width)
    ]
  end

  def go_back
    puts "todo"
    # redirect_to "/index/index"
  end
end

class Img
  attr_accessor :path
  attr_accessor :width
  attr_accessor :height

  def initialize(path, width, height, container_width)
    @path = path
    @width = container_width * 0.9
    ratio = @width.to_f / width
    @height = height * ratio
  end
end
