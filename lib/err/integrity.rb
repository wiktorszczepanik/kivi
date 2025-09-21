module KIVI::Err

  class CorruptionError < StandardError

    def initialize(message)
      super('File data corruption: ' + message)
    end

  end

end
