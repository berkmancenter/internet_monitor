class HerdictFetcher
  def top_sites_by_country(country_code)
    start_date = Date.today - 365
    start_date = start_date.strftime('%m/%d/%Y')
    response = response(country_code, start_date)
    sites = parse_response(response)
    sites.sort_by!{|s| s[1] }.reverse!.delete_if{|s| s[1] == 0}.map{|s| s[0]}
  end

  def parse_response(response)
    sites = []
    doc = Nokogiri::HTML(response)
    doc.css('.topitems-list li').each do |li|
      sites << [li.at('a').text, (li > '.inaccessible').text.to_i]
    end
    sites
  end

  def response(country_code, start_date)
    HTTParty.get("http://www.herdict.org/explore/module/topsitescategory?631=&fc=#{URI.encode(country_code)}&fsd=#{URI.encode(start_date)}").body
  end

  def data(options = {})
    data = []
    Country.all.each do |country|
      sites = top_sites_by_country(country.iso_code)
      u = UrlList.new(:start_date => Date.today - 365, :value => sites)
      u.country = country
      data << u
    end
    data
  end
end
