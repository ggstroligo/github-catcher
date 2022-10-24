class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.text :action, null: false, index: true
      t.references :actionable, polymorphic: true, null: false, index: true

      t.timestamps
    end
  end
end
