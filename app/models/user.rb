class User < ActiveRecord::Base

  has_many :questions

  :validates_presence [:firstname, :lastname]
  validates_length_of [:firstname, :lastname], minimum: 2

  validate :custom_email_validator

  validates_numericality_of :age, {only_integer: true, greater_than_or_equal_to: 0}

  private

  def custom_email_validator
    return if email.match(/\A([_a-zA-Z0-9À-ž\.\-\+]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i)

    errors.add(I18n.t("validations.email.new_error"))
  end

end
