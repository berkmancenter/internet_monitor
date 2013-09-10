FactoryGirl.define do
  factory :country do
    # iran is a valid test country with a language and datum for: access, & control
    factory :iran do
      name 'Iran'
      iso_code 'IR'
      iso3_code 'IRN'
      score 4.82
      description ''
      indicator_count 3
    end

    # usa only has one indicator: access
    # therefore it appears as 'without scores'
    factory :usa do
      name 'United States'
      iso_code 'US'
      iso3_code 'USA'
      score 3.528
      description nil
      indicator_count 1
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
      # category access
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
      # category access
      default_weight 1
      min 0.0
      max 95.02
      retriever_class 'ITUParser'
      is_api false
      in_sidebar true
      affects_score true
      link nil
    end

    factory :ds_consistency do
      admin_name 'ds_consistency'
      public_name 'consistency'
      description nil
      datum_type 'Indicator'
      # category control
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
      # category nil
      default_weight 0
      min 9847
      max 1344130000
      retriever_class 'WorldBankParser'
      is_api true
      in_sidebar true
      affects_score false
      link nil
    end
  end

  factory :datum do
    # iran
    factory :d_pct_inet_iran do
      #source ds_pct_inet
      start_date '2011-01-01'
      #country_id iran
      language_id nil
      original_value 21.0
      value 0.22100610397810988
      type 'Indicator'
    end

    factory :d_lit_rate do
      #source ds_lit_rate
      start_date '2011-01-01'
      #country_id iran
      language_id nil
      original_value 36.51840027
      value 0.224347369
      type 'Indicator'
    end

    factory :d_consistency do
      #source ds_consistency
      start_date '2011-01-01'
      #country_id iran
      language_id nil
      original_value 10.0
      value 1
      type 'Indicator'
    end

    factory :d_population do
      #source ds_population
      start_date '2011-01-01'
      #country_id iran
      language_id nil
      original_value 74798599
      value 0.05564141853916538
      type 'Indicator'
    end

    # usa
    factory :d_pct_inet_usa do
      #source ds_pct_inet
      start_date '2011-01-01'
      #country_id usa
      language_id nil
      original_value 77.863
      value 0.8194
      type 'Indicator'
    end
  end


  # refinery
  factory :tadmin, class: Refinery::User do |u|
    u.username 'tadmin'
    u.email 'tadmin@cyber.law.harvard.edu'
    u.password 'tp4ssw0rd'
  end
end


