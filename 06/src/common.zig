//! By convention, root.zig is the root source file when making a library.
const std = @import("std");

pub fn get_next_sign(signs: *std.mem.SplitIterator(u8, std.mem.DelimiterType.scalar)) []const u8 {
    var sign = signs.next().?;
    while (sign.len == 0) {
        sign = signs.next().?;
    }
    return sign;
}

pub fn apply_sign_to_slice(sign: []const u8, vals: []const u64) u64 {
    var line_total = vals[0];

    for (1..vals.len) |y| {
        if (std.mem.eql(u8, sign, "*")) {
            line_total *= vals[y];
        } else if (std.mem.eql(u8, sign, "+")) {
            line_total += vals[y];
        } else {
            unreachable;
        }
    }
    return line_total;
}
