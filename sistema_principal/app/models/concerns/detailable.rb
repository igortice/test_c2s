module Detailable
  extend ActiveSupport::Concern

  def marca
    if details.present?
      details["marca"]
    else
      nil
    end
  end

  def modelo
    if details.present?
      details["modelo"]
    else
      nil
    end
  end

  def preco
    if details.present?
      details["preco"]
    else
      nil
    end
  end
end
