class Indicator < Datum
  # attr_accessible :title, :body
    delegate :min, :max, :to => :source

    def calc_value
        self.value = (original_value-min) / (max-min) * 10.0
    end
end
