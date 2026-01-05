//! By convention, root.zig is the root source file when making a library.
const std = @import("std");

const SplitString = std.mem.SplitIterator(u8, std.mem.DelimiterType.scalar);

pub fn input_iterator(input: []const u8) InputIterator {
    const it = std.mem.splitScalar(u8, input, ',');
    return InputIterator{ .it = it };
}

const Range = struct {
    first: []const u8,
    last: []const u8,
};

const InputIterator = struct {
    it: SplitString,
    pub fn next(self: *InputIterator) ?Range {
        const x = self.it.next() orelse return null;
        var t = std.mem.splitScalar(u8, x, '-');
        const first = t.next() orelse unreachable;
        const last = t.next() orelse unreachable;
        return Range{
            .first = first,
            .last = last,
        };
    }
};
