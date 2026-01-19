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
    const o1 = try p1.count_fresh(data, allocator);
    std.debug.print("p1 answer: {d}\n", .{o1});
    const o2 = try p2.count_fresh(data, allocator);
    std.debug.print("p2 answer: {d}\n", .{o2});
}

test "p1 test" {
    const input =
        \\3-5
        \\10-14
        \\16-20
        \\12-18
        \\
        \\1
        \\5
        \\8
        \\11
        \\17
        \\32
    ;
    const allocator = std.testing.allocator;
    const o = try p1.count_fresh(input, allocator);
    try expectEqual(3, o);
}

test "p2 test" {
    const input =
        \\3-5
        \\10-14
        \\16-20
        \\12-18
        \\
        \\1
        \\5
        \\8
        \\11
        \\17
        \\32
    ;
    const allocator = std.testing.allocator;
    const o = try p2.count_fresh(input, allocator);
    try expectEqual(14, o);
}
