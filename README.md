# CS427-527

**************** To run black-white-bfs.pl ***********

$ swipl
?- ['adts.pl'].
% adts.pl compiled 0.00 sec, 36 clauses
true.

?- ['black-white-bfs.pl'].
%  adts compiled 0.00 sec, 1 clauses
% black-white-bfs.pl compiled 0.00 sec, 38 clauses
true.

?- go(state(b,b,b,e,w,w,w),state(w,w,w,A,B,C,D)).



**************** To run black-white-dfs.pl ************

$ swipl
?- ['adts.pl'].
% adts.pl compiled 0.00 sec, 36 clauses
true.

?- ['black-white-dfs.pl'].
%  adts compiled 0.00 sec, 1 clauses
% black-white-dfs.pl compiled 0.00 sec, 38 clauses
true.

?- go(state(b,b,b,e,w,w,w),state(w,w,w,A,B,C,D)).

**************** To run black-white-hfs.pl ************

$ swipl
?- ['adts.pl'].
% adts.pl compiled 0.00 sec, 36 clauses
true.

?- ['black-white-hfs.pl'].
?- go(state(b,b,b,e,w,w,w),state(w,w,w,b,b,b,e)).


**************** To run vamp-wolf-bfs.pl **************


$ swipl
?- ['adts.pl'].
% adts.pl compiled 0.00 sec, 36 clauses
true.

?- ['vamp-wolf-bfs.pl'].
?- go(state(e,e,e,e,e,e,e),state(w,w,w,w,w,w,w)).

**************** To run vamp-wolf-dfs.pl ***************

$ swipl
?- ['adts.pl'].
% adts.pl compiled 0.00 sec, 36 clauses
?- ['vamp-wolf-dfs.pl'].
?- go(state(e,e,e,e,e,e,e),state(w,w,w,w,w,w,w)).



