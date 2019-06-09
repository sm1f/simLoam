// CopyRight Stephen Morrisson 2017
// All rights reserved.


#include "common.h"
#include "SimObject.h"


int main(int argc, const char** argv)
{
  cout << "genApp V0.0" << endl;

  SimObject* root = new SimObject();
  
  int result = -1;
  //int result = that.RunMain();

  if (result != 0)
    {
      cout << endl << "returned: " << result << endl;
    }

  return result;
}
