namespace :imon do
    desc 'Ingest data from individual source'
    task :ingest, [:row_number] => [:environment] do |task, args|
        Retriever.retrieve!(args[:row_number])
    end
end
