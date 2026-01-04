const std = @import("std");
const p1 = @import("p1");
const p2 = @import("p2");
const expectEqual = std.testing.expectEqual;

pub fn main() !void {
    // Prints to stderr, ignoring potential errors.

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var file = try std.fs.cwd().openFile("input", .{ .mode = .read_only });
    defer file.close();

    const file_size = (try file.stat()).size;
    const data = try allocator.alloc(u8, file_size);
    defer allocator.free(data);

    _ = try std.fs.Dir.readFile(std.fs.cwd(), "input", data);
    std.debug.print("{d}\n", .{file_size});
    const o1 = try p1.get_pass(data);
    std.debug.print("p1 password: {d}\n", .{o1});
    const o2 = try p2.get_pass(data);
    std.debug.print("p2 password: {d}\n", .{o2});
}

test "p1 example input" {
    const input =
        \\L68
        \\L30
        \\R48
        \\L5
        \\R60
        \\L55
        \\L1
        \\L99
        \\R14
        \\L82
        ;
    const o = try p1.get_pass(input);
    try expectEqual(3, o);
}

test "p2 example input" {
    const input =
        \\L68
        \\L30
        \\R48
        \\L5
        \\R60
        \\L55
        \\L1
        \\L99
        \\R14
        \\L82
        ;
    const o = try p2.get_pass(input);
    try expectEqual(6, o);
}
