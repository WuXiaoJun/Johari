class AddSurveyResultToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :survey_result, :string, :default => "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0" 
    add_column :users, :survey_result_self, :string, :default => "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0" 
  end

  def self.down
    remove_column :users, :survey_result
    remove_column :users, :survey_result
  end
end
