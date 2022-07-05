class CreateUseUunablSschedules < ActiveRecord::Migration[5.2]
  def change
    create_table :use_uunabl_sschedules do |t|
      t.references :user, foreign_key: true
      t.date :date
      t.time :working_time_from
      t.time :working_time_to

      t.timestamps
    end
  end
end
