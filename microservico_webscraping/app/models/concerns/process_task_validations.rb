module ProcessTaskValidations
  extend ActiveSupport::Concern

  included do
    # Validações
    validates :task_url, :task_id, :user_id, presence: true
    validates :task_url, format: { with: /\A#{URI::DEFAULT_PARSER.make_regexp(%w[http https])}\z/, message: "must be a valid URL" }
    validates :task_status, inclusion: { in: task_statuses.keys }
  end
end
