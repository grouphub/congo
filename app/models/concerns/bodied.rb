module Bodied
  extend ActiveSupport::Concern

  def description=(content)
    self.description_markdown = content
    self.description_html = Kramdown::Document.new(content).to_html
  end

  def description
    self.description_markdown
  end
end

