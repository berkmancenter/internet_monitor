class BitlyFetcher

    USER_SESSION = 'amRjYw==|1366827650|23d440c1c3f308194d845a3422bf96f4f8285b3d'
    ACCESS_TOKEN = '6144641409982b8ed17e102c2534c0e9a94e7ea5'

    def popular_hashes(country, language = nil)
        cookie = "user=#{USER_SESSION}"
        params = {:rows => 3, :start => 0, :locn => country}
        params[:lang] = language if language

        response = HTTParty.get('http://rt.ly/search',
            {
                :query => params,
                :headers => {'Cookie' => cookie},
                :format => :json
            }
        )

        response['data']['results'].map do |result|
            result['globalhash']
        end
    end

    def link_info(ghash)
        response = HTTParty.get('https://api-ssl.bitly.com/v3/link/info',
                     {:query => {:link => link(ghash), :access_token => ACCESS_TOKEN}})
        puts response.request.inspect
        response
    end

    def extended_link(ghash)
        li = link_info(ghash)
        puts li
        li['data']['canonical_url']
    end

    def link(ghash)
        "http://bit.ly/#{ghash}"
    end

    def link_clicks(ghash)
        HTTParty.get('https://api-ssl.bitly.com/v3/link/clicks',
                     {:query => {:link => link(ghash), :access_token => ACCESS_TOKEN}})['data']['link_clicks']
    end

    def data(options = {})
        data = []
        Country.includes(:languages).all.each do |country|
            url_list = []
            country.languages.each do |language|
                popular = popular_hashes(country.iso_code.downcase, language.iso_code.downcase)
                next if popular.empty?
                popular.each do |hash|
                    url_list << [extended_link(hash), link_clicks(hash)]
                end
            end

            unless url_list.empty?
                url_list.sort_by!{|a| a[1]}.reverse!.map!{|a| a[0]}
                u = UrlList.new(:start_date => Date.today, :value => url_list)
                u.country = country
                u.save
                data << u
            end
        end
        data
    end
end
