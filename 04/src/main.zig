const std = @import("std");
const p1 = @import("p1");
const p2 = @import("p2");
const expectEqual = std.testing.expectEqual;

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    var file = try std.fs.cwd().openFile("input", .{ .mode = .read_only });
    defer file.close();

    const file_size = (try file.stat()).size;
    const data: []u8 = try allocator.alloc(u8, file_size);
    defer allocator.free(data);

    _ = try std.fs.Dir.readFile(std.fs.cwd(), "input", data);
    const o1 = try p1.accessible_rolls(data, allocator);
    std.debug.print("p1 answer: {d}\n", .{o1});
    const o2 = try p2.accessible_rolls(data, allocator);
    std.debug.print("p2 answer: {d}\n", .{o2});
}

test "p1 test" {
    const input =
        \\..@@.@@@@.
        \\@@@.@.@.@@
        \\@@@@@.@.@@
        \\@.@@@@..@.
        \\@@.@@@@.@@
        \\.@@@@@@@.@
        \\.@.@.@.@@@
        \\@.@@@.@@@@
        \\.@@@@@@@@.
        \\@.@.@@@.@.
    ;
    const allocator = std.testing.allocator;
    const o = try p1.accessible_rolls(input, allocator);
    try expectEqual(13, o);
}

test "p2 test" {
    const input =
        \\..@@.@@@@.
        \\@@@.@.@.@@
        \\@@@@@.@.@@
        \\@.@@@@..@.
        \\@@.@@@@.@@
        \\.@@@@@@@.@
        \\.@.@.@.@@@
        \\@.@@@.@@@@
        \\.@@@@@@@@.
        \\@.@.@@@.@.
    ;
    const allocator = std.testing.allocator;
    const o = try p2.accessible_rolls(input, allocator);
    try expectEqual(43, o);
}
