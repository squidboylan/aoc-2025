const std = @import("std");
const common = @import("common");

pub fn count_fresh(input: []const u8, allocator: std.mem.Allocator) !u64 {
    var fresh: u64 = 0;
    var arena: std.heap.ArenaAllocator = .init(allocator);
    defer arena.deinit();
    const arena_allocator = arena.allocator();
    const trimmed_input = std.mem.trim(u8, input, "\n");
    var it = std.mem.splitSequence(u8, trimmed_input, "\n\n");
    var range_list: std.ArrayList(common.Range) = .empty;
    const ranges_block = it.next().?;
    const ingredients_block = it.next().?;

    var ranges = std.mem.splitScalar(u8, ranges_block, '\n');
    while (ranges.next()) |range| {
        const range_struct = try common.range_from_slice(range);
        try range_list.append(arena_allocator, range_struct);
    }

    var ingredients = std.mem.splitScalar(u8, ingredients_block, '\n');
    while (ingredients.next()) |ingredient| {
        const ing_u64 = try std.fmt.parseUnsigned(u64, ingredient, 10);
        var found: bool = false;
        for (range_list.items) |range| {
            if (range.contains(ing_u64)) {
                found = true;
                break;
            }
        }
        if (found) {
            fresh += 1;
        }
    }
    return fresh;
}
