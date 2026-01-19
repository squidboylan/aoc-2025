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
    var line_iterators = try std.ArrayList(std.mem.SplitIterator(u8, std.mem.DelimiterType.scalar)).initCapacity(arena_allocator, input.len / line_len);
    var signs: std.mem.SplitIterator(u8, std.mem.DelimiterType.scalar) = undefined;
    while (it.next()) |line| {
        _ = it.peek() orelse {
            signs = std.mem.splitScalar(u8, line, ' ');
            continue;
        };
        const trimmed_line = std.mem.trim(u8, line, " ");
        const split_line = std.mem.splitScalar(u8, trimmed_line, ' ');
        try line_iterators.append(arena_allocator, split_line);
    }

    var curr_col: std.ArrayList(u64) = .empty;
    while (line_iterators.items[0].peek()) |_| {
        for (0..line_iterators.items.len) |i| {
            // Consume the iterator to the next line
            var word = line_iterators.items[i].next().?;
            while (word.len == 0) {
                word = line_iterators.items[i].next().?;
            }
            const col_val = try std.fmt.parseUnsigned(u64, word, 10);
            try curr_col.append(arena_allocator, col_val);
        }
        const sign = common.get_next_sign(&signs);

        const line_total = common.apply_sign_to_slice(sign, curr_col.items);
        curr_col.clearRetainingCapacity();
        total += line_total;
    }
    return total;
}
