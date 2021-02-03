class CreateQuota < ActiveRecord::Migration[5.2]
  def change
    create_table :quota, :id => false do |t|
      t.integer :campaign_id
      t.integer :quotum_id
      t.string :name

      t.timestamps
    end
    add_index(:quota, :campaign_id)
    add_index(:quota, [:campaign_id, :quotum_id], unique: true)
  end
end
