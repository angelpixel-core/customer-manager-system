module Admin
  module Infrastructure
    class SendWelcomeEmailWorker
      include Faktory::Job

      def perform(email)
        Rails.logger.info("Sending welcome email to #{email}")
      end
    end
  end
end
