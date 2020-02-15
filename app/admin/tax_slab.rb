ActiveAdmin.register TaxSlab do
  permit_params :income_start, :income_end, :fixed_tax, :percentage_tax, :exceeding_amount, :tax_slab_year_start, :tax_slab_year_end

  form  do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs 'Tax Slab Details' do
      f.input :income_start
      f.input :income_end
      f.input :fixed_tax
      f.input :percentage_tax
      f.input :exceeding_amount
      f.input :tax_slab_year_start, as: :date_select, discard_day: true, discard_month: true
      end
    f.actions
  end
end