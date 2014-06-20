class Midia
  attr_accessor :valor, :titulo

  def formata_moeda(*variaveis_e_metodos)
    variaveis_e_metodos.each do |name|
      define_method("#{name}_formatado") do
        valor = respond_to?(name) ? send(name) : instance_variable_get("@#{name}")
        "R$ #{valor}"
      end
    end
  end

  def initialize
    @desconto = 0.1
    @valor = 10.0
  end

  def valor_com_desconto
    @valor - (@valor * @desconto)
  end
end
