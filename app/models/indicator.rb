class Indicator < Datum
  delegate :min, :max, :to => :source
  alias_attribute :percent, :value

  def self.weighted_score( indis )
    indis.reject!{|i| i.percent.nil? || i.percent.nan?}
    sum = indis.reduce(0.0) do |sum, i|
      increment = i.percent * i.source.default_weight
      increment += 1.0 if i.source.default_weight < 0
      sum + increment
    end
    sum / indis.count.to_f * Rails.application.config.imon['max_score']
  end

  def calc_percent
    percent = (original_value-min) / (max-min)
    percent = 1 - percent if source.default_weight < 0
    self.percent = percent
  end
end
