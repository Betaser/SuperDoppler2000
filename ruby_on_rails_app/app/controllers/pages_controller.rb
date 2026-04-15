class PagesController < ApplicationController
  IMAGE_ROOT = "/home/aslamovi/live_output".freeze
  SECTORS = ["Full Disk", "Mesoscale 1", "Mesoscale 2"].freeze
  IMAGE_EXTENSIONS = %w[png jpg jpeg webp gif].freeze

  def home
  end

  def goes18
    @satellite = "GOES-18"
    @decks = build_decks_for(@satellite)
    render :satellite
  end

  def goes19
    @satellite = "GOES-19"
    @decks = build_decks_for(@satellite)
    render :satellite
  end

  def display_image
    requested_path = params[:path].to_s
    absolute_path = File.expand_path(requested_path)

    unless absolute_path.start_with?(IMAGE_ROOT + "/") && File.file?(absolute_path)
      head :not_found
      return
    end

    send_file absolute_path, disposition: "inline"
  end

  private

  def build_decks_for(satellite)
    session_dir = latest_session_dir

    return [] if session_dir.nil?

    decks = SECTORS.map do |sector|
      frames = frames_for(session_dir, satellite, sector)

      {
        title: sector,
        frames: frames
      }
    end
    decks
  end

  def latest_session_dir
    session_dirs = Dir.glob(File.join(IMAGE_ROOT, "*")).select { |path| File.directory?(path) }
    session_dirs.max_by { |path| File.basename(path) }
  end

  def frames_for(session_dir, satellite, sector)
    patterns = IMAGE_EXTENSIONS.map do |extension|
      File.join(session_dir, "IMAGES", satellite, sector, "*", "*.#{extension}")
    end

    files = patterns.flat_map { |pattern| Dir.glob(pattern) }
                    .select { |path| File.file?(path) }

    sorted_files = files.sort_by do |path|
      extract_timestamp_from_path(path) || File.mtime(path)
    end

    recent_files = sorted_files.last(20)

    frames = recent_files.map do |path|
      {
        image_url: display_image_path(path: path),
        source_path: path,
        timestamp_label: format_timestamp_label(path)
      }
    end
    frames
  end

  def extract_timestamp_from_path(path)
    match = path.match(/(\d{4}-\d{2}-\d{2}_\d{2}-\d{2}-\d{2})/)
    return nil unless match

    Time.strptime(match[1], "%Y-%m-%d_%H-%M-%S")
  rescue ArgumentError
    nil
  end

  def format_timestamp_label(path)
    timestamp = extract_timestamp_from_path(path)
    return "Unknown time" if timestamp.nil?

    timestamp.strftime("%Y-%m-%d %H:%M:%S")
  end
end