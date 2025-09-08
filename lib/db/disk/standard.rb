module KVDB::STAND

  class Header

    SIZE = 24
    FORMAT = 'q<L<L<L<S<S<'.freeze

    HASH = 8 # 0 -> q
    TIMESTAMP = 4 # 1 -> <L

    KEY_SIZE = 4 # 2 -> <L
    VALUE_SIZE = 4 # 3 -> <L

    KEY_TYPE = 2 # 4 -> <S
    VALUE_TYPE = 2 # 5 -> <S

    TYPE = {
      Integer: 1,
      Float: 2,
      String: 3
      # ...
    }.freeze

    TYPE_LOOKUP = {
      1 => :Integer,
      2 => :Float,
      3 => :String
      # ...
    }.freeze

    DIRECTIVE = {
      1 => 'q<',
      2 => 'E'
    }
    # ...
  end

end
