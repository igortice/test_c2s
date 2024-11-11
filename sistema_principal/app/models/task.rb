class Task < ApplicationRecord
  include Associations
  include Validations
  include Statusable
  include Broadcastable
  include Detailable
end
