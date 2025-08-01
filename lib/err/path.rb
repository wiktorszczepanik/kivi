module KVDB::Err

  class PathError < StandardError

    def initialize(message)
      super('Cursor path issues: ' + message)
    end

  end

end
