//! By convention, root.zig is the root source file when making a library.
const std = @import("std");

pub fn range_from_slice(in: []const u8) !Range {
    var it = std.mem.splitScalar(u8, in, '-');
    const beg: u64 = try std.fmt.parseUnsigned(u64, it.next().?, 10);
    const end: u64 = try std.fmt.parseUnsigned(u64, it.next().?, 10);
    return Range{
        .beg = beg,
        .end = end,
    };
}
pub const Range = struct {
    beg: u64,
    end: u64,
    pub fn contains(self: *const Range, in: u64) bool {
        if (in >= self.beg and in <= self.end) {
            return true;
        } else {
            return false;
        }
    }
    // Updates self with the input range if possible, returns true if possible else false
    // There is likely a better way to do this
    pub fn combine_with_range(self: *Range, in: Range) bool {
        // self fully contains in
        if (self.beg <= in.beg and self.end >= in.end) {
            return true;
        }
        // in fully contains self
        if (in.beg <= self.beg and in.end >= self.end) {
            self.beg = in.beg;
            self.end = in.end;
            return true;
        }
        // self starts before in begins and ends after in begins
        if (self.beg <= in.beg and self.end >= in.beg and self.end <= in.end) {
            self.end = in.end;
            return true;
        }
        // self starts before in ends and ends after in ends
        if (self.beg >= in.beg and self.beg <= in.end and self.end >= in.end) {
            self.beg = in.beg;
            return true;
        }
        return false;
    }
};
