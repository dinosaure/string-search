#include <iostream>
#include <iomanip>
#include <algorithm>
#include <string>
#include <vector>
#include <list>

using namespace std;

vector<string>
bwt(string str)
{
  vector<string>  r;
  int             i;

  i = 0;

  while (i < str.size())
    {
      r.push_back(str);
      rotate(str.begin(), str.begin() + 1, str.end());
      i = i + 1;
    }

  return (r);
}

list<int>
fsearch(vector<string> array, char c)
{
  vector<string>::iterator  it;
  list<int>                 re;

  for (it = array.begin(); it != array.end(); it++)
    if ((*it)[0] == c)
      re.push_front(it - array.begin());

  return (re);
}

list<int>
lsearch(vector<string> array, list<int> l, char c)
{
  list<int>::iterator       it;
  list<int>                 re;
  int                       id;
  vector<string>::iterator  bt;

  for (it = l.begin(); it != l.end(); it++)
    {
      id = ((*it) + 1 == array.size()) ? 0 : (*it) + 1;

      if (array[id][0] == c)
        re.push_front(id);
    }

  return (re);
}

list<int>
search(vector<string> array, string s)
{
  string::iterator  it;
  list<int>         re;

  it = s.begin();

  do
    re = (it - s.begin() == 0) ? fsearch(array, (*it)) : lsearch(array, re, (*it));
  while (++it != s.end() && re.empty() == false);

  return (re);
}

void
display(list<int> l, string s)
{
  list<int>::iterator it;

  for (it = l.begin(); it != l.end(); it++)
    {
      cout << s << endl;
      cout << setw(s.size() - (*it)) << "^" << endl;
    }
}

int
main(int ac, const char **av)
{
  if (ac == 3)
    display(search(bwt(av[1]), av[2]), av[1]);
  else
    cout << av[0] << " string template" << endl;

  return (0);
}
