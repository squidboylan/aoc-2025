const std = @import("std");
const common = @import("common");

pub fn count_invalid(input: []const u8, allocator: std.mem.Allocator) !u64 {
    var invalid: u64 = 0;
    var it = common.input_iterator(input);
    while (it.next()) |t| {
        const first = std.fmt.parseUnsigned(u64, t.first, 10) catch {
            unreachable;
        };
        const last = std.fmt.parseUnsigned(u64, t.last, 10) catch {
            unreachable;
        };
        for (first..last + 1) |curr| {
            const curr_s = try std.fmt.allocPrint(allocator, "{d}", .{curr});
            defer allocator.free(curr_s);
            const end = curr_s.len / 2;
            outer: for (1..end + 1) |pat_end| {
                const pat = curr_s[0..pat_end];
                var pat_app_start: u64 = 0;
                var match = true;
                while (pat_app_start < curr_s.len and match == true) {
                    if (pat_app_start + pat.len > curr_s.len) {
                        match = false;
                        break;
                    }
                    if (!std.mem.eql(u8, pat, curr_s[pat_app_start .. pat_app_start + pat.len])) {
                        match = false;
                        break;
                    }
                    pat_app_start += pat_end;
                }
                if (match == true) {
                    invalid += curr;
                    break :outer;
                }
            }
        }
    }
    return invalid;
}
