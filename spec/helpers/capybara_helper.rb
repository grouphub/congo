require 'rails_helper'

module CapybaraHelper

  def test_debug(msg)
    puts(msg.light_blue) if ENV['TEST_DEBUG']
  end

  def scroll_by(y)
    page.execute_script "window.scrollBy(0, #{y})"
  end

  def scroll_to_bottom
    scroll_by(10000)
  end

  def wait_for(message, seconds = 5, &block)
    (seconds * 10).times do |i|
      break if yield
      sleep(i * 0.1)
    end

    fail("Expected #{message}") unless yield
  end

end

