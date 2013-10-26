require 'factory_girl_rails'

namespace :db do
  namespace :test do
    task :prepare => :environment do
      # categories
      categories = ['Access', 'Activity', 'Control'].map{|n| Category.find_or_create_by_name(n)}
       
      # language
      persian = FactoryGirl.create( :persian );
      persian.save!

      english = FactoryGirl.create( :english );
      english.save!

      # countries
      iran = FactoryGirl.create( :iran );
      iran.categories = categories;
      iran.languages << persian;
      iran.save!

      usa = FactoryGirl.create( :usa );
      usa.categories = categories;
      usa.languages << english;
      usa.save!

      country_nil_score = FactoryGirl.create( :country_nil_score );
      country_nil_score.categories = categories;
      country_nil_score.languages << english;
      country_nil_score.save!

      # access datum sources
      ds_pct_inet = FactoryGirl.create( :ds_pct_inet );
      ds_pct_inet.category = categories[ 0 ];
      ds_pct_inet.save!

      ds_lit_rate = FactoryGirl.create( :ds_lit_rate );
      ds_lit_rate.category = categories[ 0 ];
      ds_lit_rate.save!

      # access datum
      d_pct_inet_iran = FactoryGirl.create( :d_pct_inet_iran );
      d_pct_inet_iran.source = ds_pct_inet;
      d_pct_inet_iran.country = iran;
      d_pct_inet_iran.save!

      d_lit_rate = FactoryGirl.create( :d_lit_rate );
      d_lit_rate.source = ds_lit_rate;
      d_lit_rate.country = iran;
      d_lit_rate.save!

      d_pct_inet_usa = FactoryGirl.create( :d_pct_inet_usa );
      d_pct_inet_usa.source = ds_pct_inet;
      d_pct_inet_usa.country = usa;
      d_pct_inet_usa.save!

      # control datum sources
      ds_consistency = FactoryGirl.create( :ds_consistency );
      ds_consistency.category = categories[ 2 ];
      ds_consistency.save!

      # control datum
      d_consistency = FactoryGirl.create( :d_consistency );
      d_consistency.source = ds_consistency;
      d_consistency.country = iran;
      d_consistency.save!

      # access datum sources
      ds_morningside = FactoryGirl.create :ds_morningside
      ds_morningside.category = categories[ 1 ]
      ds_morningside.save

      # access datum
      d_morningside = FactoryGirl.create :d_morningside
      d_morningside.source = ds_morningside
      d_morningside.language = persian
      d_morningside.value = IO.read 'db/test_data/morningside.json'
      d_morningside.save

      # other datum source
      ds_population = FactoryGirl.create( :ds_population );
      ds_population.save!

      # other datum
      d_population = FactoryGirl.create( :d_population );
      d_population.source = ds_population;
      d_population.country = iran;
      d_population.save!

      # refinery
      Refinery::Pages::Engine.load_seed
      Refinery::Blog::Engine.load_seed

      u = FactoryGirl.create( :tadmin )
      u.create_first

      # IRN page
      iran_page = FactoryGirl.create :iran_page
      iran_page_body = FactoryGirl.create :iran_page_body
      iran_page_body.page = iran_page
      iran_page_body.save
    end
  end
end

