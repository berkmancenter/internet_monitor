FactoryGirl.define do
  factory :country do
    # iran is a valid test country with a language and datum for: access
    factory :iran do
      name 'Iran'
      iso_code 'IR'
      iso3_code 'IRN'
      score 3.45
      description ''
    end
  end

  factory :language do
    factory :persian do
      name 'Persian'
      iso_code 'fa'
    end
  end

  factory :datum_source do
    factory :ds_pct_inet do
      admin_name 'Percentage of individuals using the Internet'
      public_name 'Percentage of individuals using the Internet'
      description nil
      datum_type 'Indicator'
      default_weight 1
      min 0.0
      max 95.02
      retriever_class 'ITUParser'
      is_api false
      for_infobox nil
      link nil
    end
  end

  factory :datum do
    factory :d_pct_inet_iran do
      #source ds_pct_inet
      start_date '2011-01-01'
      #country_id iran
      language_id nil
      original_value 21.0
      value 0.22100610397810988
      type 'Indicator'
    end
    
  end
end


