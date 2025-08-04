module KVDB::STAND
  class Header
    SIZE = 24
    FORMAT = 'q<L<L<L<S<S<'

    HASH = 8
    TIMESTAMP = 4

    KEY_SIZE = 4
    VALUE_SIZE = 4

    KEY_TYPE = 2
    VALUE_TYPE = 2
    TYPES = {
      Integer: 1,
      String: 2,
      Float: 3
      # ...
    }.freeze

    # ...
  end
end
