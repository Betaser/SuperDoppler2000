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
$chart_width = "600px"
def update_data(file)
  f = File.open(file[0], "r")
  data = []
  f.each_line { |line| data << line }

  # What if we want to downscale the data?
  data = data.drop([ 0, data.length - $chart_data_size ].max())

  # data starts as a 1D array, but maybe let's format as [[time, data]...]
  # ideally t, h, p, wind direction, wind speed
  # type_to_index = [ "temperature (C)", "humidity (% RH)", "wind speed (m/s)", "wind direction (deg)" ]
  type_to_index = [ "temperature (C)", "humidity (% RH)" ]
  all_data = {}
  for key in type_to_index do
    all_data[key] = []
  end
  # Let's default to like dummy times
  dummy_times = []
  data.length.times { |n| dummy_times << n }

  dummy_times.each_with_index do |n, i|
    row = data[i]
    vals = row.split(",")

    all_data.each_key do |key|
      all_data[key] << [ n, vals[type_to_index.index(key)] ]
    end
  end

  formatted_data = []
  all_data.each do |key, val|
    formatted_data << { name: key, data: val }
  end

  ChartUpdater.set(formatted_data, $chart_width)

  Subpage1Controller.set_values(data)
end
