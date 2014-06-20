require "FileUtils"

class Revista
  attr_reader :titulo, :id
  attr_accessor :valor

  def initialize(titulo, valor)
    @titulo = titulo
    @valor = valor
    @id = self.class.next_id
    @destroyed = false
    @new_record = true
  end

  def save
    @new_record = false

    File.open("db/revistas/#{@id}.yml", "w") do |file|
      file.puts serialize
    end
  end

  def destroy
    unless @destroyed or @new_record
      @destroyed = true
      FileUtils.rm "db/revistas/#{id}.yml"
    end
  end

  def self.find(id)
    raise DocumentNotFound,
      "Arquivo db/revistas/#{id} não encontrado.",
    caller unless File.exists?("db/revistas/#{id}.yml")
    YAML.load File.open("db/revistas/#{id}.yml", "r")
  end


  private
  def serialize
    YAML.dump self
  end

  def self.next_id
    Dir.glob("db/revistas/*.yml").size + 1
  end

end
