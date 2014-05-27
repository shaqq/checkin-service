class CreateCheckin < ActiveRecord::Migration
  def change
    create_table :checkins do |t|
      t.references :user
      t.references :business

      t.timestamps
    end
  end
end
