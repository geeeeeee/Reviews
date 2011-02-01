class CreateAssets < ActiveRecord::Migration
  def self.up
    create_table :assets do |t|
      t.integer :paper_id

      t.timestamps
    end
  end

  def self.down
    drop_table :assets
  end
end
