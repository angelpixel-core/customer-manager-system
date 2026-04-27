class CreatePlatformEventDeadLetters < ActiveRecord::Migration[8.1]
  def change
    create_table :platform_event_dead_letters do |t|
      t.string :event_name, null: false
      t.jsonb :event_payload, null: false, default: {}
      t.jsonb :context, null: false, default: {}
      t.jsonb :metadata, null: false, default: {}
      t.string :error_class, null: false
      t.text :error_message, null: false
      t.datetime :occurred_at, null: false
      t.datetime :failed_at, null: false

      t.timestamps
    end

    add_index :platform_event_dead_letters, :event_name
    add_index :platform_event_dead_letters, :failed_at
    add_index :platform_event_dead_letters, :error_class
  end
end
