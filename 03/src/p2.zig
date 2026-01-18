const std = @import("std");
const common = @import("common");

pub fn top_jolts(input: []const u8) !u64 {
    var it = std.mem.splitScalar(u8, input, '\n');
    var total: u64 = 0;
    while (it.next()) |t| {
        const val = common.get_jolts(t, 12);
        total += val;
    }
    return total;
}
