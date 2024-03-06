#ifndef TOKENIZER_GUARD
#define TOKENIZER_GUARD

#include <stdio.h>

typedef enum TokenKind {
  invalid,
  identifier,
  l_paren,
  r_paren,
} TokenKind;

typedef struct Location {
  
} Location;

typedef struct Token {
  TokenKind kind;
  Location location;
} Token;

typedef struct Tokenizer {
  const char* input;
  char *top, *cur, *ptr, *pos;
} Tokenizer;

const char* lexeme(TokenKind kind) {
  switch (kind) {
    case invalid:
    case identifier:
      return NULL;
    case l_paren:
      return "(";
    case r_paren:
      return ")";
  }
}

// inits a Tokenizer struct, at the provided memory
// location
void init_tokenizer(Tokenizer *t, char* input) {
  t->input = input;
  t->top = input;
  t->cur = input;
  t->pos = input;
}

Token next_token(Tokenizer *t);

#endif
