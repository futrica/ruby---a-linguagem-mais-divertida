class Biblioteca
  include Enumerable

  attr_reader :livros
  def initialize
    @banco_de_arquivos = BancoDeArquivos.new
  end

  def adiciona(midia)
    salva midia do
      midias << midia
    end if midia.kind_of? Midia
  end

  def midias
    @midias ||= @banco_de_arquivos.carrega
  end

  def midias_por_categoria(categoria)
    midias.select { |midia| midia.categoria == categoria }
  end

  def each
    midias.each { |midia|  yield midia}

  end
  private

  def salva(livro)
    @banco_de_arquivos.salva livro
    yield
  end

end
