const std = @import("std");
const common = @import("common");

pub fn accessible_rolls(input: []const u8, allocator: std.mem.Allocator) !u64 {
    var arena: std.heap.ArenaAllocator = .init(allocator);
    defer arena.deinit();
    const arena_allocator = arena.allocator();
    const trimmed_input = std.mem.trim(u8, input, "\n");
    var it = std.mem.splitScalar(u8, trimmed_input, '\n');
    var grid: std.ArrayList([]u8) = .empty;
    var total: u64 = 0;
    while (it.next()) |t| {
        const owned_line = try arena_allocator.dupe(u8, t);
        try grid.append(arena_allocator, owned_line);
    }

    for (0..grid.items.len) |y| {
        for (0..grid.items[y].len) |x| {
            if (common.is_accessible(grid.items, x, y)) {
                total += 1;
            }
        }
    }
    return total;
}
