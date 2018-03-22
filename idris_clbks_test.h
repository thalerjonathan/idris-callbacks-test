#ifndef __GL_IDRISCLBKS_TEST_H
#define __GL_IDRISCLBKS_TEST_H

#include <idris_rts.h>

typedef void (*TestCallback) (int);

void registerCallback(TestCallback clbk);

void runCallback();

#endif // __GL_IDRISCLBKS_TEST_H