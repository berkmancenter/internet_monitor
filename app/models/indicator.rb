class Indicator < Datum
    delegate :min, :max, :to => :source
    alias_attribute :percent, :value

    def calc_percent
        percent = (original_value-min) / (max-min)
        percent = 1 - percent if source.default_weight < 0
        self.percent = percent
    end
end
