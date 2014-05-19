class MorningsideFetcher

    BASE_URL = 'http://ip5416.blogdns.com:8080/api'
    SESSION_COOKIE = '_maviewer_front_rails_session=BAh7CjoQX2NzcmZfdG9rZW4iMUJnOEJVOXJlM1pyTm9Ma1FXQldtRkJKLytUaVI5YTF2V2ttYWNtRHpOWTg9Ogx1c2VyX2lkaQGOIhthczptYV9jbGllbnRzL3Byb2plY3RzewY6CWxpc3R7BiIJcGFnZWkGOg9zZXNzaW9uX2lkIiUwOTM2ZTM1Y2M1ZGVhNDBlOTdiY2RmMmU5NWNmZWY5NiIKZmxhc2hJQzonQWN0aW9uQ29udHJvbGxlcjo6Rmxhc2g6OkZsYXNoSGFzaHsABjoKQHVzZWR7AA%3D%3D--87076ea37f5a53ddfec4ca00f7c8d45186ba51bd'

    LANGUAGE_MAP = {
      252 => 'ar',
      197 => 'fa',
      117 => 'fa'
    }

    COUNTRY_MAP = {
      139 => 'CHN',
      182 => 'EGY',
      210 => 'SAU',
      275 => 'PSE',
      100 => 'RUS',
      132 => 'RUS',
      194 => 'TUN'
    }

    def clustermaps
        HTTParty.get("#{BASE_URL}/clustermaps/list",
            {
                :headers => {'Cookie' => SESSION_COOKIE},
                :format => :json
            }
        ).parsed_response
    end

    def clustermap(id)
        HTTParty.get("#{BASE_URL}/clustermaps/show",
            {
                :query => {
                    :clusterMapId => id
                },
                :headers => {'Cookie' => SESSION_COOKIE},
                :timeout => 120
            }
        ).body
    end

    def data(options = {})
        data = []
        clustermaps.each do |map|
            puts map.inspect
            language_iso_code = LANGUAGE_MAP[map['id']]
            country_iso_code = COUNTRY_MAP[map['id']]
            next unless language_iso_code || country_iso_code

            datum = nil

            if language_iso_code.present?
              puts "  *importing as language: #{language_iso_code}"
              language = Language.find_by_iso_code(language_iso_code)
              datum = JsonObject.new(:start_date => Date.today, :value_id => map['id'], :value => clustermap(map['id']))
              datum.language = language
              datum.save!
              data << datum
            else # country_iso_code
              puts "  *importing as country: #{country_iso_code}"
              country = Country.find_by_iso3_code country_iso_code
              datum = JsonObject.new(:start_date => Date.today, :value_id => map['id'], :value => clustermap(map['id']))
              datum.country = country
              datum.save!
            end

            data << datum unless datum.nil?
        end
        data
    end
end
