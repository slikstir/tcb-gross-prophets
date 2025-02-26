class AddTosAndAboutSettings < ActiveRecord::Migration[8.0]
  def change
    Setting.create(
      name: "Terms of Service",
      code: "terms",
      description: "The Terms of Service Page",
      value_type: "html",
      value: "",
    ) unless Setting.find_by(code: "terms").present?

    Setting.create(
      name: "Frequently Asked Questions",
      code: "faq",
      description: "The FAQ Page",
      value_type: "html",
      value: "",
    ) unless Setting.find_by(code: "faq").present?

    Setting.create(
      name: "About the Company",
      code: "company",
      description: "The Company Page",
      value_type: "html",
      value: "",
    ) unless Setting.find_by(code: "company").present?
  end
end
