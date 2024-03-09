const std = @import("std");
const tokenizer_mod = @import("tokenizer/tokenizer.zig");
const tokenizer_sm_mod = tokenizer_mod.tok_sm_mod;
const Tokenizer = tokenizer_mod.Tokenizer;
const Token = tokenizer_mod.Token;
const TokenKind = tokenizer_mod.tok_sm_mod.TokenKind;

pub fn main() !void {
    std.debug.print("hello world?\n", .{});
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    const input: [:0]const u8 = "(add one two)";

    var tokenizer: Tokenizer = Tokenizer.new(input);

    try stdout.print("input: {s}\n", .{input});
    try bw.flush();

    var i: u32 = 8;
    while (i > 0) {
        if (tokenizer.next_token()) |token| {
            try stdout.print("{any}\n", .{token}); // uses the format method on the token
        } else {
            try stdout.print("no fukn tokens!\n", .{});
        }
        try bw.flush();
        i -= 1;
    }
}

test "tokenizer" {
    const input = "(add one two)";
    var tokenizer: Tokenizer = Tokenizer.new(input);

    var token = tokenizer.next_token();
    var expected: Token = .{ .kind = tokenizer_sm_mod.L_PAREN, .location = .{ .start = 0, .end = 0 } };

    try std.testing.expectEqual(expected, token);

    token = tokenizer.next_token();
    expected = .{ .kind = tokenizer_sm_mod.IDENTIFIER, .location = .{ .start = 0, .end = 0 } };

    try std.testing.expectEqual(expected, token);
}
