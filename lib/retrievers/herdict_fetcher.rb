class HerdictFetcher
  def quickstats_by_country( country_code, year )
    start_date = "1/1/#{year}"
    end_date = "12/31/#{year}"
    r = HTTParty.get("http://www.herdict.org/explore/module/quickstats?fc=#{country_code}&fsd=#{URI.encode(start_date)}&fed=#{URI.encode( end_date )}")
    r.body
  end

  def top_sites_by_country( country_code, year )
    start_date = "1/1/#{year}"
    end_date = "12/31/#{year}"
    r = HTTParty.get("http://www.herdict.org/explore/module/topsitescategory?fc=#{country_code}&fsd=#{URI.encode(start_date)}&fed=#{URI.encode( end_date )}")

    sites = r.body

    # remove script content
    doc = Nokogiri::HTML.fragment sites
    doc.css( 'script' ).remove
    doc_s = doc.to_s
    if doc_s.size > 8000
      doc_s
    else
      ''
    end
  end

  def data(options = {})
    data = []
    Country.all.each { |country|
      sites = quickstats_by_country(country.iso_code, 2013)
      sites = sites + top_sites_by_country(country.iso_code, 2013)

      d = HtmlBlock.new start_date: '2013-01-01', value: sites, value_id: country.iso3_code
      d.country = country
      data << d
    }

    data
  end
end
