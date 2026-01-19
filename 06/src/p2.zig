const std = @import("std");
const common = @import("common");

pub fn do_math(input: []const u8, allocator: std.mem.Allocator) !u64 {
    var total: u64 = 0;
    var arena: std.heap.ArenaAllocator = .init(allocator);
    defer arena.deinit();
    const arena_allocator = arena.allocator();
    const trimmed_input = std.mem.trim(u8, input, "\n");
    var it = std.mem.splitScalar(u8, trimmed_input, '\n');
    const line_len = it.peek().?.len;
    var char_grid = try std.ArrayList([]const u8).initCapacity(arena_allocator, input.len / line_len);
    var signs: std.mem.SplitIterator(u8, std.mem.DelimiterType.scalar) = undefined;
    while (it.next()) |line| {
        _ = it.peek() orelse {
            signs = std.mem.splitScalar(u8, line, ' ');
            continue;
        };
        try char_grid.append(arena_allocator, line);
    }
    var curr_col = try std.ArrayList(u64).initCapacity(arena_allocator, char_grid.items.len);
    var x: usize = 0;
    while (x < char_grid.items[0].len) {
        const group_start = x;
        while (true) {
            var empty_col = true;
            for (0..char_grid.items.len) |y| {
                if (char_grid.items[y][x] != ' ') {
                    const col_val = try std.fmt.parseUnsigned(u64, char_grid.items[y][x .. x + 1], 10);
                    if (curr_col.items.len <= x - group_start) {
                        try curr_col.append(arena_allocator, col_val);
                    } else {
                        curr_col.items[x - group_start] *= 10;
                        curr_col.items[x - group_start] += col_val;
                    }
                    empty_col = false;
                }
            }
            x += 1;
            if (empty_col or x >= char_grid.items[0].len) {
                break;
            }
        }

        var sign = signs.next().?;
        while (sign.len == 0) {
            sign = signs.next().?;
        }
        var line_total = curr_col.items[0];

        for (1..curr_col.items.len) |i| {
            if (std.mem.eql(u8, sign, "*")) {
                line_total *= curr_col.items[i];
            } else if (std.mem.eql(u8, sign, "+")) {
                line_total += curr_col.items[i];
            } else {
                unreachable;
            }
        }
        curr_col.clearRetainingCapacity();
        total += line_total;
    }
    return total;
}
