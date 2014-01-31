class HerdictFetcher
  def top_sites_by_country( country_code, year )
    response country_code, "1/1/#{year}", "12/31/#{year}"
  end

  def response( country_code, start_date, end_date )
    HTTParty.get("http://www.herdict.org/explore/module/topsitescategory?fc=#{country_code}&fsd=#{URI.encode(start_date)}&fed=#{URI.encode( end_date )}").body
  end

  def data(options = {})
    data = []
    Country.all.each { |country|
      sites = top_sites_by_country(country.iso_code, 2013)
      d = HtmlBlock.new start_date: '2013-01-01', value: sites
      d.country = country
      data << u
    }

    data
  end
end
