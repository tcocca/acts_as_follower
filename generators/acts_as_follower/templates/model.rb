class Follow < ActiveRecord::Base

  named_scope :for_follower,    lambda { |*args| {:conditions => ["follower_id = ? AND follower_type = ?", args.first.id, args.first.type.name]} }
  named_scope :for_followable, lambda { |*args| {:conditions => ["followable_id = ? AND followable_type = ?", args.first.id, args.first.type.name]} }
  named_scope :recent,       lambda { |*args| {:conditions => ["created_at > ?", (args.first || 2.weeks.ago).to_s(:db)]} }
  named_scope :descending, :order => "created_at DESC"
  named_scope :unblocked, :conditions => {:blocked => false}
  named_scope :blocked, :conditions => {:blocked => true}

  # NOTE: Follows belong to the "followable" interface, and also to followers
  belongs_to :followable, :polymorphic => true
  belongs_to :follower,   :polymorphic => true

  def block!
    self.update_attribute(:blocked, true)
  end

end

