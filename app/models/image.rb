class Image < Datum
  # attr_accessible :title, :body
    def src
        value[:src]
    end

    def alt
        value[:alt]
    end
end
