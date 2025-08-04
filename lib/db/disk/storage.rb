module KVDB::Disk
  # Used in cursor
  # Get indexs from key value database file
  class Storage
    def initialize(file_path, actions)
      @file = File.open(file_path, 'a+b')
      @actions = actions
      @position_in_file = 0
      @positions_map = init_positions
    end

    # def get_row()
    # end

    # def put_row()
    # end

    def init_positions; end
  end
end
