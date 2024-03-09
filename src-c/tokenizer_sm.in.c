#include "tokenizer_sm.h"

// we disable the fill api and set the macro values
/*!re2c
  re2c:yyfill:enable = 0;
  re2c:define:YYCTYPE = char;
  re2c:define:YYCURSOR = cursor;
  re2c:define:YYMARKER = marker;
*/

TokenKind next_token(const char **tokenizer_cursor) {
  const char *cursor = *tokenizer_cursor;
  char *marker = (char*) cursor;
  TokenKind token = INVALID;

  for (;;) {
  /*!re2c

     // pattern definitions
     l_paren = "(";
     r_paren = ")";
     identifier = [a-zA-Z_/+-*]+;
     comment = [ ]*";"[^\n]*"\n";
     whitespace = [" "\n\r\t];

     // rule definitions
     l_paren { token = L_PAREN; break; }
     r_paren { token = R_PAREN; break; }
     identifier { token = IDENTIFIER; break;}
     comment { continue; }
     whitespace { continue; }
     * { token = EOF; break;}
   */
  }
  *tokenizer_cursor = cursor;
  return token;
}
