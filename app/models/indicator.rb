class Indicator < Datum
    delegate :min, :max, :to => :source
    alias_attribute :percent, :value

    def calc_percent
        self.percent = (original_value-min) / (max-min)
    end
end
