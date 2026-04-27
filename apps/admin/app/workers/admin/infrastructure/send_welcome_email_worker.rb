module Admin
  module Infrastructure
    # Background job for post-signup welcome email side effect.
    class SendWelcomeEmailWorker
      include Faktory::Job

      # @param email [String]
      # @return [void]
      def perform(email)
        Rails.logger.info("Sending welcome email to #{email}")
      end
    end
  end
end
