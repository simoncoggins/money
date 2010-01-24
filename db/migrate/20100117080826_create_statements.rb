class CreateStatements < ActiveRecord::Migration
  def self.up
    create_table :statements do |t|
      t.string :name

      t.timestamps
    end

    add_column :transactions, :statement_id, :integer
  end

  def self.down
    drop_table :statements

    remove_column :transactions, :statement_id
  end
end
