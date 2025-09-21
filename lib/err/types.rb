module KIVI::Err

  class TypesError < StandardError

    def initialize(message)
      super('Storage datatypes issues: ' + message)
    end

  end

end
