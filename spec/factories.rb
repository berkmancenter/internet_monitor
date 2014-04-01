FactoryGirl.define do
  factory :country do
    # iran is a valid test country with a language and datum for: access, & control
    factory :iran do
      name 'Iran'
      iso_code 'IR'
      iso3_code 'IRN'
      description ''
    end

    # china is also a country with enough data to be on the map & in the index
    factory :china do
      name 'China'
      iso_code 'CN'
      iso3_code 'CHN'
      description nil
    end

    # usa only has one indicator: access
    # therefore it appears as 'without scores'
    factory :usa do
      name 'United States'
      iso_code 'US'
      iso3_code 'USA'
      description nil
    end

    factory :country_nil_score do
      name 'nil_score'
      iso_code 'NS'
      iso3_code 'CNS'
      description 'nil_score'
    end
  end

  factory :language do
    factory :persian do
      name 'Persian'
      iso_code 'fa'
    end

    factory :english do
      name 'English'
      iso_code 'en'
    end

    factory :chinese do
      name 'Chinese'
      iso_code 'zh'
    end
  end

  factory :datum_source do
    factory :ds_lit_rate do
      admin_name 'ds_lit_rate'
      public_name 'Literacy rate, adult total (% of people ages 15 and...'
      description nil
      datum_type 'Indicator'
      #category access
      #group human
      default_weight 1
      retriever_class 'WorldBankParser'
      is_api false
      in_category_page true
      in_sidebar true
      affects_score true
      source_name 'World Bank'
      source_link 'http://data.worldbank.org/indicator/SE.ADT.LITR.ZS'
      display_suffix '%'
    end

    factory :ds_pct_inet do
      admin_name 'ds_pct_inet'
      public_name 'Percentage of individuals using the Internet'
      description nil
      datum_type 'Indicator'
      #category access
      #group adoption
      default_weight 1
      retriever_class 'ITUParser'
      is_api false
      in_category_page true
      in_sidebar true
      affects_score true
      source_name 'ITU database'
      source_link 'I99H'
      display_suffix '%'
    end

    factory :ds_mob_scr do
      admin_name 'ds_mob_scr'
      public_name 'Active mobile broadband subscription rate'
      description nil
      datum_type 'Indicator'
      #category access
      #group adoption
      default_weight 1
      retriever_class 'ITUParser'
      is_api false
      in_category_page true
      in_sidebar false
      affects_score true
      source_name 'ITU'
      source_link 'ITU database'
    end

    factory :ds_fixed_monthly do
      # ds_fixed_monthly has a negative direction because a higher
      # value for monthly charge will decrease a country's score
      admin_name 'ds_fixed_monthly'
      public_name 'Fixed (wired) broadband monthly subscription charge (in USD)'
      description nil
      datum_type 'Indicator'
      #category access
      #group price
      default_weight -1 
      retriever_class 'ITUParser'
      is_api false
      in_category_page true
      in_sidebar false
      affects_score false
      source_name 'ITU database'
      source_link 'I993'
      display_prefix '$'
      precision 2
    end

    factory :ds_fixed_monthly_gdp do
      # even though the above actual USD value is shown on category page,
      # this one (value / GDP) affects score
      admin_name 'ds_fixed_monthly_gdp'
      public_name 'Fixed (wired) broadband monthly subscription charge (in USD/GDP)'
      description nil
      datum_type 'Indicator'
      #category access
      #group price
      default_weight -1 
      retriever_class 'ITUParser'
      is_api false
      in_category_page false
      in_sidebar false
      affects_score true
      source_name 'ITU database'
      source_link 'I993'
      display_prefix '$'
    end

    factory :ds_download do
      admin_name 'ds_download'
      public_name 'Average download speed (kbps)'
      description nil
      datum_type 'Indicator'
      #category access
      #group speed
      default_weight 1
      retriever_class 'NetIndexParser'
      is_api false
      in_category_page true
      in_sidebar false
      affects_score true
      source_name 'NetIndex'
      source_link 'http://netindex.com/source-data/'
      display_suffix 'kbps'
    end

    factory :ds_ippoc do
      admin_name 'ds_ippoc'
      public_name 'IP addresses per point of control'
      description nil
      datum_type 'Indicator'
      #category control
      #group filtering
      default_weight 1
      retriever_class 'ASNParser'
      is_api false
      in_category_page true
      in_sidebar false
      affects_score false
      source_name 'Mapping Local Internet Control'
      source_link 'http://cyber.law.harvard.edu/netmaps/raw_data.php'
    end

    factory :ds_consistency do
      admin_name 'ds_consistency'
      public_name 'Filtering (consistency)'
      description nil
      datum_type 'Indicator'
      #category control
      #group control
      default_weight 1
      retriever_class 'ONIParser'
      is_api false
      in_category_page true
      in_sidebar false
      affects_score false
      source_name 'Open Net Initiative'
      source_link 'http://opennet.net/research/data'
    end

    factory :ds_population do
      # indicators like Population don't have a category
      admin_name 'ds_population'
      public_name 'Population, total'
      description nil
      datum_type 'Indicator'
      #category nil
      default_weight 0
      retriever_class 'WorldBankParser'
      is_api true
      in_category_page true
      in_sidebar true
      affects_score false
      source_name 'World Bank'
      source_link 'http://data.worldbank.org/indicator/SP.POP.TOTL'
    end

    factory :ds_gdp do
      # indicators like gdp don't have a category
      admin_name 'ds_gdp'
      public_name 'GDP per capita'
      description nil
      datum_type 'Indicator'
      #category nil
      default_weight 0.0
      retriever_class 'WorldBankParser'
      is_api true
      in_category_page true
      in_sidebar true
      affects_score false
      source_name 'World Bank'
      source_link 'http://data.worldbank.org/indicator/NY.GDP.PCAP.CD'
      display_prefix '$'
    end

    factory :ds_morningside do
      admin_name 'ds_morningside'
      public_name 'Morningside Analytics'
      description nil
      datum_type 'JsonObject'
      #category activity
      default_weight 0
      retriever_class 'MorningsideFetcher'
      is_api true
      in_category_page false
      in_sidebar false
      requires_page true
      affects_score false
      source_name 'Morningside Analytics'
      source_link ''
    end

    factory :ds_herdict_quickstats do
      admin_name 'ds_herdict_quickstats'
      public_name 'Herdict Quick Stats'
      description nil
      datum_type 'HtmlBlock'
      #category control
      default_weight 0
      retriever_class 'HerdictQuickstatsFetcher'
      is_api true
      in_category_page true
      in_sidebar false
      requires_page false
      affects_score false
      source_name 'Herdict'
      source_link 'http://www.herdict.org'
    end

    factory :ds_herdict do
      admin_name 'ds_herdict'
      public_name 'Herdict'
      description nil
      datum_type 'HtmlBlock'
      #category control
      default_weight 0
      retriever_class 'HerdictFetcher'
      is_api true
      in_category_page true
      in_sidebar false
      requires_page false
      affects_score false
      source_name 'Herdict'
      source_link 'http://www.herdict.org'
    end
  end

  factory :indicator do
    # iran
    # access
    #   adoption
    #     ds_pct_inet
    #   speed
    #     ds_download
    #   price
    #     ds_fixed_monthly
    #     ds_fixed_monthly_gdp
    #   human
    #     ds_lit_rate
    # control
    #   ds_ippoc
    #   ds_consistency
    #   ds_herdict_quickstats
    #   ds_herdict
    # (no category)
    #   ds_population
    #   ds_gdp
    #
    # china
    # access
    #   adoption
    #     ds_pct_inet
    #   speed
    #     ds_download
    #   price
    #     ds_fixed_monthly
    #     ds_fixed_monthly_gdp
    #   human
    #     ds_lit_rate
    # control
    #   ds_ippoc
    #   ds_consistency
    # (no category)
    #   ds_population
    #   
    # usa
    # access datum_source
    #   adoption
    #     ds_pct_inet
    #     ds_mob_scr

    # iran
    factory :d_pct_inet_iran do
      #source ds_pct_inet
      start_date '2011-01-01'
      #country iran
      #language nil
      original_value 21.0
      type 'Indicator'
    end

    factory :d_fixed_monthly_iran do
      #source ds_fixed_monthly
      start_date '2011-01-01'
      #country iran
      #language nil
      original_value 16.5671546612
      type 'Indicator'
    end

    factory :d_fixed_monthly_gdp_iran do
      #source ds_fixed_monthly_gdp
      start_date '2011-01-01'
      #country iran
      #language nil
      original_value 0.00366048227586886
      type 'Indicator'
    end

    factory :d_download_iran do
      #source ds_download
      start_date '2013-01-21'
      #country iran
      #language nil
      original_value 1800.1006666666667
      type 'Indicator'
    end

    factory :d_lit_rate_iran do
      #source ds_lit_rate
      start_date '2011-01-01'
      #country iran
      #language nil
      original_value 36.51840027
      type 'Indicator'
    end

    factory :d_ippoc_iran do
      #source ds_ippoc
      start_date '2011-01-01'
      #country iran
      #language nil
      original_value 4073728.0
      type 'Indicator'
    end

    factory :d_consistency_iran do
      #source ds_consistency
      start_date '2011-01-01'
      #country iran
      #language nil
      original_value 10.0
      type 'Indicator'
    end

    factory :d_population_iran do
      #source ds_population
      start_date '2011-01-01'
      #country iran
      #language nil
      original_value 74798599
      type 'Indicator'
    end

    factory :d_gdp_iran do
      #source ds_gdp
      start_date '2009-01-01'
      #country iran
      #language nil
      original_value 4525.9486080335
      type 'Indicator'
    end

    # china
    factory :d_pct_inet_china do
      #source ds_pct_inet
      start_date '2011-01-01'
      #country china
      #language nil
      original_value 30.8539009094
      type 'Indicator'
    end

    factory :d_fixed_monthly_china do
      #source ds_fixed_monthly
      start_date '2011-01-01'
      #country china
      #language nil
      original_value 18.5729763195
      type 'Indicator'
    end

    factory :d_fixed_monthly_gdp_china do
      #source ds_fixed_monthly_gdp
      start_date '2011-01-01'
      #country china
      #language nil
      original_value 0.00341114943653143
      type 'Indicator'
    end

    factory :d_download_china do
      #source ds_download
      start_date '2013-01-21'
      #country china
      #language nil
      original_value 8802.511333333334
      type 'Indicator'
    end

    factory :d_lit_rate_china do
      #source ds_lit_rate
      start_date '2011-01-01'
      #country china
      #language nil
      original_value 94.2722
      type 'Indicator'
    end

    factory :d_ippoc_china do
      #source ds_ippoc
      start_date '2011-01-01'
      #country china
      #language nil
      original_value 80186035.0
      type 'Indicator'
    end

    factory :d_consistency_china do
      #source ds_consistency
      start_date '2011-01-01'
      #country china
      #language nil
      original_value 10.0
      type 'Indicator'
    end

    factory :d_population_china do
      #source ds_population
      start_date '2011-01-01'
      #country china
      #language nil
      original_value 1344130000
      type 'Indicator'
    end

    # usa
    factory :d_pct_inet_usa do
      #source ds_pct_inet
      start_date '2011-01-01'
      #country usa
      #language nil
      original_value 77.863
      type 'Indicator'
    end

    factory :d_mob_scr_usa do
      #source ds_mob_scr
      start_date '2011-01-01'
      #country usa
      #language nil
      original_value 65.4773467864
      type 'Indicator'
    end
  end

  factory :html_block do
    factory :d_herdict_quickstats_iran do
      #source ds_herdict_quickstats
      start_date '2013-01-01'
      #country iran
      #language nil
      original_value nil
      value_id 'IRN'
      value '<div class="explore-module-content quickstats"> <h2>Quick Stats</h2> <ul class="quickstats-list"> <li> <em class="highlight">Iran</em> has <em class="inaccessible">5,207 inaccessible reports</em> on 1,082 sites </li> <li> <em class="highlight">Iran</em> has <em class="accessible">8,291 accessible reports</em> on 1,408 sites </li> <li class="new-section"> Iran is ranked 6 in number of reports </li> </ul> </div>'
      type 'HtmlBlock'
    end

    factory :d_herdict_iran do
      #source ds_herdict
      start_date '2013-01-01'
      #country iran
      #language nil
      original_value nil
      value_id 'IRN'
      #value [herd_irn.html]
      type 'HtmlBlock'
    end
  end

  factory :json_object do
    factory :d_morningside do
      #source ds_morningside
      start_date '2013-10-24'
      #country nil
      #language persian
      original_value nil
      value_id 1
      #value [morningside.json]
      type 'JsonObject'
    end
  end

  # refinery
  factory :tadmin, class: Refinery::User do |u|
    u.username 'tadmin'
    u.email 'tadmin@cyber.law.harvard.edu'
    u.password 'tp4ssw0rd'
  end

  factory :carousel_page, class: Refinery::Page do |p|
    p.title 'carousel'
    p.slug 'carousel'
    p.show_in_menu true
    p.link_url ''
    p.deletable true
    p.draft false
  end

  factory :carousel_about_page, class: Refinery::Page do |p|
    #p.parent carousel_page
    p.title 'c_about'
    p.show_in_menu true
    p.link_url '/about'
    p.deletable true
    p.draft false
  end

  factory :carousel_about_page_body, class: Refinery::PagePart do |pp|
    #pp.page carousel_about_page
    title 'Body'
    body 'Lorem ipsum'
    position 0
  end

  factory :carousel_map_page, class: Refinery::Page do |p|
    #p.parent carousel_page
    p.title 'c_map'
    p.show_in_menu true
    p.link_url '/map'
    p.deletable true
    p.draft false
  end

  factory :carousel_map_page_body, class: Refinery::PagePart do |pp|
    #pp.page carousel_map_page
    title 'Body'
    body '<h1>Explore map</h1>'
    position 0
  end

  factory :home_page_access, class: Refinery::PagePart do |pp|
    #pp.page home_page
    title 'Access'
    body 'Who has Internet access and at what price?'
    position 2
  end

  factory :trending_page, class: Refinery::Page do |p|
    p.title 'trending'
    p.slug 'trending'
    p.show_in_menu true
    p.link_url ''
    p.deletable true
    p.draft false
  end

  factory :trending_page_body, class: Refinery::PagePart do |pp|
    #pp.page trending_page
    title 'Body'
    body '<ul><li>irn</li></ul>'
    position 0
  end

  factory :sources_page, class: Refinery::Page do |p|
    p.title 'Sources'
    p.slug 'sources'
    p.show_in_menu true
    p.link_url ''
    p.deletable true
    p.draft false
  end

  factory :sources_page_body, class: Refinery::PagePart do |pp|
    #pp.page sources_page
    title 'Body'
    body 'Data! We have some! We analyze it!'
    position 0
  end

  factory :sources_page_side_body, class: Refinery::PagePart do |pp|
    #pp.page sources_page
    title 'Side Body'
    body 'Analyze!'
    position 1
  end

  factory :iran_page, class: Refinery::Page do |p|
    p.title 'IRN'
    p.slug 'irn'
    p.show_in_menu false
    p.link_url ''
    p.deletable true
    p.draft false
  end

  factory :iran_page_body, class: Refinery::PagePart do |pp|
    #pp.page iran_page
    title 'Body'
    body 'Iran, also formerly known as Persia, and officially the Islamic Republic of Iran since 1980, is a country in Western Asia.'
    position 0
  end

  factory :iran_page_access, class: Refinery::PagePart do |pp|
    #pp.page iran_page
    title 'Access'
    body 'Iran has low internet access.'
    position 2
  end

  factory :iran_page_control, class: Refinery::PagePart do |pp|
    #pp.page iran_page
    title 'Control'
    body 'Iran does not control the Internet.'
    position 3
  end

  factory :iran_page_activity, class: Refinery::PagePart do |pp|
    #pp.page iran_page
    title 'Activity'
    body 'Iran is mildly active on Twitter.'
    position 4
  end

  factory :ds_morningside_1_page, class: Refinery::Page do |p|
    p.title 'ds_morningside_1'
    p.show_in_menu true
    p.link_url ''
    p.deletable true
    p.draft false
  end

  factory :ds_morningside_1_page_body, class: Refinery::PagePart do |pp|
    #pp.page ds_morningside_1_page
    title 'Body'
    body 'Researchers at Berkman are currently working to analyze this data.'
    position 0
  end

  factory :ds_morningside_1_page_side_body, class: Refinery::PagePart do |pp|
    #pp.page ds_morningside_1_page
    title 'Side Body'
    body 'For an earlier report on the Arabic blogosphere using similar research methods, see "Mapping the Arabic Blogosphere: Politics, Culture and Dissent" (2009).'
    position 1
  end

  factory :blog_post, class: Refinery::Blog::Post do |p|
    title '#IMWeekly: March 23, 2014'
    body '<p>This is a blog post.</p>'
    draft false
    published_at '2014-03-23'
    slug 'imweekly-march-23-2014'
  end
end


