class SettingsController < ApplicationController
  # need index.
  def index
    # index, and name of function to call(?)
    @rows = [
      [ 0, "Rescale home chart" ],
      [ 1, "Resize home chart" ]
    ]
    fn = params[:fn]
    # ind = params[:index]
    text = params[:input_value]
    case fn
    when "Rescale home chart"
      # puts "ind", ind
      # puts "text", text
      rescale_text = text.to_i
      $chart_data_size = [ 1, [ 9, rescale_text ].min ].max
      # puts "value???\n\n\n", $chart_data_size, "\n\n\n"
    when "Resize home chart"
      $chart_width = "#{text.to_i}px"
    else
      puts "Not sure how to call fn ", fn
    end
    # puts "\n\n\nindex called\n\n\n"
  end
end
