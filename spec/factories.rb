FactoryGirl.define do
  factory :country do
    # iran is a valid test country with a language and datum for: access, & control
    factory :iran do
      name 'Iran'
      iso_code 'IR'
      iso3_code 'IRN'
      description ''
      indicator_count 4
    end

    # usa only has one indicator: access
    # therefore it appears as 'without scores'
    factory :usa do
      name 'United States'
      iso_code 'US'
      iso3_code 'USA'
      description nil
      indicator_count 1
    end

    factory :country_nil_score do
      name 'nil_score'
      iso_code 'NS'
      iso3_code 'CNS'
      description 'nil_score'
      indicator_count 0
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
  end

  factory :datum_source do
    factory :ds_lit_rate do
      admin_name 'ds_lit_rate'
      public_name 'Literacy rate, adult total (% of people ages 15 and...'
      description nil
      datum_type 'Indicator'
      #category access
      default_weight 1
      min 18.15768113
      max 99.99826243
      retriever_class 'WorldBankParser'
      is_api false
      in_sidebar true
      affects_score true
      link nil
    end

    factory :ds_pct_inet do
      admin_name 'ds_pct_inet'
      public_name 'Percentage of individuals using the Internet'
      description nil
      datum_type 'Indicator'
      #category access
      default_weight 1
      min 0.0
      max 95.02
      retriever_class 'ITUParser'
      is_api false
      in_sidebar true
      affects_score true
      link nil
    end

    factory :ds_fixed_monthly do
      # ds_fixed_monthly has a negative direction because a higher
      # value for monthly charge will decrease a country's score
      admin_name 'ds_fixed_monthly'
      public_name 'Fixed (wired) broadband monthly subscription charge (in USD)'
      description nil
      datum_type 'Indicator'
      #category access
      default_weight -1 
      min 0.000129379915752054
      max 1.81461147685752
      retriever_class 'ITUParser'
      is_api false
      in_sidebar false
      affects_score true
      link nil
    end

    factory :ds_consistency do
      admin_name 'ds_consistency'
      public_name 'consistency'
      description nil
      datum_type 'Indicator'
      #category control
      default_weight 1
      min 1.0
      max 10
      retriever_class 'ONIParser'
      is_api false
      in_sidebar false
      affects_score true
      link nil
    end

    factory :ds_population do
      # indicators like Population don't have a category
      admin_name 'ds_population'
      public_name 'Population, total'
      description nil
      datum_type 'Indicator'
      #category nil
      default_weight 0
      min 9847
      max 1344130000
      retriever_class 'WorldBankParser'
      is_api true
      in_sidebar true
      affects_score false
      link nil
    end

    factory :ds_morningside do
      admin_name 'ds_morningside'
      public_name 'Morningside Analytics'
      description nil
      datum_type 'JsonObject'
      #category activity
      default_weight 0
      min nil
      max nil
      retriever_class 'MorningsideFetcher'
      is_api true
      in_sidebar false
      affects_score false
    end
  end

  factory :indicator do
    # iran
    factory :d_pct_inet_iran do
      #source ds_pct_inet
      start_date '2011-01-01'
      #country iran
      #language nil
      original_value 21.0
      value 0.22100610397810988
      type 'Indicator'
    end

    factory :d_fixed_monthly_iran do
      #source ds_fixed_monthly
      start_date '2011-01-01'
      #country iran
      #language nil
      original_value 0.0036604822758688677
      value 0.9980539337554951
      type 'Indicator'
    end

    factory :d_lit_rate do
      #source ds_lit_rate
      start_date '2011-01-01'
      #country iran
      #language nil
      original_value 36.51840027
      value 0.224347369
      type 'Indicator'
    end

    factory :d_consistency do
      #source ds_consistency
      start_date '2011-01-01'
      #country iran
      #language nil
      original_value 10.0
      value 1.0
      type 'Indicator'
    end

    factory :d_population do
      #source ds_population
      start_date '2011-01-01'
      #country iran
      #language nil
      original_value 74798599
      value 0.05564141853916538
      type 'Indicator'
    end

    # usa
    factory :d_pct_inet_usa do
      #source ds_pct_inet
      start_date '2011-01-01'
      #country usa
      #language nil
      original_value 77.863
      value 0.8194
      type 'Indicator'
    end
  end

  factory :json_object do
    factory :d_morningside do
      #source ds_morningside
      start_date '2013-10-24'
      #country nil
      #language persian
      original_value nil
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
end


