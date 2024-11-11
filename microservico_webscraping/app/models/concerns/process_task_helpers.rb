module ProcessTaskHelpers
  extend ActiveSupport::Concern

  included do
    # Callbacks ou métodos específicos para a lógica da task
    before_save :normalize_data
  end

  # Normaliza marca e modelo, por exemplo
  def normalize_data
    self.marca = marca&.titleize
    self.modelo = modelo&.titleize
  end

  # Exemplo de um método auxiliar
  def formatted_value
    return unless valor.present?

    valor.strip!
    valor.start_with?("R$") ? valor : "R$ #{valor}"
  end
end
