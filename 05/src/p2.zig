const std = @import("std");
const common = @import("common");

pub fn count_fresh(input: []const u8, allocator: std.mem.Allocator) !u64 {
    var fresh: u64 = 0;
    var arena: std.heap.ArenaAllocator = .init(allocator);
    defer arena.deinit();
    const arena_allocator = arena.allocator();
    const trimmed_input = std.mem.trim(u8, input, "\n");
    var it = std.mem.splitSequence(u8, trimmed_input, "\n\n");
    // Allocate a large arraylist, virtualmemory helps us here
    var range_list: std.ArrayList(common.Range) = try std.ArrayList(common.Range).initCapacity(arena_allocator, input.len / 2);

    const ranges_block = it.next().?;

    var ranges = std.mem.splitScalar(u8, ranges_block, '\n');
    while (ranges.next()) |range| {
        var range_struct = try common.range_from_slice(range);

        var i: u64 = 0;
        while (i < range_list.items.len) {
            if (range_list.items[i].combine_with_range(range_struct)) {
                range_struct = range_list.orderedRemove(i);
            } else {
                i += 1;
            }
        }
        try range_list.append(arena_allocator, range_struct);
    }

    for (range_list.items) |range| {
        fresh += range.end - range.beg + 1;
    }
    return fresh;
}
