class SettingsController < ApplicationController
  # need index.
  def index
    # index, and name of function to call(?)
    @rows = [
      [ 0, "Rescale home chart" ],
      [ 1, "Rescale diff chart (TODO)" ]
    ]
    fn = params[:fn]
    ind = params[:index]
    text = params[:input_value]
    case fn
    when "Rescale home chart"
      puts "ind", ind
      puts "text", text
      rescale_text = text.to_i
      $chart_data_size = [ 1, [ 9, rescale_text ].min ].max
      puts "value???\n\n\n", $chart_data_size, "\n\n\n"
    else
      puts "Not sure how to call fn ", fn
    end
    # puts "\n\n\nindex called\n\n\n"
  end
end
