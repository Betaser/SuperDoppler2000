class IndexController < ApplicationController
  def index
    @data = []
    # 10.times { |i| @data.append([ i, Random.rand(10) ]) }
    10.times { @data.append(0) }
  end

  def update_data(data)
    @data = data
    """
    # Too lazy to actually read file contents for now
    val = [@data.len, Random.rand(10)]
    puts @data
    @data.delete_at 0
    @data.append val
    """
  end
end
