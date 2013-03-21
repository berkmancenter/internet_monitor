class HtmlBlock < Datum
  # attr_accessible :title, :body
    alias_attribute :html, :value
    def to_s
        html
    end
end
