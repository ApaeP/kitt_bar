require_relative 'batch'

class OldBatch < Batch
  attr_reader :slug

  def initialize(attr = {})
    super
  end

  def feedbacks_url
    "https://kitt.lewagon.com/camps/#{@slug}/feedbacks"
  end
end
