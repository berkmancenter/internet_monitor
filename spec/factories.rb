FactoryGirl.define do
  factory :country do
    name 'Iran'
    iso_code 'IR'
    iso3_code 'IRN'
    score 3.45
    description ''
  end

  factory :language do
    name 'Persian'
    iso_code 'fa'
  end

  factory :datum_source do
    factory :ds_access do
      admin_name 'ds_access'
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
end


