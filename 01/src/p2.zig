const std = @import("std");
const common = @import("common");

const Direction = enum { L, R };

pub fn get_pass(input: []const u8) !u64 {
    var z_count: u64 = 0;
    var dial: i64 = 50;
    var it = common.rot_iterator(input);
    while (it.next()) |t| {
        const old_dial = dial;
        switch (t.direction) {
            .L => dial -= t.clicks,
            .R => dial += t.clicks,
        }
        if (dial == 0) {
            z_count += 1;
        }
        const loops = @divTrunc(dial, 100);
        if (dial < 0) {
            dial += 100;
            if (old_dial != 0) {
                z_count += 1;
            }
        }
        dial = @mod(dial, 100);
        z_count += @as(u64, @abs(loops));
    }
    return z_count;
}

