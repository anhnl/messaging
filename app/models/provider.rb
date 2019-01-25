class Provider
  PROVIDERS = [ { name: 1, weight: 3 }, { name: 2, weight: 7 } ]

  def initialize
    @selected = nil
    @weights = []
  end

  def pick
    get_weights
    @selected = @weights.sample
    ENV["provider_#{@selected}"]
  end

  private

  def get_weights
    @weights = []
    PROVIDERS.reject { |p| p[:name] == @selected }.each do |provider|
      @weights.concat provider[:weight].times.map { provider[:name] }
    end
  end
end