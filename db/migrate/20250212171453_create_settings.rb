class CreateSettings < ActiveRecord::Migration[8.0]
  def change
    create_table :settings do |t|
      t.string :name
      t.string :code, index: true
      t.text   :description
      t.string :value_type
      t.string :value
      t.timestamps
    end

    Setting.create(
      name: 'System Live',
      code: 'system_live',
      description: 'Is the system live?',
      value_type: 'boolean',
      value: 'true'
    ) unless Setting.find_by(code: 'system_live').present?

    Setting.create(
      name: 'Chud Checkpoint Time?',
      code: 'chud_checkpoint_time',
      description: 'Can attendees spend their chuds on peformers?',
      value_type: 'boolean',
      value: 'false'
    ) unless Setting.find_by(code: 'chud_checkpoint_time').present?

    Setting.create(
      name: 'Attendee Starting Chuds',
      code: 'attendee_starting_chuds',
      description: 'How many chuds do attendees start with?',
      value_type: 'integer',
      value: '0'
    ) unless Setting.find_by(code: 'attendee_starting_chuds').present?

    Setting.create(
      name: 'Performer Starting Chuds',
      code: 'performer_starting_chuds',
      description: 'How many chuds do performers start with?',
      value_type: 'integer',
      value: '0'
    ) unless Setting.find_by(code: 'performer_starting_chuds').present?

    Setting.create(
      name: 'Performer Starting Performance Points',
      code: 'performer_starting_performance_points',
      description: 'How many performance points do performers start with?',
      value_type: 'integer',
      value: '0'
    ) unless Setting.find_by(code: 'performer_starting_performance_points').present?
  end
end
