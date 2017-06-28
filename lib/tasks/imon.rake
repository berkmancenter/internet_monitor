require 'csv'

namespace :imon do
  desc 'Ingest data from individual source, do not recalculate all'
  task :ingest, [:row_number] => [:environment] do |task, args|
    Retriever.retrieve!(args[:row_number])

#    puts 'Country.count_indicators'
#    Country.count_indicators!
#
#    puts 'DatumSource.recalc_min_max_and_values!'
#    DatumSource.recalc_min_max_and_values!
#
#    puts 'Country.calculate_scores_and_rank!'
#    Country.calculate_scores_and_rank!
  end

  desc 'Export most recent data for all countries'
  task :export_most_recent, [:filename] => [:environment] do |task, args|
    export_most_recent args[:filename]
  end

  desc 'Import country bboxes'
  task :import_country_bboxes, [:filename] => [:environment] do |task, args|
    import_country_bboxes args[:filename]
  end

  desc 'Replace most recent static (HTML/JSON) source for country'
  task :replace_static_source, [:row_number, :iso3_code] => [:environment] do |task, args|
    replace_static_source args[ :row_number ], args[ :iso3_code ]
  end

  desc 'Migrate country profile pages in RefineryCMS to be the correct names'
  task :migrate_country_profiles_081 => [:environment] do |task|
    Rails.logger.info '[mcp] start migrate_country_profiles_081'

    mcp_081

    Rails.logger.info '[mcp] end migrate_country_profiles_081'
  end

  desc 'Extract widget embeds from a dasboard page to a country page in refinery'
  task :import_country_widgets, [:iso3_code] => [:environment] do |task, args|
    Rails.logger.info '[icw] start import_country_widgets'

    iso3_code = args[ :iso3_code ]
    if iso3_code.present?
      Rails.logger.info "[icw] only #{iso3_code}"
    end

    # On IM Dashboard, run this in Dev Tools to get third parameter
    # JSON.stringify( $( '.widget' ).map( function( ) { let widget = $(this); return { mid: widget.data( 'mid' ), cx: widget.data( 'sizex' ), cy: widget.data( 'sizey' ), row: widget.data( 'row' ), col: widget.data( 'col' ) } } ).toArray() )
    countries = [
      [ 'arm', 'dBiFBajZoKS3qzvpZ', %|[{"mid":"RhpeeJzGNDnkAdPSF","cx":2,"cy":1,"row":6,"col":1},{"mid":"iTZbGBRtMCKBKJisx","cx":2,"cy":1,"row":6,"col":3},{"mid":"7dDZAhFxo2aY8YoJS","cx":2,"cy":1,"row":5,"col":3},{"mid":"oGACpJygB2zp5mXXC","cx":2,"cy":1,"row":5,"col":1},{"mid":"SAKb7wXFcuZw4j22g","cx":4,"cy":1,"row":3,"col":1},{"mid":"YrXKHTuJLZ2mET6QK","cx":2,"cy":1,"row":4,"col":3},{"mid":"oYSnsYwQQgNXpKm7i","cx":2,"cy":1,"row":4,"col":1},{"mid":"X8DJZnAJsaiPZ4swq","cx":2,"cy":2,"row":7,"col":1},{"mid":"79xR3yEKWhhQr9N3i","cx":4,"cy":2,"row":1,"col":1}]| ],
      [ 'aze', 'bbvtxnwKxG3wXRPaG', %|[{"mid":"it7B3ftnwbMuRwaBf","cx":2,"cy":1,"row":7,"col":1},{"mid":"tL7nr6dEjaRC4uiRG","cx":2,"cy":1,"row":7,"col":3},{"mid":"vWbH8dM7sCYTvYLuH","cx":2,"cy":1,"row":6,"col":3},{"mid":"6iTzfz36vbZe4Mocd","cx":2,"cy":1,"row":6,"col":1},{"mid":"78krbpebfuyTTyuPJ","cx":4,"cy":1,"row":3,"col":1},{"mid":"Ch3nQSHx9KdEEBgBL","cx":4,"cy":1,"row":5,"col":1},{"mid":"fRqgJTLrSPRNdZrQY","cx":2,"cy":1,"row":4,"col":3},{"mid":"dthDzt7CfJHwscAYR","cx":2,"cy":1,"row":4,"col":1},{"mid":"gRbwkuES4d95MPEge","cx":2,"cy":2,"row":8,"col":1},{"mid":"wJkS6Pb3aK6Krub6y","cx":4,"cy":2,"row":1,"col":1}]| ],
      [ 'bhr', 'shFiukpQRs22X8mfN', %|[{"mid":"bGRPAqKvQhsyLPQuZ","cx":4,"cy":1,"row":3,"col":1},{"mid":"D3tZNCwqqqpoa9iHv","cx":2,"cy":2,"row":5,"col":1},{"mid":"YcgJ2kX2tLevPNBdM","cx":4,"cy":2,"row":1,"col":1},{"mid":"7TC3LSCuijcsTCNPg","cx":2,"cy":1,"row":4,"col":3},{"mid":"d7QtXWLGipLApj4Sz","cx":2,"cy":1,"row":4,"col":1}]| ],
      [ 'bgd', 'b8HXnwp36i7S3ZrYt', %|[{"mid":"NB8FovdRTqBYF95bS","cx":2,"cy":1,"row":6,"col":1},{"mid":"24FdZ4wgsTthm9kMC","cx":2,"cy":1,"row":6,"col":3},{"mid":"tdpT99vE7jZeoR3GP","cx":2,"cy":1,"row":5,"col":3},{"mid":"ojfxXNCHXRo55NDTp","cx":2,"cy":1,"row":5,"col":1},{"mid":"Z3oWWt8acksvi5RrQ","cx":4,"cy":1,"row":3,"col":1},{"mid":"CRQZrF78R3nkxh2eK","cx":4,"cy":1,"row":4,"col":1},{"mid":"HFKoWYTc4BLx2E8g8","cx":2,"cy":1,"row":7,"col":1},{"mid":"fGhdg3X8sypiAsguf","cx":4,"cy":2,"row":1,"col":1}]| ],
      [ 'blr', 'pgPJr3gXgyTtRwF84', %|[{"mid":"sh4TH593zSFJPXCh9","cx":2,"cy":2,"row":8,"col":1},{"mid":"rojDgp6gSiF4xEmpC","cx":4,"cy":2,"row":1,"col":1},{"mid":"SbjmxydpSKEGqsdxx","cx":2,"cy":1,"row":4,"col":3},{"mid":"nMd8GE4WNwN8xZR8d","cx":2,"cy":1,"row":4,"col":1},{"mid":"iyq4ExwMXCKpL9sim","cx":4,"cy":1,"row":5,"col":1},{"mid":"pgMzZafvXxCtgkoKe","cx":4,"cy":1,"row":3,"col":1},{"mid":"ji2q4TDr6QBsHiMG5","cx":2,"cy":1,"row":6,"col":1},{"mid":"rQh7RfE5iAejc5BYC","cx":2,"cy":1,"row":6,"col":3},{"mid":"WQnzqpigt3DGW42En","cx":2,"cy":1,"row":7,"col":3},{"mid":"rkCMD7KdbyERiA2XN","cx":2,"cy":1,"row":7,"col":1}]| ],
      [ 'bra', 'rGYY6PQyFZtpyPxbe', %|[{"mid":"vAHw5i5szxCb5hzq7","cx":2,"cy":1,"row":7,"col":1},{"mid":"AbCgH3ZPyaj7oDfeT","cx":2,"cy":1,"row":7,"col":3},{"mid":"qsALnefYg4qGZJELu","cx":2,"cy":1,"row":6,"col":3},{"mid":"wuLwmPnkBHMb2cryJ","cx":2,"cy":1,"row":6,"col":1},{"mid":"xJcCMtQihk7i8bwoy","cx":4,"cy":1,"row":3,"col":1},{"mid":"emfpnDmNqdwSECyTY","cx":2,"cy":1,"row":4,"col":1},{"mid":"kNwzR2Hb79BGCQNvP","cx":2,"cy":1,"row":4,"col":3},{"mid":"q2cFkjmGN4JuEiCfP","cx":4,"cy":1,"row":5,"col":1},{"mid":"aQ28zYqJxh3ti63ie","cx":4,"cy":2,"row":1,"col":1},{"mid":"GjhR3LFRjTXoJYhop","cx":2,"cy":2,"row":8,"col":1}]| ],
      [ 'bgr', 'APYoTyL48uySN8XRw', %|[{"mid":"5Zwvb9Kz6WaKq4bPf","cx":2,"cy":1,"row":4,"col":1},{"mid":"Gaka5vh2X73pz6k57","cx":2,"cy":1,"row":7,"col":1},{"mid":"y9f8MNkDcrqYbkaCb","cx":2,"cy":1,"row":7,"col":3},{"mid":"Ew7DL4YtuQwqrvm9v","cx":2,"cy":1,"row":6,"col":3},{"mid":"cR5WDGwBdoKsRhRS6","cx":2,"cy":1,"row":6,"col":1},{"mid":"md4wSyYZbBNSp9N6c","cx":4,"cy":1,"row":3,"col":1},{"mid":"cN5JGZSmuZ2EA7oNC","cx":2,"cy":1,"row":4,"col":3},{"mid":"Nyokw7tfKGxc4ThxC","cx":4,"cy":1,"row":5,"col":1},{"mid":"oRvCLmCG6JpTcknNL","cx":4,"cy":2,"row":1,"col":1},{"mid":"rtSFgPseAy3AT2yb7","cx":2,"cy":2,"row":8,"col":1}]| ],
      [ 'khm', 'atYrurCE9yCjXdcoE', %|[{"mid":"cwn2QYBcWQbmSJd7r","cx":4,"cy":1,"row":4,"col":1},{"mid":"u29mnkSm5JNCwhvv8","cx":2,"cy":1,"row":5,"col":1},{"mid":"8PuzG7dnx5gw8T3JX","cx":4,"cy":1,"row":3,"col":1},{"mid":"Bwsdqb44CmDRsQZGw","cx":4,"cy":2,"row":1,"col":1},{"mid":"s6XNy9uuYaE375Lpy","cx":2,"cy":1,"row":7,"col":1},{"mid":"tcxk2WN3i4rxSiPYB","cx":2,"cy":1,"row":6,"col":1},{"mid":"qn8CJGx6gciWtJs5A","cx":2,"cy":1,"row":6,"col":3},{"mid":"G4iMX7qbSbTcqECx5","cx":2,"cy":1,"row":5,"col":3}]| ],
      [ 'can', 'zYrJGzBF6iKru3R7S', %|[{"mid":"pxFKHtQi74wjBaeik","cx":2,"cy":1,"row":6,"col":1},{"mid":"372KhvqgmqFqDvB2n","cx":4,"cy":1,"row":3,"col":1},{"mid":"eyGt8LeedHPNBk8YB","cx":2,"cy":1,"row":7,"col":1},{"mid":"dqFhfEPcKrteSsruT","cx":2,"cy":1,"row":7,"col":3},{"mid":"Epui8P4E5AhErjvDW","cx":2,"cy":1,"row":6,"col":3},{"mid":"S49ftNmX7p34eZae5","cx":4,"cy":1,"row":5,"col":1},{"mid":"wReuAZPc8dQbwNRaB","cx":2,"cy":1,"row":4,"col":3},{"mid":"GEuzCKH8f4kcdoHJu","cx":4,"cy":2,"row":1,"col":1},{"mid":"iqHSWNtZRs8osqdEq","cx":2,"cy":1,"row":4,"col":1},{"mid":"dJJyyfvsKptuoySED","cx":2,"cy":2,"row":8,"col":1}]| ],
      [ 'chn', 'sfz3hzuXbsdLMiYKN', %|[{"mid":"ahm6i6qdQLszZiAiT","cx":2,"cy":1,"row":6,"col":1},{"mid":"HXu2Pbc7oRTL9yQGk","cx":4,"cy":1,"row":3,"col":1},{"mid":"ZFwvm43bHLKzytDn7","cx":2,"cy":1,"row":7,"col":1},{"mid":"NpGh94Jrt6heYYTyW","cx":2,"cy":1,"row":7,"col":3},{"mid":"MkNJRmxwwJzwQdWq2","cx":2,"cy":1,"row":6,"col":3},{"mid":"rhNPSLqFfGJzPxF5P","cx":4,"cy":1,"row":5,"col":1},{"mid":"j3DaSB5XLNX2vB3kw","cx":2,"cy":1,"row":4,"col":3},{"mid":"kH9aYdW2QDS8MoLGx","cx":4,"cy":2,"row":1,"col":1},{"mid":"GLcZusyBkfGiyiyAJ","cx":2,"cy":1,"row":4,"col":1},{"mid":"H6jvHb6NWi2ZzBw2Y","cx":2,"cy":2,"row":8,"col":1}]| ],
      [ 'cze', 'u62BGSMFLJcwJ4dst', %|[{"mid":"w4DG5AkFdTn2Pk633","cx":2,"cy":1,"row":6,"col":3},{"mid":"3J6wxjzFJ8BKvdsEs","cx":2,"cy":1,"row":6,"col":1},{"mid":"XxjKFuwkQzrs2EHXz","cx":4,"cy":1,"row":3,"col":1},{"mid":"hJzdPqzZMA6T3YWEv","cx":2,"cy":1,"row":7,"col":1},{"mid":"CpPmSRX8FNsKmagYS","cx":2,"cy":1,"row":7,"col":3},{"mid":"BJaSNk58XtwwvEscB","cx":4,"cy":1,"row":5,"col":1},{"mid":"x5Hku64iKDH9hcf8L","cx":2,"cy":1,"row":4,"col":3},{"mid":"kKy37Mk7fBN6YZ4N2","cx":4,"cy":2,"row":1,"col":1},{"mid":"gDELbSwddNyaZYcbX","cx":2,"cy":1,"row":4,"col":1},{"mid":"gTJqbtdYSwEzYWZuT","cx":2,"cy":2,"row":8,"col":1}]| ],
      [ 'egy', 'smbtoWic9xzFPtXkk', %|[{"mid":"yGxMRtdh3HHvfBHYZ","cx":2,"cy":1,"row":6,"col":3},{"mid":"JFPP69W7sbwob32pY","cx":2,"cy":1,"row":6,"col":1},{"mid":"GhLoKaYWRykCB9GZa","cx":4,"cy":1,"row":3,"col":1},{"mid":"gserETFSzPBpRiKY3","cx":2,"cy":1,"row":7,"col":3},{"mid":"xaiwW5ta3GZwpXCtn","cx":4,"cy":1,"row":5,"col":1},{"mid":"nmkA3rwQxXRyKZaZS","cx":2,"cy":1,"row":4,"col":3},{"mid":"sLc3hSi534v44CrF9","cx":4,"cy":2,"row":1,"col":1},{"mid":"nmxBBAjgAec4cxmuw","cx":2,"cy":1,"row":4,"col":1},{"mid":"8muP6Wd73QbS2sYxj","cx":2,"cy":2,"row":7,"col":1}]| ],
      [ 'fra', '3hXen297G6wGHpbJc', %|[{"mid":"or7q8XK4qseT5tjB4","cx":4,"cy":1,"row":3,"col":1},{"mid":"H2wdEaoGtAx42JRrj","cx":2,"cy":1,"row":7,"col":1},{"mid":"Y4EiXrJcZN82dutr9","cx":2,"cy":1,"row":7,"col":3},{"mid":"m2xa2NNTb4oCWonKv","cx":2,"cy":1,"row":6,"col":3},{"mid":"wCnBkJj7G9BBKNPZP","cx":2,"cy":1,"row":6,"col":1},{"mid":"uhBHpGjsd7j8nBHyK","cx":4,"cy":1,"row":5,"col":1},{"mid":"Gfn8aoNRYLTvNdEaA","cx":2,"cy":1,"row":4,"col":3},{"mid":"PtfmYT8m3MpvzJx8v","cx":4,"cy":2,"row":1,"col":1},{"mid":"me6bYyjtHeDZG4qL8","cx":2,"cy":1,"row":4,"col":1},{"mid":"bWmXmRYs58RXua4Aq","cx":2,"cy":2,"row":8,"col":1}]| ],
      [ 'hkg', 'xN4R7KLutDehDLFMS', %|[{"mid":"DAbHygSmCGAb3N2rt","cx":4,"cy":1,"row":3,"col":1},{"mid":"PTyMzDEJnD4durZxg","cx":2,"cy":1,"row":7,"col":1},{"mid":"s2QiA4mSG8k8yWQMj","cx":2,"cy":1,"row":7,"col":3},{"mid":"aWbTtzd6X4mbAYixk","cx":2,"cy":1,"row":6,"col":3},{"mid":"rkni7meSkiqWji6hj","cx":2,"cy":1,"row":6,"col":1},{"mid":"FdJgTKTSmzEYLiyhS","cx":4,"cy":1,"row":5,"col":1},{"mid":"q8PZYhkTJHuxHmAhq","cx":2,"cy":1,"row":4,"col":3},{"mid":"7kBwQnFLRnkKYNMsq","cx":4,"cy":2,"row":1,"col":1},{"mid":"4DTe4zJ8mRWvdWcRZ","cx":2,"cy":1,"row":4,"col":1},{"mid":"KGbRYGcJ3tZXrCcdW","cx":2,"cy":2,"row":8,"col":1}]| ],
      [ 'hun', 'QLea6W295EWDXDSNP', %|[{"mid":"rJcKJXi7oSoJ4rCGQ","cx":4,"cy":1,"row":3,"col":1},{"mid":"PB55ir5B7bcb9svWR","cx":4,"cy":1,"row":5,"col":1},{"mid":"JkgpMzPWEYbDgrizJ","cx":2,"cy":1,"row":4,"col":3},{"mid":"EZs9as6FXTihJmq2k","cx":4,"cy":2,"row":1,"col":1},{"mid":"DZnhBPcmgKQWYbNBf","cx":2,"cy":1,"row":4,"col":1},{"mid":"G9RydthwLayhsqich","cx":2,"cy":2,"row":6,"col":1}]| ],
      [ 'ind', 'yu82iqESDHtdGPjcR', %|[{"mid":"K2Y7oQmsJrgRDCWve","cx":2,"cy":1,"row":6,"col":3},{"mid":"ZDfgwNruCbtddnmbg","cx":2,"cy":1,"row":6,"col":1},{"mid":"dAMseNRdrYy3pnXNM","cx":4,"cy":1,"row":3,"col":1},{"mid":"Z2b5mJJEyYPDvmaL9","cx":2,"cy":1,"row":7,"col":1},{"mid":"wBcaxRmTNngs4SoDp","cx":2,"cy":1,"row":7,"col":3},{"mid":"WHnpHtdnGDgh539sv","cx":4,"cy":1,"row":5,"col":1},{"mid":"NuFSndMCHBnLT2udT","cx":2,"cy":1,"row":4,"col":3},{"mid":"Bf89uneFuKgnH494w","cx":4,"cy":2,"row":1,"col":1},{"mid":"p9sqaBYRu4g2yZiTi","cx":2,"cy":1,"row":4,"col":1},{"mid":"6egfryTAFknNmcrLZ","cx":2,"cy":2,"row":8,"col":1}]| ],
      [ 'idn', 'hkSTGdYZFSbYodFZt', %|[{"mid":"bTqwzYTHKhxsKBziz","cx":2,"cy":1,"row":6,"col":3},{"mid":"4tLhG3pz9SWiPwAPf","cx":2,"cy":1,"row":6,"col":1},{"mid":"sWwJMDiC52BrrW7b3","cx":4,"cy":1,"row":3,"col":1},{"mid":"3bcHrnrCwmaEdgKap","cx":2,"cy":1,"row":7,"col":1},{"mid":"jETRRFWc9ayHSh5j6","cx":2,"cy":1,"row":7,"col":3},{"mid":"pbmnG42cmtPmBkjaE","cx":4,"cy":1,"row":5,"col":1},{"mid":"MwqZiZxvNLqDkWqxm","cx":2,"cy":1,"row":4,"col":3},{"mid":"obRBLa4peXvLyQuSN","cx":4,"cy":2,"row":1,"col":1},{"mid":"2xJHgGSA7YteoRwRc","cx":2,"cy":1,"row":4,"col":1},{"mid":"jvFJGLemfCYDtiz6E","cx":2,"cy":2,"row":8,"col":1}]| ],
      [ 'irn', 'ASG6AFvY9JyMt4MFZ', %|[{"mid":"dpgTpCgDA6zBwerXs","cx":2,"cy":1,"row":6,"col":3},{"mid":"F2YTxaAu39T87JGts","cx":2,"cy":1,"row":6,"col":1},{"mid":"GqmXvwdEjxeRLkkrY","cx":4,"cy":1,"row":3,"col":1},{"mid":"uPKv5xPKgNy9PZGdw","cx":2,"cy":1,"row":7,"col":1},{"mid":"dp2AAoQCYKY25NWPJ","cx":2,"cy":1,"row":7,"col":3},{"mid":"FaNbXsAJukACcEk6G","cx":4,"cy":1,"row":5,"col":1},{"mid":"ZqfwDoNJk365577CL","cx":2,"cy":1,"row":4,"col":3},{"mid":"DMmTTHpaHE6qEenf4","cx":4,"cy":2,"row":1,"col":1},{"mid":"aTu3W4RLSQL45eNB8","cx":2,"cy":1,"row":4,"col":1},{"mid":"9AF6jYF99a5e2Jcgq","cx":2,"cy":2,"row":8,"col":1}]| ],
      [ 'irq', 'noFKDZxcgKh6m34Wj', %|[{"mid":"hNvxW5muJpEKibm83","cx":2,"cy":1,"row":4,"col":3},{"mid":"XyRN7Tf8pXvFFRZnJ","cx":2,"cy":1,"row":4,"col":1},{"mid":"aDcGo4qQzvnP2yPAQ","cx":4,"cy":1,"row":3,"col":1},{"mid":"urSN8n9HhKjPkLPuo","cx":2,"cy":1,"row":5,"col":1},{"mid":"bXxJNqGp924YjNmRh","cx":2,"cy":1,"row":5,"col":3},{"mid":"cpbuTfMFdTwPihMst","cx":4,"cy":2,"row":1,"col":1},{"mid":"rsXRMEMB3YFCrBEZM","cx":2,"cy":1,"row":6,"col":1}]| ],
      [ 'isr', 'oAMcGfHBzavgzXciz', %|[{"mid":"Kbe6qvTCFjDGDN83X","cx":2,"cy":1,"row":6,"col":3},{"mid":"2ML8BPEKh3kHejeom","cx":2,"cy":1,"row":6,"col":1},{"mid":"PNN3LAPGqLBSQbtWW","cx":4,"cy":1,"row":3,"col":1},{"mid":"tMsMepGZCsq5quxYd","cx":2,"cy":1,"row":7,"col":1},{"mid":"8bLNpWBrYo6AyD2cK","cx":2,"cy":1,"row":7,"col":3},{"mid":"jHWCcY8gJqeTX2LjG","cx":4,"cy":1,"row":5,"col":1},{"mid":"jJXS7epi5GPuQtPQC","cx":2,"cy":1,"row":4,"col":3},{"mid":"cohkia8MWRRbpvhjP","cx":4,"cy":2,"row":1,"col":1},{"mid":"N4z6KFEwRZLPNu58A","cx":2,"cy":1,"row":4,"col":1},{"mid":"Q3xXTWGCuxCqqd32q","cx":2,"cy":2,"row":8,"col":1}]| ],
      [ 'ita', 'io5BibfHbuaC5yQxe', %|[{"mid":"L44D9rzbspALWgonw","cx":2,"cy":1,"row":6,"col":3},{"mid":"PHjpLo7SKCEguGboN","cx":2,"cy":1,"row":6,"col":1},{"mid":"sdW3ZN7S47fHzbjSy","cx":4,"cy":1,"row":3,"col":1},{"mid":"wgL36LaZGwSSJNDZr","cx":2,"cy":1,"row":7,"col":1},{"mid":"ehGHnfsNYFb3M98HS","cx":2,"cy":1,"row":7,"col":3},{"mid":"mHskwsLf6XGwmnyEY","cx":4,"cy":1,"row":5,"col":1},{"mid":"WrYKBACLn5LotELWK","cx":2,"cy":1,"row":4,"col":3},{"mid":"CB6mFXHbJ25cwXkvQ","cx":4,"cy":2,"row":1,"col":1},{"mid":"BhiGHEeR3jZ2aweTr","cx":2,"cy":1,"row":4,"col":1},{"mid":"xjsdsAdKmLnzASAy7","cx":2,"cy":2,"row":8,"col":1}]| ],
      [ 'jor', 'tGYDtF8qKZLBPxkwP', %|[{"mid":"QbeffgQFpp6kKEXDm","cx":4,"cy":1,"row":3,"col":1},{"mid":"7Gvbawxs7vRmTvvJA","cx":4,"cy":1,"row":5,"col":1},{"mid":"vapL5GzqjrK9Pdnzr","cx":2,"cy":1,"row":4,"col":3},{"mid":"LPJguhm5hWPwQThu9","cx":4,"cy":2,"row":1,"col":1},{"mid":"ics7GrH9YzQqQpC9j","cx":2,"cy":1,"row":4,"col":1},{"mid":"givxWquH72bsnikKS","cx":2,"cy":2,"row":6,"col":1}]| ],
      [ 'kaz', 'beuaBkuGaw3mzrh4t', %|[{"mid":"K5nKF8gxv4K8xmQXz","cx":2,"cy":1,"row":6,"col":1},{"mid":"omwj4MZJ99YxJNCGx","cx":2,"cy":1,"row":6,"col":3},{"mid":"hQH6vad8twqBxrCbn","cx":2,"cy":1,"row":5,"col":3},{"mid":"zmnNkBYKCXutPdXcT","cx":2,"cy":1,"row":5,"col":1},{"mid":"L4hpFmJf2Xd4QmNPs","cx":4,"cy":1,"row":3,"col":1},{"mid":"dKh6q2RoYMxeJS44D","cx":2,"cy":1,"row":4,"col":3},{"mid":"SWE6fffqTQapgPXKe","cx":4,"cy":2,"row":1,"col":1},{"mid":"brxpng2va3eEEXhng","cx":2,"cy":1,"row":4,"col":1},{"mid":"qv97Bitz3jvGRRjoG","cx":2,"cy":2,"row":7,"col":1}]| ],
      [ 'kwt', 'RFubRfEmQJT7AxAqh', %|[{"mid":"nGhrTmEvQ7tMoTNoQ","cx":2,"cy":1,"row":4,"col":3},{"mid":"mPMS3EEYh39EfxSzZ","cx":2,"cy":1,"row":6,"col":3},{"mid":"A44mqQC5QEuRsgBkY","cx":2,"cy":1,"row":5,"col":3},{"mid":"icKrrfPTQMwrG7XtP","cx":2,"cy":1,"row":5,"col":1},{"mid":"oFKe3q8Zy6fxSxMvb","cx":4,"cy":1,"row":3,"col":1},{"mid":"K5ek69rg7hDfzqa33","cx":2,"cy":1,"row":6,"col":1},{"mid":"Jji7azQRSf95nDW8s","cx":4,"cy":2,"row":1,"col":1},{"mid":"6fFXuRrXgqtYzrGhC","cx":2,"cy":1,"row":4,"col":1},{"mid":"Fx8zkGaodRxywo28a","cx":2,"cy":2,"row":7,"col":1}]| ],
      [ 'kgz', 'AkZhCJNMgx2bYcwc7', %|[{"mid":"TXLZZxuKW3KeTCQcX","cx":2,"cy":1,"row":6,"col":3},{"mid":"HyqAxDMRE48NyqPuP","cx":2,"cy":1,"row":5,"col":3},{"mid":"J4nxA4KPf3edGoaDE","cx":2,"cy":1,"row":5,"col":1},{"mid":"AKc5n7FtByExADXgP","cx":4,"cy":1,"row":3,"col":1},{"mid":"Mg5xdxnXrCHMLy7BJ","cx":4,"cy":1,"row":4,"col":1},{"mid":"STxbKkQyQCBvhpkjv","cx":2,"cy":1,"row":6,"col":1},{"mid":"Tq2xbkurpGWanxRsM","cx":4,"cy":2,"row":1,"col":1},{"mid":"iGZNEfdnFs84HKS6Y","cx":2,"cy":1,"row":7,"col":1}] | ],
      [ 'lbn', 'e4An8qe2tHf6nSxie', %|[{"mid":"v4hvmSSfaf2zu3Ds8","cx":2,"cy":1,"row":6,"col":3},{"mid":"RrKyrYN6v7Mkfn9vj","cx":2,"cy":1,"row":5,"col":3},{"mid":"dNRw3NhHScjKxuqEf","cx":2,"cy":1,"row":5,"col":1},{"mid":"rv5diWQfdLqZxhXWY","cx":4,"cy":1,"row":3,"col":1},{"mid":"B5eD3KAvj3S5wk3Px","cx":2,"cy":1,"row":4,"col":3},{"mid":"KHKdgif3cXjdcskou","cx":2,"cy":1,"row":6,"col":1},{"mid":"AnZWtXwDs5AMwcQGj","cx":4,"cy":2,"row":1,"col":1},{"mid":"upYz2zfsuffWbmMjo","cx":2,"cy":1,"row":4,"col":1},{"mid":"T5teNay3TqXexQXJY","cx":2,"cy":2,"row":7,"col":1}]| ],
      [ 'lby', 'MFnLebwaDPXR9xqsz', %|[{"mid":"Z97TmMeJZzyze6qEf","cx":2,"cy":1,"row":5,"col":3},{"mid":"K9GbSqxSjXyBo6858","cx":2,"cy":1,"row":5,"col":1},{"mid":"EnjX8HhTcA6zh2tGa","cx":4,"cy":1,"row":3,"col":1},{"mid":"QiBbYFNuq2iNLokgo","cx":4,"cy":1,"row":4,"col":1},{"mid":"QoWnLdz9YjrDTqAs5","cx":2,"cy":1,"row":6,"col":1},{"mid":"gzK6wLPcND799bsS3","cx":4,"cy":2,"row":1,"col":1},{"mid":"bREemLHoDRpPRYqH4","cx":2,"cy":1,"row":6,"col":3}]| ],
      [ 'mys', 'SYgPtyxgJ8AeQaS9W', %|[{"mid":"qouuDzDXmmMmYkLpt","cx":2,"cy":1,"row":7,"col":3},{"mid":"xwuc9CxYGAyNKGCRQ","cx":2,"cy":1,"row":6,"col":3},{"mid":"wNkSWEj8h4b5qrgNQ","cx":2,"cy":1,"row":6,"col":1},{"mid":"oMZwypiytxLQmYvt9","cx":4,"cy":1,"row":3,"col":1},{"mid":"eLhwKkYTCvoSj4Bjj","cx":2,"cy":1,"row":7,"col":1},{"mid":"zk77mxe7vDgRjoE6A","cx":2,"cy":1,"row":4,"col":3},{"mid":"965NQu2ossfEK3L4E","cx":4,"cy":1,"row":5,"col":1},{"mid":"xyGhqtedgo2GgcyTC","cx":4,"cy":2,"row":1,"col":1},{"mid":"xDKQek8zkYE7ZsN2r","cx":2,"cy":1,"row":4,"col":1},{"mid":"Yb7tL3yJSXcoxjQxF","cx":2,"cy":2,"row":8,"col":1}]| ],
      [ 'mda', 'ytRybDfst6mwRJvr7', %|[{"mid":"jLQdRghYuJi7w6qe5","cx":2,"cy":1,"row":6,"col":1},{"mid":"yXk8br3ovHAZDP5nW","cx":2,"cy":1,"row":6,"col":3},{"mid":"ruGt38g6hFF4QfDWQ","cx":2,"cy":1,"row":5,"col":3},{"mid":"drXLvKs8epEzFWCC8","cx":2,"cy":1,"row":5,"col":1},{"mid":"Eaz6YPPmKQcLFtsMm","cx":4,"cy":1,"row":3,"col":1},{"mid":"BAyQwui4NBXMCgY9R","cx":2,"cy":1,"row":4,"col":3},{"mid":"rr6K7zSk2a9kwWyFB","cx":4,"cy":2,"row":1,"col":1},{"mid":"BGp6vNrgzF6aPgbof","cx":2,"cy":1,"row":4,"col":1},{"mid":"R4i7ddS8TYmfscrJr","cx":2,"cy":2,"row":7,"col":1}]| ],
      [ 'mar', 'rZndyhyZh36gQRqwf', %|[{"mid":"F9Tz48ruKX6hHjyKo","cx":2,"cy":1,"row":6,"col":1},{"mid":"au76ndDfsePnzFoLn","cx":4,"cy":1,"row":3,"col":1},{"mid":"njzvSH6HAfgXTbJ4a","cx":2,"cy":1,"row":7,"col":1},{"mid":"B5tN8fownxYgrwXgS","cx":2,"cy":1,"row":7,"col":3},{"mid":"aAn6AtpCXwjJsHbBY","cx":2,"cy":1,"row":6,"col":3},{"mid":"fvneDrWkamHvqCgsB","cx":2,"cy":1,"row":4,"col":3},{"mid":"ZeWqbzsNLEPQ4bK9p","cx":4,"cy":1,"row":5,"col":1},{"mid":"P5vFzfXdExbBB3Rdu","cx":4,"cy":2,"row":1,"col":1},{"mid":"XE7nnMwcZzymBEXfb","cx":2,"cy":1,"row":4,"col":1},{"mid":"XmPL654AZSkMzmZ98","cx":2,"cy":2,"row":8,"col":1}]| ],
      [ 'nld', 'WMHbpWcPBQYPZyXLC', %|[{"mid":"4FGmjcgGN6Ge9Bc5z","cx":4,"cy":1,"row":3,"col":1},{"mid":"cKsfMAwuTauQCmQGv","cx":2,"cy":1,"row":4,"col":3},{"mid":"Hb48wM2xzbSwLeymq","cx":4,"cy":1,"row":5,"col":1},{"mid":"AwtbRDMCi7R9X7f6C","cx":4,"cy":2,"row":1,"col":1},{"mid":"W2645XaTDvcB3gXWY","cx":2,"cy":1,"row":4,"col":1},{"mid":"2dAFrrTPiEkbA4iE4","cx":2,"cy":2,"row":6,"col":1}]| ],
      [ 'omn', '7aK7KpJJ8aAjhLaoE', %|[{"mid":"JRfR5vjkEpC8ppCGp","cx":2,"cy":1,"row":5,"col":3},{"mid":"fAygkzAjzf4yeRmYR","cx":2,"cy":1,"row":5,"col":1},{"mid":"vRrXzQvgc3NLaMkH5","cx":2,"cy":1,"row":4,"col":3},{"mid":"eoPZNFsTeaP77J4q4","cx":4,"cy":1,"row":3,"col":1},{"mid":"WtskL4XkCsEmo2EEq","cx":2,"cy":1,"row":4,"col":1},{"mid":"bBA3s3YLnnkS4QY3i","cx":2,"cy":1,"row":6,"col":1},{"mid":"PtMDe5d4LDG5ZtYSn","cx":4,"cy":2,"row":1,"col":1}]| ],
      [ 'pak', 'nyQpZNzryT6mshjo3', %|[{"mid":"cScDrezwZPkSzTt7r","cx":2,"cy":1,"row":7,"col":3},{"mid":"SPitFjCv5SkG6L3Zw","cx":2,"cy":1,"row":6,"col":3},{"mid":"MFrYFY3ogXuHpnJfP","cx":2,"cy":1,"row":6,"col":1},{"mid":"7xGiAERYiBrAtARhD","cx":4,"cy":1,"row":3,"col":1},{"mid":"dEPBavTRFeCDScGBu","cx":2,"cy":1,"row":7,"col":1},{"mid":"37jZejGMzZd7GMtgm","cx":2,"cy":1,"row":4,"col":3},{"mid":"3AohZ6nNP5BDMfsxi","cx":4,"cy":1,"row":5,"col":1},{"mid":"zqL76jTxfsW7bPbMT","cx":4,"cy":2,"row":1,"col":1},{"mid":"ZPuuy8yEuA3PqYnsg","cx":2,"cy":1,"row":4,"col":1},{"mid":"mhgf9ZJCutaj4Q2k9","cx":2,"cy":2,"row":8,"col":1}]| ],
      [ 'pse', 'ra7iRqBi5AbBSkA9r', %|[{"mid":"Yr3NQijGqkbwz4ddh","cx":2,"cy":1,"row":4,"col":3},{"mid":"peKkT8zr6WCjHBcYk","cx":2,"cy":1,"row":5,"col":1},{"mid":"Z4d6GNgLs9yar6rXf","cx":4,"cy":1,"row":3,"col":1},{"mid":"4rpqgivtyNvfALETC","cx":4,"cy":2,"row":1,"col":1},{"mid":"Lmhdwg6i7Wk3A4Axe","cx":2,"cy":1,"row":4,"col":1}]| ],
      [ 'qat', 'XHtbc3HDPaRLKWozA', %|[{"mid":"WrocLEGwZjSr52vFS","cx":2,"cy":1,"row":5,"col":3},{"mid":"zdgLcHnWMCM4krRag","cx":2,"cy":1,"row":6,"col":1},{"mid":"6nkhdouA4Sx78qfzF","cx":2,"cy":1,"row":6,"col":3},{"mid":"dk4Jnbhr9By5B8FZt","cx":2,"cy":1,"row":5,"col":1},{"mid":"KbL8Gr9wuSZXsv6uM","cx":4,"cy":1,"row":3,"col":1},{"mid":"simHXHJtH2849c4bc","cx":2,"cy":2,"row":7,"col":1},{"mid":"6zjgjctmpAvZhrcvu","cx":4,"cy":2,"row":1,"col":1},{"mid":"s8T9pPKPWFtrojHJn","cx":2,"cy":1,"row":4,"col":1},{"mid":"ZmRAXMjFrp7EiwfwQ","cx":2,"cy":1,"row":4,"col":3}]| ],
      [ 'rus', 'kGYSud7XQGGvj2rZd', %|[{"mid":"qEPo4HTQEMHtSwLC2","cx":4,"cy":1,"row":3,"col":1},{"mid":"X9JicJ2AitQiFBmjD","cx":2,"cy":1,"row":7,"col":1},{"mid":"Lfct6hFFX2irb6xqv","cx":2,"cy":1,"row":7,"col":3},{"mid":"xnzj94Ku5iYgvM2KS","cx":2,"cy":1,"row":6,"col":3},{"mid":"KXXmxriNJQMjztkeE","cx":2,"cy":1,"row":6,"col":1},{"mid":"48D65RXZGHEzuQ3Mr","cx":2,"cy":1,"row":4,"col":1},{"mid":"m2qWaE6gkddCDPeHk","cx":2,"cy":2,"row":8,"col":1},{"mid":"uGEHpdJAmp8wBGPtW","cx":4,"cy":1,"row":5,"col":1},{"mid":"AsZhG3gWeDKKvhGSd","cx":4,"cy":2,"row":1,"col":1},{"mid":"NiH7PQQC9EyM2iLWm","cx":2,"cy":1,"row":4,"col":3}] | ],
      [ 'sau', 'gdgo52LtCPH6FRxCm', %|[{"mid":"gB9L6ncZjfGTofZDX","cx":2,"cy":1,"row":7,"col":3},{"mid":"b3zhGdZ9S3j5sh6iN","cx":2,"cy":1,"row":6,"col":3},{"mid":"6omT8nwrPtLNkcacX","cx":2,"cy":1,"row":6,"col":1},{"mid":"446haSNLw5zY7speJ","cx":4,"cy":1,"row":3,"col":1},{"mid":"Requ2NoBQek7aa96t","cx":2,"cy":1,"row":7,"col":1},{"mid":"r6SrEDcqr8Wjc5ihv","cx":2,"cy":1,"row":4,"col":1},{"mid":"84b4AasD8muDHCugp","cx":2,"cy":2,"row":8,"col":1},{"mid":"NhLzCLcH5JhbQvAfd","cx":4,"cy":1,"row":5,"col":1},{"mid":"o6GjDifRDZZTxLTR7","cx":4,"cy":2,"row":1,"col":1},{"mid":"MvARh69xTfGX4guxc","cx":2,"cy":1,"row":4,"col":3}]| ],
      [ 'sgp', 'pPChojrAbbsXRYSnm', %|[{"mid":"iCH627W6ATeapkfEm","cx":2,"cy":2,"row":8,"col":1},{"mid":"xZ3Dc4GQsqHniw86m","cx":2,"cy":1,"row":4,"col":1},{"mid":"3QXRgDJnxytaQTSWM","cx":2,"cy":1,"row":4,"col":3},{"mid":"mAunu4FiYSYmySPbC","cx":2,"cy":1,"row":6,"col":1},{"mid":"Lt2zZn7WaWbwXdFyn","cx":4,"cy":1,"row":3,"col":1},{"mid":"dPCZnQFkD6nwYxjgg","cx":2,"cy":1,"row":7,"col":1},{"mid":"p6jaRogMGpZppjoJN","cx":2,"cy":1,"row":7,"col":3},{"mid":"PCXqK6inw4EJz2u79","cx":2,"cy":1,"row":6,"col":3},{"mid":"Wvyq74HxGB3m2hZFE","cx":4,"cy":1,"row":5,"col":1},{"mid":"2kTR6GZYuJM5ikxeg","cx":4,"cy":2,"row":1,"col":1}] | ],
      [ 'kor', 'sYdGByvAaGuEt8FPr', %|[{"mid":"Mxa9WPiz5cWDCh6wx","cx":2,"cy":1,"row":6,"col":3},{"mid":"pw8s2QsAcb3kgAfo9","cx":2,"cy":1,"row":6,"col":1},{"mid":"krk46WZ3vxtXzNJfX","cx":4,"cy":1,"row":3,"col":1},{"mid":"hGc8Wx9QAiBpkjo6D","cx":2,"cy":1,"row":7,"col":1},{"mid":"d9k9vWYA8gujsmdxx","cx":2,"cy":1,"row":7,"col":3},{"mid":"p5ZLZrYLQi5wED4FH","cx":2,"cy":1,"row":4,"col":1},{"mid":"zvtS4McPLBMNxvnQd","cx":2,"cy":2,"row":8,"col":1},{"mid":"TRjCxgYxN3M8FR6iF","cx":4,"cy":1,"row":5,"col":1},{"mid":"5sgKD8KcjKZmoPSHk","cx":4,"cy":2,"row":1,"col":1},{"mid":"2Q4cZM9HPpdfj8AkA","cx":2,"cy":1,"row":4,"col":3}]| ],
      [ 'esp', 'RthxHpsioTTx58bxT', %|[{"mid":"D38jL5f9iWiA9XsgS","cx":4,"cy":1,"row":3,"col":1},{"mid":"Dg3kehexMpYtb4bFM","cx":2,"cy":1,"row":4,"col":1},{"mid":"2q7goE36PeQJAHgEd","cx":2,"cy":2,"row":6,"col":1},{"mid":"SZFiCKMSFzb3CAtgS","cx":4,"cy":1,"row":5,"col":1},{"mid":"3WkcvcMASt5miuEtm","cx":4,"cy":2,"row":1,"col":1},{"mid":"gzHAgaGSnK342BvNw","cx":2,"cy":1,"row":4,"col":3}]| ],
      [ 'lka', 'gsoxMtXNzAjySNimK', %|[{"mid":"cbcvY57M3XzYzgtxH","cx":4,"cy":1,"row":3,"col":1},{"mid":"KDz4Dtcw6AoZcgdkJ","cx":2,"cy":1,"row":4,"col":1},{"mid":"MxiovphtL4w6HxYxR","cx":2,"cy":2,"row":6,"col":1},{"mid":"HhpjFvwus4kjWcQaa","cx":4,"cy":1,"row":5,"col":1},{"mid":"YsNRSsCFFBmz6xHEt","cx":4,"cy":2,"row":1,"col":1},{"mid":"vpj2BtRHrDQ6G6MPu","cx":2,"cy":1,"row":4,"col":3}]| ],
      [ 'sdn', 'TKCGcxHW2G7xj2ZQa', %|[{"mid":"qcuDRB4Cv2fim2n2X","cx":4,"cy":1,"row":3,"col":1},{"mid":"kntDDHdJ4A4HQNvBT","cx":4,"cy":1,"row":5,"col":1},{"mid":"PrsNhkomTQapd97fr","cx":2,"cy":1,"row":4,"col":3},{"mid":"HcQerhDg9NoL7Lc9C","cx":4,"cy":2,"row":1,"col":1},{"mid":"C3KzqfjQvXZCa3eCr","cx":2,"cy":1,"row":4,"col":1},{"mid":"2JNHyr7sqnmmwzhgb","cx":2,"cy":2,"row":6,"col":1}]| ],
      [ 'tha', 'ibfgSsnb5kJvDrj4Y', %|[{"mid":"Prmxw5DdxeNQEDs6n","cx":2,"cy":1,"row":7,"col":3},{"mid":"WP5vLzwYRFYD7ZjZN","cx":2,"cy":1,"row":6,"col":3},{"mid":"p45hqanzv3kqPn6us","cx":2,"cy":1,"row":6,"col":1},{"mid":"Gb6xm93zFCyMiDEds","cx":4,"cy":1,"row":3,"col":1},{"mid":"LtK3sCDw9KvNExtav","cx":2,"cy":1,"row":7,"col":1},{"mid":"kCsXssRAitEDWfj9D","cx":2,"cy":1,"row":4,"col":1},{"mid":"mw7ApN8hd7bRe4Tai","cx":2,"cy":2,"row":8,"col":1},{"mid":"4eJsAt59niLxPMmPi","cx":4,"cy":1,"row":5,"col":1},{"mid":"dhyJ9ZkPQpMHsttAA","cx":4,"cy":2,"row":1,"col":1},{"mid":"iMxGhvyN6DRWnZnGC","cx":2,"cy":1,"row":4,"col":3}]| ],
      [ 'tun', '2gzof3RLrm5daWwnz', %|[{"mid":"QwuEKzn5tRiKBk2N3","cx":2,"cy":1,"row":6,"col":3},{"mid":"zzfNMMS6WG6mMvhcB","cx":2,"cy":1,"row":6,"col":1},{"mid":"6kTsGeFmpc5dDTk2c","cx":4,"cy":1,"row":3,"col":1},{"mid":"vJthgzwFZymMK2Zeb","cx":2,"cy":1,"row":7,"col":3},{"mid":"4sAcK6Zeww5nJan7i","cx":2,"cy":1,"row":4,"col":1},{"mid":"fn7WzkvvMBAoZdazB","cx":2,"cy":2,"row":7,"col":1},{"mid":"catf3y3foc3SDH6vs","cx":4,"cy":1,"row":5,"col":1},{"mid":"2BrZLsdRvchcX8SY2","cx":4,"cy":2,"row":1,"col":1},{"mid":"LJRAbpdBnRvwedKQX","cx":2,"cy":1,"row":4,"col":3}]| ],
      [ 'tur', '8BWLaTAmNeS2NAsBx', %|[{"mid":"avS3tCj7ocpz7dB6M","cx":2,"cy":1,"row":6,"col":3},{"mid":"SZjMfiW2R6sWuWzJ2","cx":2,"cy":1,"row":6,"col":1},{"mid":"JqbrZQAf6FcNp5jG9","cx":4,"cy":1,"row":3,"col":1},{"mid":"Ya3YdnHAasB3nTT6b","cx":2,"cy":1,"row":7,"col":3},{"mid":"435t9BSSajAhc34DR","cx":2,"cy":1,"row":4,"col":1},{"mid":"iyHEZSqZm89GX25Hc","cx":2,"cy":2,"row":7,"col":1},{"mid":"MBuL7eBEL5Y7Mtfe9","cx":4,"cy":1,"row":5,"col":1},{"mid":"P6HzYpoCwziu3fD66","cx":4,"cy":2,"row":1,"col":1},{"mid":"jufrp5rsWnxyGNcRW","cx":2,"cy":1,"row":4,"col":3}]| ],
      [ 'are', 'ZntsmcQjxSQNNuLQD', %|[{"mid":"5GnwdA2om6Ctq2naQ","cx":2,"cy":1,"row":7,"col":3},{"mid":"mBZQtjqbD4qQX78Cf","cx":2,"cy":1,"row":6,"col":3},{"mid":"vCJPXXkivJj3ooRY7","cx":2,"cy":1,"row":6,"col":1},{"mid":"EnuKMmkDWe4jYK4gh","cx":4,"cy":1,"row":3,"col":1},{"mid":"wkjvJtnbLSBnf46YA","cx":2,"cy":1,"row":7,"col":1},{"mid":"asnfYYZjTZjhWGyrQ","cx":2,"cy":1,"row":4,"col":1},{"mid":"tpA2YaHanH2WsTqEc","cx":2,"cy":2,"row":8,"col":1},{"mid":"kG74MQhLi8nxTT3xZ","cx":4,"cy":1,"row":5,"col":1},{"mid":"5KoHhYhgBBk4JJukK","cx":4,"cy":2,"row":1,"col":1},{"mid":"ZmPhvkzjACK6qwBqF","cx":2,"cy":1,"row":4,"col":3}]| ],
      [ 'ukr', 'vv25F5iJ9Yuz3PjiB', %|[{"mid":"adMej3xKTiSWPKcSE","cx":2,"cy":1,"row":6,"col":3},{"mid":"DPp26G7aPprgMJsTL","cx":2,"cy":1,"row":6,"col":1},{"mid":"BgDMRsWnj3gF69hc6","cx":4,"cy":1,"row":3,"col":1},{"mid":"ex8ZZ3zDbEnsrBpBS","cx":2,"cy":1,"row":7,"col":3},{"mid":"iboNixykhSmv8PkjR","cx":2,"cy":1,"row":4,"col":1},{"mid":"KjEX3yEKbHW82qRdG","cx":2,"cy":2,"row":7,"col":1},{"mid":"6WCQEwL4PpFfjXk9J","cx":4,"cy":1,"row":5,"col":1},{"mid":"cFJSTxfhigCbtRvTo","cx":4,"cy":2,"row":1,"col":1},{"mid":"z6QEbbvkKeA4tYoNW","cx":2,"cy":1,"row":4,"col":3}]| ],
      [ 'uzb', 'BeNzwixf2csRrKSZ2', %|[{"mid":"ycQmbTkhLEp6y7AiH","cx":2,"cy":1,"row":6,"col":3},{"mid":"jrXJwTkoeXXEzZ2Zc","cx":2,"cy":1,"row":5,"col":3},{"mid":"9D8QG5GK8Mjba9i5p","cx":2,"cy":1,"row":5,"col":1},{"mid":"cjX6ziNWburp5LxhN","cx":4,"cy":1,"row":3,"col":1},{"mid":"mKWmfxp8Fv9t9Fcoc","cx":2,"cy":1,"row":6,"col":1},{"mid":"upn2ZrQXEak3yecvT","cx":2,"cy":1,"row":7,"col":1},{"mid":"4n5a9ohGxJ2ntyhSo","cx":4,"cy":1,"row":4,"col":1},{"mid":"f6jpj3Ek6PS4aiPd6","cx":4,"cy":2,"row":1,"col":1}]| ],
      [ 'vnm', 'Mbf4dPawhXxkSeZh7', %|[{"mid":"68nq9NMhkgwzGpTm8","cx":2,"cy":1,"row":6,"col":3},{"mid":"RfKxaLwmLrAbxnRrE","cx":2,"cy":1,"row":6,"col":1},{"mid":"LLe8dtbHB3c5zWzwt","cx":4,"cy":1,"row":3,"col":1},{"mid":"wv93FWZ9cmBxoPQLn","cx":2,"cy":1,"row":7,"col":3},{"mid":"WSJR27EY6JPTkurbD","cx":2,"cy":1,"row":4,"col":1},{"mid":"9EwMkAC3kPGQE36Pv","cx":2,"cy":2,"row":7,"col":1},{"mid":"W9qKFmn6nReRMCeqJ","cx":4,"cy":1,"row":5,"col":1},{"mid":"BSvxZf83qDMP9WwQ4","cx":4,"cy":2,"row":1,"col":1},{"mid":"9vmJw9NqH3zh56dF2","cx":2,"cy":1,"row":4,"col":3}]| ],
      [ 'yem', '6Ne2wqtcfpaqf5SGa', %|[{"mid":"iYFusYXFkZ4og9gbh","cx":2,"cy":1,"row":5,"col":3},{"mid":"ojrorfeQEZK3idht2","cx":2,"cy":1,"row":5,"col":1},{"mid":"uqEAx2ekm4KEs7wht","cx":4,"cy":1,"row":3,"col":1},{"mid":"kHooMxcwQvXko3oTy","cx":2,"cy":1,"row":6,"col":1},{"mid":"9RRToWeZYCPqaLJZ9","cx":2,"cy":1,"row":6,"col":3},{"mid":"6hF7twXPxJGZX9vbb","cx":4,"cy":1,"row":4,"col":1},{"mid":"4seXfj92HrdWpCkYT","cx":4,"cy":2,"row":1,"col":1}]| ]
    ]

    country_page_parent = Refinery::Page.find_by_slug '2016-annual-report'

    countries.each { |c|
      next if iso3_code.present? && c[0] != iso3_code

      Rails.logger.info "[icw] country: #{c[0]}"
      country_page = country_page_parent.children.find_by_slug c[0]

      if country_page.nil?
        Rails.logger.info "[icw] creating page for #{c[0]}"

        country = Country.find_by_iso3_code c[0].upcase
        if country.nil?
          Rails.logger.error "[icw] cannot find country for #{c[0]}"
        else
          country_page = country_page_parent.children.create title: country.name, menu_title: country.iso3_code, layout_template: 'report_country'
        end
      end

      widget_dscs = JSON.parse c[2]
      widget_dscs = widget_dscs.sort_by { |wdsc| [ wdsc[ 'row' ], wdsc[ 'col' ] ] }
      import_country_widgets country_page, c[1], widget_dscs
    }

    Rails.logger.info '[icw] end import_country_widgets'
  end

  desc 'Setup original 2014 index and migrate indicator admin_names'
  task :migrate_indicators_2015 => [:environment] do |task|
    if Indicator.in_index( '2014' ).count == 0
      Indicator.update_all( index_name: 'ARCHIVE' )
      Indicator.most_recent.update_all( index_name: '2014' )
    end

    admin_names = {
      'inet' => 'ipr',
      'net' => 'hhnet',
      'wisr' => 'bbsub',
      'mbsr' => 'mobilebb',
      'bbar' => 'bbrate',
      'hbbar' => 'highbbrate',
      'acsp' => 'speedkbps',
      'apcsp' => 'peakspeedkbps',
      'adsp' => 'downloadkbps',
      'ausp' => 'uploadkbps',
      'bbpt1' => 'bbcost1',
      'bbpt2' => 'bbcost2',
      'bbpt3' => 'bbcost3',
      'bbpt4' => 'bbcost4',
      'bbpt5' => 'bbcost5',
      'bbpai' => 'bbcostindex',
      'lit' => 'litrate',
      'psef' => 'edf',
      'psem' => 'edm',
      'GDPcap' => 'gdpcapus',
      'pop' => 'pop',
      'rf' => 'rfactor'
    }

    admin_names.each { |k, v|
      DatumSource.find_by_admin_name( k ).update_attributes( admin_name: v ) if DatumSource.exists?( admin_name: k )
    }

    Indicator.in_index( '2015' ).delete_all

    Indicator.in_index( '2014' ).each { |i|
      i2015 = i.dup
      i2015.index_name = '2015'
      i2015.save
    }
  end

  desc 'Seed datum_source attributes: short_name & display_class after 20160420 migration'
  task :seed_short_name_and_display_class => [ :environment ] do |task|
    affixes = [ '%', 'kbps', '$' ]

    DatumSource.all.each { |ds|
      ds.short_name = ds.public_name

      case "#{ds.display_prefix}#{ds.display_suffix}"
      when '%'
        ds.display_class = 'percentage'

      when 'kbps'
        ds.display_class = 'speed'

      when '$'
        ds.display_class = 'currency'

      end

      ds.save
      Rails.logger.info "#{ds.short_name} is a #{ds.display_class}"
    }
  end

  desc 'Create regions'
  task :create_regions => [:environment] do |task, args|
    categories = Category.all
    CSV.open(Rails.root.join('db', 'regions.csv'), {:headers => true}).each do |line|
      region = Country.find_or_initialize_by_iso3_code iso3_code: line['cc3'], name: line['region'], region: true
      region.categories = categories
      region.save!
    end
  end

  desc 'Read all data from IM spreadsheet and store as indicator data in a named access index'
  task :update_access_index, [:index_name, :data_file] => [:environment] do |task, args|
    update_access_index args[ :index_name ], args[ :data_file ]
  end
end

def export_most_recent( filename )
  if filename.to_s == ''
    puts "Usage: rake imon:export_most_recent['output_filename.csv']"
    return
  end

  puts "Exporting to #{filename}"

  countries = Country.with_enough_data.order( :iso3_code )
  puts "#{countries.count} countries"
  
  CSV.open( filename, 'wb' ) { |csv|
    csv << [ 'c_iso3_code', 'c_name', 'ds_public_name', 'ds_admin_name', 'ds_group', 'ds_affects_score', 'ds_min', 'ds_max', 'ds_default_weight', 'd_start_date', 'd_original_value', 'd_value' ]

    count = 0

    countries.each { |c|
      indicators = c.indicators.affecting_score.in_current_index.order { |i| i.source.public_name }
      puts "#{c.name} has #{indicators.count} data values"

      indicators.each { |d|
        ds = d.source
        csv << [ c.iso3_code, c.name, ds.public_name, ds.admin_name, ( ds.group.present? ? ds.group.admin_name : nil ), ds.affects_score, ds.min, ds.max, ds.default_weight, d.start_date, d.original_value, d.value ]

        count += 1
      }
    }

    puts "#{count} data values exported total"
  }
end

def import_country_bboxes( filename )
  if filename.to_s == ''
    puts "Usage: rake imon:import_country_bboxes['db/data_files/country_bbox.json']"
    return
  end

  if !File.exists? filename
    puts "cannot find #{filename}"
    return
  end

  bbox_json = IO.read filename

  if bbox_json.nil?
    puts "error reading #{filename}"
    return
  end

  bboxen = JSON.parse bbox_json

  if bboxen.nil?
    puts "error parsing JSON from #{filename}"
    return
  end

  bboxen.each { |bbox|
    puts "setting #{bbox[0]} to #{bbox[1]}"
    country = Country.find_by_iso3_code bbox[0]
    if country.present?
      country.bbox = bbox[1].to_s
      country.save
    end
  }
end

def mcp_081
    countries_page = Refinery::Page.find_by_slug( 'zzz-countries' ) || Refinery::Page.find_by_slug( 'country-profiles' )

    if countries_page.nil?
      Rails.logger.info '[mcp] cannot find zzz-countries or country-profiles page, exiting'
      return
    end

    countries_page.update_attributes title: 'Country Profiles'

    countries_page.children.each { |cp|
      Rails.logger.info "[mcp] page: #{cp.title}"
      c = Country.find_by_iso3_code( cp.title.upcase ) || Country.find_by_iso3_code( cp.menu_title.upcase )
      sections = %w[Body Access Control Activity]
      if c.present?
        Rails.logger.info "[mcp] country: #{c.name}"
        cp.update_attributes title: c.name, menu_title: c.iso3_code.downcase
        contents = sections.map { |s| "<h2>#{s == 'Body' ? 'Overview' : s}</h2>#{cp.content_for s}" }
        # reduce Body section to first line
        contents[0] = contents[0].lines[0].strip
        new_body = contents.join "\r\n"
        Rails.logger.info "[mcp] new_body: #{new_body}"
        cp.part_with_title( 'Body' ).update_attributes body: new_body
      else
        Rails.logger.info "[mcp] country: nil"
      end
    }
end

def widget_embed( dashboard_host, widget_dsc )
  %{<iframe src="#{dashboard_host}/widgets/#{widget_dsc[ 'mid' ]}/embed?unbranded&seamless&noCountry" width="#{165*widget_dsc[ 'cx' ]}" height="#{165*widget_dsc[ 'cy' ]}" frameborder="0" scrolling="no" data-row="#{widget_dsc[ 'row' ]}" data-col="#{widget_dsc[ 'col' ]}"></iframe>}
end

def import_country_widgets( cp, dashboard_id, widget_dscs )
  dashboard_host = 'https://dashboard.thenetmonitor.org'
  dashboard_root = "#{dashboard_host}/dashboards"
  dashboard_url = "#{dashboard_root}/#{dashboard_id}"

  if cp.nil?
    Rails.logger.error "[icw] cp: nil, dashboard_id: #{dashboard_id}"
    return
  end

  Rails.logger.info "[icw] cp: #{cp.slug}, dashboard_id: #{dashboard_id}, widget_count: #{widget_dscs.count}"

  if !dashboard_id.present?
    return
  end

  body = '<div class="widget-row">'
  current_row = 1

  widget_dscs.each_with_index { |wdsc, i|
    if i == 1
      body += '</div><h2>Internet Access</h2><div class="widget-row">'
    elsif i == 2
      body += '</div><h2>Internet Connectivity</h2><div class="widget-row">'
    end

    if wdsc[ 'row' ] != current_row
      Rails.logger.info "[icw] widget-row wdsc[row]: #{wdsc['row']}, current_row: #{current_row}"
      body += '</div><div class="widget-row">'
      current_row = wdsc[ 'row' ].to_i
    end
    body += "#{widget_embed dashboard_host, wdsc}\r\n"
  }
  body += '</div>'

  Rails.logger.info "[icww] #{body}"

  body_part = cp.part_with_title( 'Body' )
  
  if body_part.nil?
    cp.parts << Refinery::PagePart.new( title: 'Body', body: body )

  else
    body_part.update_attributes body: body
  end
end

def replace_static_source( row_number, iso3_code )
  sources = Roo::Excelx.new Rails.root.join('db', 'sources.xlsx').to_s

  line = CSV.parse( sources.sheet( sources.default_sheet ).to_csv, { :headers => true } )[row_number.to_i - 1]

  if line.nil?
    puts "cannot find source line #{row_number}"
    return
  end

  ds = DatumSource.find_by_admin_name line[ 'Short name' ]
  if ds.nil?
    puts "cannot find DatumSource #{line[ 'Short name' ]}"
    return
  end

  country = Country.find_by_iso3_code iso3_code
  if country.nil?
    puts "cannot find Country #{iso3_code}"
    return
  end

  datum = Datum.where( { datum_source_id: ds.id, country_id: country.id } ).order( 'start_date desc' ).limit( 1 )
  if datum.count == 0
    puts "cannot find existing datum"
    return
  end

  datum = datum.first

  puts "Replacing #{ds.public_name} for #{country.name} (datum.id #{datum.id})"

  Retriever.retrieve!( row_number, datum )
end


def update_access_index( index_name, data_file )
  Rails.logger.info "update_access_index #{index_name}, #{data_file}"

  index_indicators = {
    '2014' => %w[ipr_2013 hhnet_2013 bbsub_2013 mobilebb_2013 rfactor_2014 bbrate_2014 highbbrate_2014 speedkbps_2014 peakspeedkbps_2014 downloadkbps_2014 uploadkbps_2014 bbcost1_2014 bbcost2_2014 bbcost3_2014 bbcost4_2014 bbcost5_2014 bbcostindex_2014 litrate_2014 edf_2014 edm_2014 gdpcapus_2013 pop_2013],
    '2015' => %w[ipr_2014 hhnet_2014 bbsub_2014 mobilebb_2014 rfactor_2015 bbrate_2015 highbbrate_2015 speedkbps_2015 peakspeedkbps_2015 downloadkbps_2015 uploadkbps_2015 bbcost1_2015 bbcost2_2015 bbcost3_2015 bbcost4_2015 bbcost5_2015 bbcostindex_2015 litrate_2015 edf_2015 edm_2015 gdpcapus_2014 pop_2014]
  }

  if index_name.nil? || index_indicators[ index_name ].nil?
    Rails.logger.error 'update_access_index: invalid index_name'
    return
  end

  if data_file.nil? || !File.exists?( data_file )
    Rails.logger.error "update_access_index: cannot open data_file: #{data_file}"
    return
  end

  ds_cols = index_indicators[ index_name ]

  data_text = IO.read( data_file ).encode( invalid: :replace, undef: :replace, replace: '?' )

  CSV.parse( data_text, { :headers => true } ).each do |row|
    begin
      # unscoped to include regions
      c = Country.unscoped.find_by_iso3_code row['cc3'].upcase

      if c.nil?
        Rails.logger.error "update_access_index: cannot find country #{row['cc3']}"
        next
      end

      ds_cols.each { |ds_col| 
        ds_parts = ds_col.split('_')

        ds = DatumSource.find_by_admin_name ds_parts[0]
        datum_date = "#{ds_parts[1]}-12-31".to_date

        is = Indicator.where datum_source_id: ds.id, index_name: index_name, country_id: c.id
        indicator = nil

        if is.any?
          if row[ds_col].blank?
            is.delete_all
          else
            Rails.logger.info "update_access_index: indicator.update_attributes original_value: #{row[ds_col].to_f}"
            indicator = is.first
            indicator.original_value = row[ds_col].to_f * ds.multiplier
            indicator.start_date = datum_date
          end
        else
          if !row[ds_col].blank?
            Rails.logger.info "update_access_index: Indicator.create datum_source: #{ds.admin_name}, start_date: #{datum_date}, country: #{c.iso3_code}, original_value: #{row[ds_col].to_f}"
            indicator = Indicator.new datum_source_id: ds.id, index_name: index_name, start_date: datum_date, country_id: c.id, original_value: ( row[ds_col].to_f * ds.multiplier )
          end
        end

        if !indicator.nil?
          if ds.normalized
            if ds.normalized_name.present?
              normalized_col = "#{ds.normalized_name}_#{ds_parts[1]}"
              indicator.value = row[normalized_col].to_f
            else
              indicator.value = indicator.original_value
            end
            indicator.value = 1 - indicator.value if ds.invert
          end
          indicator.save!
        end
      }
    rescue Exception => e
      Rails.logger.error "update_access_index: error importing index data: #{row}"
      Rails.logger.error e.inspect
    end

  end

  Country.count_indicators!( index_name )
  DatumSource.recalc_min_max_and_values!( index_name )
  Country.calculate_scores_and_rank!( index_name )

  Region.count_indicators!( index_name )
  Region.calculate_scores_and_rank!( index_name )
end
