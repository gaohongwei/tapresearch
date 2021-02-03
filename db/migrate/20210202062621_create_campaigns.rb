class CreateCampaigns < ActiveRecord::Migration[5.2]
  def change
    create_table :campaigns, :id => false do |t|
      t.integer :campaign_id
      t.string :name
      t.string :cpi
      t.integer :length_of_interview

      t.timestamps
    end
    add_index :campaigns, :campaign_id, unique: true
  end
end
