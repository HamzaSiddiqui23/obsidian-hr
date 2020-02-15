class IncomeTaxSlabs < ActiveRecord::Migration[5.2]
  def change
    create_table :tax_slabs do |t|
      t.integer :income_start
      t.integer :income_end
      t.integer :fixed_tax
      t.integer :percentage_tax
      t.integer :exceeding_amount
      t.date    :tax_slab_year_start
      t.date    :tax_slab_year_end
    end
  end
end
