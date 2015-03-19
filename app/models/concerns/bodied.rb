module Described
  extend ActiveSupport::Concern

  included do
    before_save :populate_description
  end

  def populate_description
    self.description_markdown ||= ''
    self.description_html ||= ''
  end

  def description=(content)
    self.description_markdown = content
    self.description_html = Kramdown::Document.new(content).to_html
  end
end

