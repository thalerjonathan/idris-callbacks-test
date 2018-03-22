#include "idris_clbks_test.h"

static TestCallback clbk = 0;

void
registerCallback(TestCallback c)
{
  clbk = c;
}

void
runCallback()
{
  if (clbk)
  {
    clbk(42);
  }
}