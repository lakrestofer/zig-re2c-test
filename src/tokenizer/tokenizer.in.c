#include "tokenizer.h"

#define YYCTYPE unsigned char
#define YYCURSOR t->cur
#define YYMARKER t->ptr

/*!re2c:settings

// disables bounds checks and the call to YYFILL
// this means that the entire intup will be read in at once
// https://re2c.org/manual/manual_c.html#handling-the-end-of-input
re2c:yyfill:enable = 0;

*/

/*!re2c:definitions
*/
