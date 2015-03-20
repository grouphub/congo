class ThirtySix
  # Generate a random base-36 UUID. For example, "3qbhnswtuka3ecwc5t647n1i6".
  def self.generate
    SecureRandom.uuid.gsub('-', '').to_i(16).to_s(36)
  end
end

