# Export/import refinery pages

namespace :refinery_pages do
  desc 'Export refinerycms pages as json'
  task :export, [ :path ] => [:environment] do |task, args|
    refinery_pages_export args[ :path ]
  end

  def refinery_pages_export( path )
    if path.nil?
      puts "refinery_pages:export['path/to/filename.json']"
      return
    end

    File.open( path , 'w') { |f|
      f.write( Refinery::Page.all.to_json( include: :parts ) )
    }
  end
end
