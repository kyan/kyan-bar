class Persistence
  def self.get(key)
    self.shared_defaults.values.valueForKey(key)
  end

  def self.set(key, value)
    self.shared_defaults.defaults.setObject(value, forKey:key)
    self.shared_defaults.defaults.synchronize
  end

  def self.shared_defaults
    NSUserDefaultsController.sharedUserDefaultsController
  end
end