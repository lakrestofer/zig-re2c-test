const std = @import("std");

pub const tok_sm_mod = @cImport(@cInclude("tokenizer_sm.h"));

pub const TokenKind = tok_sm_mod.TokenKind;

pub const Token = struct {
    kind: TokenKind,
    location: Location,

    const Self = @This();

    pub const Location = struct { start: usize, end: usize };

    pub fn lexeme(kind: TokenKind) ?[]const u8 {
        return switch (kind) {
            tok_sm_mod.INVALID, tok_sm_mod.EOF, tok_sm_mod.IDENTIFER => null,
            tok_sm_mod.L_PAREN => "(",
            tok_sm_mod.R_PAREN => ")",
            else => unreachable,
        };
    }

    pub fn format_tokenkind(kind: TokenKind) [:0]const u8 {
        return switch (kind) {
            tok_sm_mod.INVALID => "INVALID",
            tok_sm_mod.EOF => "EOF",
            tok_sm_mod.IDENTIFIER => "IDENTIFIER",
            tok_sm_mod.L_PAREN => "L_PAREN",
            tok_sm_mod.R_PAREN => "R_PAREN",
            else => unreachable,
        };
    }

    pub fn format(
        self: Self,
        comptime fmt: []const u8,
        options: std.fmt.FormatOptions,
        writer: anytype,
    ) !void {
        _ = fmt;
        _ = options;

        const kind = format_tokenkind(self.kind);
        try writer.print("Token: kind = {s}", .{kind});
    }
};

pub const Tokenizer = struct {
    buffer: [:0]const u8,
    cursor: *const u8,
    position: usize = 0,
    eof_reached: bool = false,

    const Self = @This();

    // return a new instance of the buffer
    pub fn new(buffer: [:0]const u8) Self {
        return Self{ .buffer = buffer, .cursor = &buffer[0] };
    }

    pub fn next_token(self: *Self) ?Token {
        if (self.eof_reached) return null;

        var token_kind: TokenKind = tok_sm_mod.INVALID;

        // we then call the C lexing routine that will modify the cursor
        token_kind = tok_sm_mod.next_token(@ptrCast(&self.cursor));

        if (token_kind == tok_sm_mod.EOF) {
            self.eof_reached = true;
        }

        return Token{ .kind = token_kind, .location = .{ .start = 0, .end = 0 } };
    }
};
