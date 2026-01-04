const std = @import("std");

const Direction = enum { L, R };

const SplitString = std.mem.SplitIterator(u8, std.mem.DelimiterType.scalar);

pub fn rot_iterator(input: []const u8) RotationIterator {
    const it = std.mem.splitScalar(u8, input, '\n');
    return RotationIterator {
        .it = it
    };
}

const Rotation = struct {
    direction: Direction,
    clicks: i64,
};

const RotationIterator = struct {
    it: SplitString,
    pub fn next(self: *RotationIterator) ?Rotation {
        const x = self.it.next() orelse return null;
        var d = Direction.L;
        if (x.len == 0) {
            return null;
        }
        if (x[0] == 'L') {
            d = Direction.L;
        } else if (x[0] == 'R') {
            d = Direction.R;
        } else {
            std.debug.print("{s}\n", .{x});
            unreachable;
        }
        const clicks = std.fmt.parseUnsigned(i64, x[1..], 10) catch { unreachable; };
        return Rotation{
            .direction = d,
            .clicks = clicks,
        };
    }
};
