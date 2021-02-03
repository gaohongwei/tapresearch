class CreateQualifications < ActiveRecord::Migration[5.2]
  def change
    create_table :qualifications do |t|
      t.integer :quotum_id
      t.integer :question_id
      t.text :pre_codes

      t.timestamps
    end
    add_index(:qualifications, :quotum_id)
    add_index(:qualifications, [:quotum_id, :question_id], unique: true)

  end
end
