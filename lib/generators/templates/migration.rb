class ActsAsFollowerMigration < ActiveRecord::Migration[Rails::VERSION::STRING[0..2].to_f]
  def self.up
    create_table :follows, force: true do |t|
      t.references :followable, polymorphic: true, null: false
      t.references :follower,   polymorphic: true, null: false
      t.boolean :blocked, default: false, null: false
      t.timestamps
    end

    add_index :follows, ["follower_id", "follower_type"],     name: "fk_follows"
    add_index :follows, ["followable_id", "followable_type"], name: "fk_followables"
  end

  def self.down
    drop_table :follows
  end
end
