require "FileUtils"

module ActiveFile
  def save
    @new_record = false

    File.open("db/revistas/#{@id}.yml","w") do |file|
      file.puts serialize
    end
  end

  def destroy
    unless @destroyed or @new_record
      @destroyed = true
      FileUtils.rm "db/revistas/#{@id}.yml"
    end
  end

  module ClassMethods

    def find(id)
      raise DocumentNotFound,
      "Arquivo db/revistas/#{id} nao encontrado.", caller
      unless File.exists?("db/revistas/#{id}.yml")
        YAML.load File.open("db/revistas/#{id}.yml", "r")
      end
    end

    def next_id
      Dir.glob("db/revistas/*.yml").size + 1
    end

    def field(name)
      @fields ||= []
      @fields << name

      get = %Q{
        def #{name}
          @#{name}
          end
      }

      set = %Q{
        def #{name}=(valor)
          @#{name}=valor
          end
      }

      self.class_eval get
      self.class_eval set

    end

  end

  def self.included(base)
    base.extend ClassMethods
    base.class_eval do
      attr_reader :id, :destroyed, :new_record

      def initialize(parameters = {})
        @id = self.class.next_id
        @destroyed = false
        @new_record = true

        parameters.each do |key, value|
          instance_variable_set "@#{key}, value"
        end

      end
    end
  end

  private
  def serialize
    YAML.dump self
  end

end



