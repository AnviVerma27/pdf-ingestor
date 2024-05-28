class CreatePdfs < ActiveRecord::Migration[7.1]
  def change
    create_table :pdfs do |t|
      t.references :user, null: false, foreign_key: true
      t.string :file_name

      t.timestamps
    end
  end
end
