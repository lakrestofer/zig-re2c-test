const std = @import("std");

pub const Token = struct {
    kind: TokenKind,
    location: Location,

    // The location of a given
    pub const Location = struct {
        start: usize,
        end: usize,
    };

    pub const TokenKind = enum {
        invalid,
        identifier,
        l_paren,
        r_paren,
    };
};
