class User < ActiveRecord::Base

  has_many :questions
  # has_and_belongs_to_many :user_types

  # validates_presence_of [:firstname, :lastname]
  # validates_length_of [:firstname, :lastname], within: 2..10
  # validates_uniqueness_of :lastname, if: :lastname?, :message => I18n.t("validations.lastname.taken")
  # validates_numericality_of :age, {only_integer: true, greater_than_or_equal_to: 0}
  #
  # validate :custom_email_validator
  # validates_format_of :email, if: :email?, :with => /\A([_a-zA-Z0-9À-ž\.\-\+]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, :message => I18n.t("validations.email.new_error")
  #
  # before_save :set_age_in_months, if: :age?
  #
  # private
  #
  # def custom_email_validator
  #   return if email.blank?
  #   return if email.match(/\A([_a-zA-Z0-9À-ž\.\-\+]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i)
  #
  #   errors.add(I18n.t("validations.email.new_error"))
  # end
  #
  # def set_age_in_months
  #   self.age_in_months = self.age * 12
  # end

end
