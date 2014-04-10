# Export/import refinery pages

namespace :refinery_pages do
  desc 'Reset refinerycms pages, leaves only Home, About, & Blog'
  task :reset => [:environment] do |task|
    Refinery::Page.delete_all 'not id in (1,2,3,4)'
  end

  desc 'Export refinerycms pages as JSON'
  task :export, [ :path ] => [:environment] do |task, args|
    refinery_pages_export args[ :path ]
  end

  def refinery_pages_export( path )
    usage = "usage: refinery_pages:export['path/to/filename.json']"

    if path.nil?
      puts usage
      return
    end

    File.open( path , 'w' ) { |f|
      f.write( Refinery::Page.all.to_json( include: :parts ) )
    }
  end

  desc 'Import exported refinerycms pages from JSON'
  task :import, [ :path ] => [:environment] do |task, args|
    refinery_pages_import args[ :path ]
  end

  def refinery_pages_import( path )
    usage = "usage: refinery_pages:import['path/to/filename.json']"

    if path.nil?
      puts usage
      return
    end

    if !File.exists? path
      puts "cannot find #{path}"
      return
    end

    pages_json = IO.read path

    if pages_json.nil?
      puts "error reading #{path}"
      return
    end

    pages = JSON.parse pages_json

    if pages.nil?
      puts "error parsing JSON from #{path}"
      return
    end

    puts "importing #{pages.count} page(s)"

    pages.each { |page|
      puts "importing #{page[ 'title' ]} (slug: #{page[ 'slug' ]}) & #{page[ 'parts' ].count} part(s)"

      page_rec = Refinery::Page.find_or_create_by_title page[ 'title' ]

      if page_rec.new_record?
        page_rec.save
        puts "  #{page_rec.slug} is a new page (id: #{page_rec.id}, prev_id: #{page[ 'id' ]})"
      else
        puts "  #{page_rec.slug} already exists (id: #{page_rec.id})"
      end

      page[ 'parts' ].each_with_index { |part, i|
        puts "  importing part #{i} #{part[ 'title' ]}"

        part_rec = page_rec.parts.find_or_create_by_title part[ 'title' ]
        part_rec.body = part[ 'body' ]
        part_rec.position = part[ 'position' ]
        part_rec.save
      }
    }
  end

end
