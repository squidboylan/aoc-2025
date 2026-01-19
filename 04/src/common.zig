//! By convention, root.zig is the root source file when making a library.
const std = @import("std");

pub fn is_accessible(input: [][]u8, x: usize, y: usize) bool {
    if (input[y][x] != '@') {
        return false;
    }
    var nearby_rolls: u8 = 0;
    var y_mod: isize = -1;
    while (y_mod < 2) {
        defer y_mod += 1;
        var x_mod: isize = -1;
        while (x_mod < 2) {
            defer x_mod += 1;
            if (x_mod == 0 and y_mod == 0) {
                continue;
            }
            if (x_mod == -1 and x == 0) {
                continue;
            }
            if (y_mod == -1 and y == 0) {
                continue;
            }
            if (y_mod == 1 and y == input.len - 1) {
                continue;
            }
            if (x_mod == 1 and x == input[y].len - 1) {
                continue;
            }
            const y_isize: isize = @intCast(y);
            const x_isize: isize = @intCast(x);
            if (input[@intCast(y_isize + y_mod)][@intCast(x_isize + x_mod)] == '@') {
                nearby_rolls += 1;
            }
        }
    }

    return nearby_rolls < 4;
}
