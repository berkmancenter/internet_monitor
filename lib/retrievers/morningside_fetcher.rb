class MorningsideFetcher

    BASE_URL = 'http://ip5416.blogdns.com:8080/api'
    SESSION_COOKIE = '_maviewer_front_rails_session=BAh7CjoQX2NzcmZfdG9rZW4iMUJnOEJVOXJlM1pyTm9Ma1FXQldtRkJKLytUaVI5YTF2V2ttYWNtRHpOWTg9Ogx1c2VyX2lkaQGOIhthczptYV9jbGllbnRzL3Byb2plY3RzewY6CWxpc3R7BiIJcGFnZWkGOg9zZXNzaW9uX2lkIiUwOTM2ZTM1Y2M1ZGVhNDBlOTdiY2RmMmU5NWNmZWY5NiIKZmxhc2hJQzonQWN0aW9uQ29udHJvbGxlcjo6Rmxhc2g6OkZsYXNoSGFzaHsABjoKQHVzZWR7AA%3D%3D--87076ea37f5a53ddfec4ca00f7c8d45186ba51bd'
    LANGUAGE_MAP = {
        'Arabic_2013_alpha1' => 'ar',
        'China_2012_tw_2' => 'zh',
        'Egypt_auto3_hardFilt_foIN' => 'ar',
        'Farsi_2012_final' => 'fa',
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
                :headers => {'Cookie' => SESSION_COOKIE}
            }
        ).body
    end

    def data(options = {})
        data = []
        clustermaps.each do |map|
            language_iso_code = LANGUAGE_MAP[map['name']]
            next unless language_iso_code
            language = Language.find_by_iso_code(language_iso_code)
            datum = JsonObject.new(:start_date => Date.today, :value => clustermap(map['id']))
            datum.language = language
            datum.save!
            data << datum
        end
        data
    end
end
