const std = @import("std");

const Direction = enum { L, R };

pub fn get_pass(input: []const u8) !u64 {
    var z_count: u64 = 0;
    var dial: i64 = 50;
    var it = std.mem.splitAny(u8, input, "\n");
    var d: Direction = .L;
    while (it.next()) |x| {
        if (x.len == 0) {
            continue;
        }
        if (x[0] == 'L') {
            d = Direction.L;
        } else if (x[0] == 'R') {
            d = Direction.R;
        } else {
            std.debug.print("{s}\n", .{x});
            unreachable;
        }
        var clicks = try std.fmt.parseUnsigned(i64, x[1..], 10);
        clicks = @mod(clicks, 100);
        switch (d) {
            .L => dial -= clicks,
            .R => dial += clicks,
        }
        if (dial < 0) {
            dial = dial + 100;
        }
        dial = @mod(dial, 100);
        if (dial == 0) {
            z_count += 1;
        }
    }
    return z_count;
}

