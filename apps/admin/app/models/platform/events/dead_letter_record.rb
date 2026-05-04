# == Schema Information
#
# Table name: platform_event_dead_letters
#
#  id            :integer          not null, primary key
#  event_name    :string           not null
#  event_payload :jsonb            default("{}"), not null
#  context       :jsonb            default("{}"), not null
#  metadata      :jsonb            default("{}"), not null
#  error_class   :string           not null
#  error_message :text             not null
#  occurred_at   :datetime         not null
#  failed_at     :datetime         not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_platform_event_dead_letters_on_error_class  (error_class)
#  index_platform_event_dead_letters_on_event_name   (event_name)
#  index_platform_event_dead_letters_on_failed_at    (failed_at)
#

# frozen_string_literal: true

module Platform
  module Events
    class DeadLetterRecord < ApplicationRecord
      self.table_name = "platform_event_dead_letters"
    end
  end
end
