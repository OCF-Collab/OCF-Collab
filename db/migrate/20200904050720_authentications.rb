class Authentications < ActiveRecord::Migration[6.0]
  def change
    create_table :authentications do |t|
      t.boolean :enabled, default: true
      t.json :auth
      t.timestamps
    end
  end
end
