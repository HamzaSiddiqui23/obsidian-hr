class IncomeTaxSlabs < ActiveRecord::Migration[5.2]
  def change
    create_table :tax_slabs do |t|
      t.float   :income_start
      t.float   :income_end
      t.float   :fixed_tax
      t.float   :percentage_tax
      t.date    :tax_slab_year_start
      t.date    :tax_slab_year_end
    end
  end
end
