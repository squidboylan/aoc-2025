const std = @import("std");
const p1 = @import("p1");
const p2 = @import("p2");
const expect = std.testing.expect;

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
    const o = try p1.get_pass(data);
    std.debug.print("p1 password: {d}\n", .{o});
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
    try expect(o == 3);
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
    try expect(o == 3);
}
