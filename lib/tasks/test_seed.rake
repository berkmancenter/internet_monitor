require 'factory_girl_rails'

namespace :db do
  namespace :test do
    task :prepare => :environment do
      # categories
      categories = ['Access', 'Activity', 'Control'].map{|n| Category.find_or_create_by_name(n)}
       
      # test language
      persian = FactoryGirl.create( :language );
      persian.save!

      # test country
      iran = FactoryGirl.create( :country );
      iran.categories = categories;
      iran.languages << persian;
      iran.save!

      # test access datum source
      ds_access = FactoryGirl.create( :ds_access );
      ds_access.category = categories[ 0 ];
      ds_access.save!

      # refinery
      Refinery::Pages::Engine.load_seed
      Refinery::Blog::Engine.load_seed
    end
  end
end

