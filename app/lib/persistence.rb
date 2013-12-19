class Persistence
  def self.get(key)
    NSUserDefaultsController.sharedUserDefaultsController.values.valueForKey(key)
  end
end