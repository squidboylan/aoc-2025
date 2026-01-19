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
    var grid = try std.ArrayList(std.ArrayList(u64)).initCapacity(arena_allocator, input.len / line_len);
    var signs: std.mem.SplitIterator(u8, std.mem.DelimiterType.scalar) = undefined;
    while (it.next()) |line| {
        const trimmed_line = std.mem.trim(u8, line, " ");
        var split_line = std.mem.splitScalar(u8, trimmed_line, ' ');
        var number = true;
        _ = std.fmt.parseUnsigned(u64, split_line.peek().?, 10) catch {
            number = false;
        };
        if (number) {
            try grid.append(arena_allocator, .empty);
            while (split_line.next()) |word| {
                // skip empty split elements
                if (word.len == 0) {
                    continue;
                }
                const val = try std.fmt.parseUnsigned(u64, word, 10);
                try grid.items[grid.items.len - 1].append(arena_allocator, val);
            }
        } else {
            signs = split_line;
        }
    }
    for (0..grid.items[0].items.len) |x| {
        var sign = signs.next().?;
        while (sign.len == 0) {
            sign = signs.next().?;
        }

        var line_total = grid.items[0].items[x];

        for (1..grid.items.len) |y| {
            if (std.mem.eql(u8, sign, "*")) {
                line_total *= grid.items[y].items[x];
            } else if (std.mem.eql(u8, sign, "+")) {
                line_total += grid.items[y].items[x];
            } else {
                unreachable;
            }
        }
        total += line_total;
    }
    return total;
}
