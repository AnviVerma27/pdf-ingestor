class AddPdfIdToQuestions < ActiveRecord::Migration[6.0]
  def change
    add_reference :questions, :pdf, foreign_key: true, null: true
  end
end
