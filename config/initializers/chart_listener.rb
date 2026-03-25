require "listen"

path = Rails.root.join("app/assets/").to_s

listener = Listen.to(path) do |modified, added, removed|
  update_data(modified)
end

listener.start()

def update_data(file)
  f = File.open(file[0], "r")
  data = []
  f.each_line { |line| data << line.to_f }
  # puts "TODO, call index controller's method"

  # data starts as a 1D array, but maybe let's format as [[time, data]...]
  timed_data = []
  # Let's default to like dummy times
  dummy_times = []
  10.times { |n| dummy_times << n }
  dummy_times.each_with_index do |n, i|
    timed_data << [ n, data[i] ]
  end
  ChartUpdater.set(timed_data)
end
