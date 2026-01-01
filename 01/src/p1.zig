const std = @import("std");
const common = @import("common");

const Direction = enum { L, R };

pub fn get_pass(input: []const u8) !u64 {
    var z_count: u64 = 0;
    var dial: i64 = 50;
    var it = common.rot_iterator(input);
    while (it.next()) |t| {
        switch (t.direction) {
            .L => dial -= t.clicks,
            .R => dial += t.clicks,
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

