module KVDB::Err

  class FlagsError < StandardError

    def initialize(message)
      super('Cursor flags issues: ' + message)
    end

  end

end
