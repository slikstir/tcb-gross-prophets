class AddAdditionalSettings < ActiveRecord::Migration[8.0]
  def up
    change_column :settings, :value, :text

    Setting.create(
      name: 'Homepage Image',
      code: 'homepage_image',
      description: 'The image displayed on the homepage when a user logs in',
      value_type: 'image'
    ) unless Setting.find_by(code: 'homepage_image').present?

    Setting.create(
      name: 'Homepage Text',
      code: 'homepage_text',
      description: 'The text displayed on the homepage when a user logs in',
      value_type: 'text'
    ) unless Setting.find_by(code: 'homepage_text').present?

    Setting.create(
      name: 'Performance Code',
      code: 'show_code',
      description: 'A unique code for the show required to log into the site as an attendee',
      value_type: 'text',
      value: 'DEFAULT'
    ) unless Setting.find_by(code: 'show_code').present?

    Setting.create(
      name: 'Max Performers Chuds',
      code: 'max_performers_chuds',
      description: 'The maximum number of chuds on the performer status bar',
      value_type: 'integer',
      value: '300'
    ) unless Setting.find_by(code: 'max_performers_chuds').present?
  end

  def down
    change_column :settings, :value, :string
  end
end
