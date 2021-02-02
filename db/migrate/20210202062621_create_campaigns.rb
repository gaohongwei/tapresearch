class CreateCampaigns < ActiveRecord::Migration[5.2]
  def change
    create_table :campaigns do |t|
      t.string :name
      t.string :cpi
      t.integer :length_of_interview

      t.timestamps
    end
  end
end
