require 'bundle/setup'
require 'brnumeros'


module FormatadorMoeda

  # Módulo que guarda os métodos de classe
  module ClassMethods
    def formata_moeda(*variaveis_e_metodos)
      variaveis_e_metodos.each do |name|
        define_method("#{name}_formatado") do
          valor = respond_to?(name) ?
          send(name) :
          instance_variable_get("@#{name}")
          "R$ #{valor}"
        end

        define_method("#{name}_por_extenso") do
          valor = respond_to?(name) ? send(name)
          : instance_variable_get("@#{name}")
          valor.por_extenso_em_reais
        end
      end
    end
  end

  #hook method que é executado quando incluímos o módulo
  #dentro de alguma classe, recebendo no argumento
  #classe_que_incluiu_modulo o objeto %%Class%% que
  #representa a classe que incluiu o módulo
  def self.included(classe_que_incluiu_modulo)
    base.extend ClassMethods
  end


end
