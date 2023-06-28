class CreateLineItemDates < ActiveRecord::Migration[7.0]
  def change
    create_table :line_item_dates do |t|
      t.references :quote, null: false, foreign_key: true
      # Adding null: false constraint on date
      t.date :date, null: false

      t.timestamps
    end

    # Adding uniqueness constraint for the couple date and quote_id
    add_index :line_item_dates, [:date, :quote_id], unique: true
    # Adding index to the date field for performance reasons
    add_index :line_item_dates, :date
  end
end