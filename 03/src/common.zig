//! By convention, root.zig is the root source file when making a library.
const std = @import("std");

pub fn get_jolts(input: []const u8, comptime len: usize) u64 {
    var digits = [_]u8{0} ** len;
    var val = calculate_val(&digits);
    if (input.len == 0) {
        return val;
    }
    // Skip an ending newline
    for (0..input.len) |i| {
        const curr = input[i];
        // Convert from ascii to u8 value
        const curr_int = curr - 48;

        var curr_digit: usize = 0;
        if (input.len - i < digits.len) {
            curr_digit = digits.len - (input.len - i);
        }

        // Loop over our digits, replacing the first one that is worse than what we're holding
        while (curr_digit < digits.len) {
            if (curr_int > digits[curr_digit]) {
                digits[curr_digit] = curr_int;
                curr_digit += 1;
                zero_digits(digits[curr_digit..digits.len]);
                break;
            }
            curr_digit += 1;
        }

        val = calculate_val(&digits);
    }

    return val;
}

pub fn calculate_val(digits: []u8) u64 {
    var val: u64 = 0;
    var mul: u64 = 1;
    var i: usize = digits.len - 1;
    while (i > 0) {
        val += digits[i] * mul;
        i -= 1;
        mul *= 10;
    }
    // Catch the most significant digit
    val += digits[i] * mul;
    return val;
}

pub fn zero_digits(digits: []u8) void {
    for (digits) |*i| {
        i.* = 0;
    }
}
