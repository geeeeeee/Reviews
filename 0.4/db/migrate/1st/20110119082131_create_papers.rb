class CreatePapers < ActiveRecord::Migration
  def self.up
    create_table :papers do |t|
      t.string :first_name
      t.string :last_name
      t.string :postal_address
      t.string :postal_code
      t.string :nation
      t.string :phone
      t.string :fax
      t.string :email
      t.string :title
      t.integer :number_of_authors
      t.text :names_of_authors
      t.text :emails_of_authors
      t.text :abstract
      t.string :types
      t.string :section
      t.text :keywords
      t.string :status
      t.datetime :receive_time
      t.string :user_id
      
      t.string :examiner1
      t.string :examiner2
      t.string :examiner3
      t.string :examiner_name1
      t.string :examiner_name2
      t.string :examiner_name3
      
      t.text :comment1
      t.text :comment2
      t.text :comment3
      
      t.text :result

      t.timestamps
    end
  end

  def self.down
    drop_table :papers
  end
end
