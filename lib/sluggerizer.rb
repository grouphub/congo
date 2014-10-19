class Sluggerizer
  def self.sluggerize(string)
    str = string.downcase.gsub(/[^\w]/, "_").gsub(/__+/, "_")
    str = str[1..-1] while str[0] == "_"
    str = str[0..-2] while str[-1] == "_"
    str
  end
end

