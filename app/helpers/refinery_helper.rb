module RefineryHelper
  # return content based on page slug & part name
  def part_content( slug, part_name )
    page = Refinery::Page.by_slug slug
    content = page.first.content_for( part_name ) unless page.empty?
  end
end
