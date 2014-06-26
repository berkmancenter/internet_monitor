class Indicator < Datum
  delegate :min, :max, :to => :source
  alias_attribute :percent, :value

  def self.weighted_score( indis )
    # calculate the score for a group of indicators
    # called by each country with the most recent indicators affecting score

    # reject all empty indicators
    indis.reject!{|i| i.percent.nil? || i.percent.nan?}

    # run through all the indicators and produce a sum
    sum = indis.reduce(0.0) do |sum, i|
      # with each indicator...

      # multiply by the default weight
      # will also turn value negative if it's a backwards indicator
      increment = i.percent * i.source.default_weight

      # if it's a backwards indicator, add one
      # (since backwards indicator values are now negative by this point)
      increment += 1.0 if i.source.default_weight < 0

      # add this value to the growing sum
      sum + increment
    end

    # the final sum is the average of indicator values calculated above
    sum / indis.count.to_f

    # weighted_score is no longer multiplied by the max_score here,
    # that is done at the end of calculating scores for each group
  end

  def calc_percent
    if source.normalized != true
      self.percent = 1.0
      unless (max-min) == 0
        percent = (original_value-min) / (max-min)
        percent = 1 - percent if source.default_weight < 0
        self.percent = percent
      end
    end
  end
end
