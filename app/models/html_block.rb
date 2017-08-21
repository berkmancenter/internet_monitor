class HtmlBlock < Datum
    alias_attribute :html, :value
    def to_s
        html
    end
end
