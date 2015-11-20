All code can be run with SWI-Prolog.

All search algorithm code was taken from George Luger’s web site.

All code depends on adts.pl which was also taken from George Luger’s web site.

To run the code:


%swipl
?- [‘black-white-dfs.pl’].

?- go(state(b,b,b,e,w,w,w), state(w,w,w,b,b,b,e)).

%swipl
?- [‘black-white-bfs.pl’].

?- go(state(b,b,b,e,w,w,w), state(w,w,w,b,b,b,e)).

%swipl
?- [‘black-white-hfs.pl’].

?- go(state(b,b,b,e,w,w,w), state(w,w,w,b,b,b,e)).

swipl
?- [‘vamp-wolf-dfs.pl’].

?- go([3,3,left,0,0],[0,0,right,3,3]).

swipl
?- [‘vamp-wolf-bfs.pl’].

?- go([3,3,left,0,0],[0,0,right,3,3]).

swipl
?- [‘vamp-wolf-hfs.pl’].

?- go([3,3,left,0,0],[0,0,right,3,3]).