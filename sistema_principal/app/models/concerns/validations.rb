module Validations
  extend ActiveSupport::Concern

  included do
    validates :title, presence: true
    validates :url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp }

    # Outras validações específicas para Task
  end
end
