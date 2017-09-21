# encoding: utf-8
Refinery::Pages.configure do |config|
  # Configure specific page templates
  # config.types.register :home do |home|
  #   home.parts = %w[intro body]
  # end

  # Configure global page default parts
  config.default_parts = [
    { title: 'Body', slug: 'body' },
    { title: 'Side Body', slug: 'side_body' },
    { title: 'Graph', slug: 'graph' },
    { title: 'Table', slug: 'table' }
  ]

  # Configure whether to allow adding new page parts
  config.new_page_parts = true

  # Configure whether to enable marketable_urls
  # config.marketable_urls = true

  # Configure how many pages per page should be displayed when a dialog is presented that contains a links to pages
  # config.pages_per_dialog = 14

  # Configure how many pages per page should be displayed in the list of pages in the admin area
  # config.pages_per_admin_index = 20

  # Configure whether to strip diacritics from Western characters
  # config.approximate_ascii = false

  # Configure whether to strip non-ASCII characters from the friendly_id string
  # config.strip_non_ascii = false

  # Set this to true if you want to override slug which automatically gets generated
  # when you create a page
  config.use_custom_slugs = true

  config.add_whitelist_elements = %w( iframe )
  config.add_whitelist_attributes = %w( frameborder scrolling data-row data-col )
  
  # Set this to true if you want backend pages to be cached
  # config.cache_pages_backend = false

  # Set this to true to activate full-page-cache
  # config.cache_pages_full = false

  # Set this to true to fully expand the page hierarchy in the admin
  # config.auto_expand_admin_tree = true

  config.layout_template_whitelist = ['application', 'report', 'report_country', 'embed', 'bulletin']

  # config.view_template_whitelist = ['home', 'show']

  config.use_layout_templates = true

  config.use_view_templates = false

  # config.page_title = {:chain_page_title=>false, :ancestors=>{:separator=>" | ", :class=>"ancestors", :tag=>"span"}, :page_title=>{:class=>nil, :tag=>nil, :wrap_if_not_chained=>false}}

  # config.absolute_page_links = false
end
