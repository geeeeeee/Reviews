class AddSectionToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :section, :string
  end

  def self.down
    remove_column :users, :section
  end
end
