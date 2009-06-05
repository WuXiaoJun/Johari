class CreateSurveys < ActiveRecord::Migration
  def self.up
    create_table :surveys do |t|
      t.integer :user_id
      t.integer :poster_id
      t.string :content
      t.datetime :created_at

      t.timestamps
    end
  end

  def self.down
    drop_table :surveys
  end
end
