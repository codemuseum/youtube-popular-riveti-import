class CreateCrawls < ActiveRecord::Migration
  def self.up
    create_table :crawls do |t|
      t.text :urls

      t.timestamps
    end
  end

  def self.down
    drop_table :crawls
  end
end
