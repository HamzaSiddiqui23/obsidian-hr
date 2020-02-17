class TaxSlab < ApplicationRecord
  before_validation :validate_tax_slab, on: :create

  def validate_tax_slab
    self.tax_slab_year_start =  Date::new(tax_slab_year_start.year,07,01)
    self.tax_slab_year_end   =  Date::new(tax_slab_year_start.year + 1,06,30)

    if income_end.nil?
      self.income_end = Float::INFINITY
    end

    if !TaxSlab.where("income_start <= ? AND income_end > ? AND tax_slab_year_start = ?",income_start,income_start,tax_slab_year_start).empty?
      errors.add(:base, "Income Start Already exists for Tax Slab year")
      throw :abort
    end
    if !TaxSlab.where("income_start < ? AND income_end >= ? AND tax_slab_year_start = ?",income_end,income_end,tax_slab_year_start).empty?
      errors.add(:base, "Income End Already exists for Tax Slab year")
      throw :abort
    end
    if income_start >= income_end
      errors.add(:base, "Income Start Should be Greater Than Income End")
      throw :abort
    end
  end
end