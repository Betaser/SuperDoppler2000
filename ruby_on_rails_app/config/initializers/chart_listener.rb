require "listen"

# I don't want ActionCable logging all the time
ActionCable.server.config.logger = Logger.new(nil)

path = Rails.root.join("app/assets/").to_s

listener = Listen.to(path) do |modified, added, removed|
  update_data(modified)
end

listener.start()

# Global variable below, will be edited by other scripts.
$chart_data_size = 4
def update_data(file)
  f = File.open(file[0], "r")
  data = []
  f.each_line { |line| data << line.to_f }

  # What if we want to downscale the data?
  data = data.drop(data.length - $chart_data_size)

  # data starts as a 1D array, but maybe let's format as [[time, data]...]
  timed_data = []
  # Let's default to like dummy times
  dummy_times = []
  data.length.times { |n| dummy_times << n }
  dummy_times.each_with_index do |n, i|
    timed_data << [ n, data[i] ]
  end

  ChartUpdater.set(timed_data)

  Subpage1Controller.set_temperature(timed_data)
end
