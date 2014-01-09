PublicActivity::Activity.class_eval do
  attr_accessible :owner, :key, :parameters, :recipient
end