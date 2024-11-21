class CreateSleeps < ActiveRecord::Migration[7.0]
  def change
    create_table :sleeps do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :sleep_start_time
      t.datetime :sleep_end_time
      t.integer :duration_minutes

      t.timestamps
    end
  end
end
