class CreateAttendances < ActiveRecord::Migration
  def change
    create_table :attendances do |t|
      t.integer :student_id
      t.integer :movie_id

      t.timestamps null: false
    end
  end
end
