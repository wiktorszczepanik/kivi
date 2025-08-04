module KVDB::STAND
  class Header
    SIZE = 24
    FORMAT = 'q<L<L<L<S<S<'
    TYPES = {
      Integer: 1,
      String: 2,
      Float: 3
    }.freeze
    # ...
  end
end
