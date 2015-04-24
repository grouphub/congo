class Maintenance
  def self.start
    Redis.current.set('maintenance_mode', true)
  end

  def self.stop
    Redis.current.del('maintenance_mode')
  end

  def self.in_progress?
    !!Redis.current.get('maintenance_mode')
  end
end

