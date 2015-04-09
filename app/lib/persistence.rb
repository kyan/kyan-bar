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

  def self.uid
    Persistence.get("jukeboxUserID")
  end

  def self.username
    Persistence.get("jukeboxUsername")
  end

  def self.password
    Persistence.get("jukeboxPassword")
  end
end