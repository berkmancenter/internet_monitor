namespace :db do
  namespace :test do
    task :prepare => :environment do

# categories
categories = ['Access', 'Activity', 'Control'].map{|n| Category.find_or_create_by_name(n)}
 
# test country

    end
  end
end

