class CreateTagAssignments < ActiveRecord::Migration
  def self.up
    create_table :tag_assignments do |t|
      t.integer :transaction_id
      t.integer :tag_id
      t.integer :source

      t.timestamps
    end
  end

  def self.down
    drop_table :tag_assignments
  end
end
