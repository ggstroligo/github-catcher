class CreateIssues < ActiveRecord::Migration[7.0]
  def change
    create_table :issues do |t|
      t.text :title, null: false
      t.integer :number, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
