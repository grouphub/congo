#Overriding S3 class to avoid using fakes3 during this test.
class S3
  class << self
    def store(*args)
      return true
    end

    def public_url(*args)
      Faker::Internet.url
    end
  end
end
