module KIVI::Err

  class StatusError < StandardError

    def initialize(message)
      super('Cursor satus: ' + message)
    end

  end

end
