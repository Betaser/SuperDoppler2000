class ChartUpdater
  def self.set(data)
    puts "\n\ntransmitting data #{data} \n\n"
    Turbo::StreamsChannel.broadcast_replace_to(
      "chart_channel",
      target: "main_chart",
      partial: "subpage1/chart_content",
      locals: { data: data }
    )
  end
end
