require 'rails_helper'

module CapybaraHelper

  def test_debug(msg)
    puts(msg.light_blue) if ENV['TEST_DEBUG']
  end

  def scroll_by(y, selector=nil)
    if selector
      page.execute_script "$('#{selector}')[0].scrollBy(0, #{y})"
    else
      page.execute_script "window.scrollBy(0, #{y})"
    end
  end

  def scroll_to_bottom(selector=nil)
    scroll_by(10000, selector)
  end

  def scroll_to_element_in(selector, parentSelector)
    page.execute_script %[
      var item = $('#{selector}');
      $('#{parentSelector}')[0].scrollBy(0, item.offset().top - item[0].clientHeight)
    ]
  end

  def wait_for(message, seconds = 5, &block)
    (seconds * 10).times do |i|
      break if yield
      sleep(i * 0.1)
    end

    fail("Expected #{message}") unless yield
  end

end

