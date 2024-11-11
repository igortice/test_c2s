module TaskJobEnqueueable
  extend ActiveSupport::Concern

  included do
    after_create_commit :enqueue_scraping_job
  end

  private

  def enqueue_scraping_job
    StartScrapJob.perform_now(self.id) if persisted?
  end
end
