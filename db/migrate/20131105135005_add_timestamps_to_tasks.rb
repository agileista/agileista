class AddTimestampsToTasks < ActiveRecord::Migration
  def change
    change_table(:tasks) do |t|
      t.timestamps null: false
    end
  end
end
