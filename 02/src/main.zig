const std = @import("std");
const p1 = @import("p1");
const expectEqual = std.testing.expectEqual;

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    var file = try std.fs.cwd().openFile("input", .{ .mode = .read_only });
    defer file.close();

    const file_size = (try file.stat()).size;
    const data = try allocator.alloc(u8, file_size);
    defer allocator.free(data);

    _ = try std.fs.Dir.readFile(std.fs.cwd(), "input", data);
    const o1 = try p1.count_invalid(data, allocator);
    std.debug.print("p1 answer: {d}\n", .{o1});
}

test "simple test" {
    const input = "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124";
    const allocator = std.heap.page_allocator;
    const o = try p1.count_invalid(input, allocator);
    try expectEqual(1227775554, o);
}
