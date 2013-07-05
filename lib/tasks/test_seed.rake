require 'factory_girl_rails'

namespace :db do
  namespace :test do
    task :prepare => :environment do
      # categories
      categories = ['Access', 'Activity', 'Control'].map{|n| Category.find_or_create_by_name(n)}
       
      # language
      persian = FactoryGirl.create( :persian );
      persian.save!

      # countries
      iran = FactoryGirl.create( :iran );
      iran.categories = categories;
      iran.languages << persian;
      iran.save!

      # access datum sources
      ds_pct_inet = FactoryGirl.create( :ds_pct_inet );
      ds_pct_inet.category = categories[ 0 ];
      ds_pct_inet.save!

      # access datum
      d_pct_inet_iran = FactoryGirl.create( :d_pct_inet_iran );
      d_pct_inet_iran.source = ds_pct_inet;
      d_pct_inet_iran.country = iran;
      d_pct_inet_iran.save!


      # control datum sources
      ds_consistency = FactoryGirl.create( :ds_consistency );
      ds_consistency.category = categories[ 2 ];
      ds_consistency.save!

      # control datum
      d_consistency = FactoryGirl.create( :d_consistency );
      d_consistency.source = ds_consistency;
      d_consistency.country = iran;
      d_consistency.save!

      # refinery
      Refinery::Pages::Engine.load_seed
      Refinery::Blog::Engine.load_seed
    end
  end
end

