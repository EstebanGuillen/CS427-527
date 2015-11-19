%%%
%%% This is one of the example programs from the textbook:
%%%
%%% Artificial Intelligence:
%%% Structures and strategies for complex problem solving
%%%
%%% by George F. Luger and William A. Stubblefield
%%%
%%% These programs are copyrighted by Benjamin/Cummings Publishers.
%%%
%%% We offer them for use, free of charge, for educational purposes only.
%%%
%%% Disclaimer: These programs are provided with no warranty whatsoever as to
%%% their correctness, reliability, or any other property.  We have written
%%% them for specific educational purposes, and have made no effort
%%% to produce commercial quality computer programs.  Please do not expect
%%% more of them then we have intended.
%%%
%%% This code has been tested with SWI-Prolog (Multi-threaded, Version 5.2.13)
%%% and appears to function as intended.

/*
* This is the code for the Farmer, Wolf, Goat and Cabbage Problem
* using the ADT Stack.
*
* Run this code by giving PROLOG a "go" goal.
* For example, to find a path from the west bank to the east bank,
* give PROLOG the query:
*
*   go(state(w,w,w,w,w,w,w), state(e,e,e,e,e,e,e)).
*/

:- [adts]. /* consults (reconsults) file containing the various ADTs (Stack, Queue, etc.) */



go(Start, Goal) :-
empty_stack(Empty_been_list),
stack(Start, Empty_been_list, Been_list),
path(Start, Goal, Been_list).

% path implements a depth first search in PROLOG

% Current state = goal, print out been list
path(Goal, Goal, Been_list) :- write('\nSolution path is: '), nl,
reverse_print_stack(Been_list).

path(State, Goal, Been_list) :-
move(State, Next),
%not(unsafe(Next)),
not(member_stack(Next, Been_list)),
stack(Next, Been_list, New_been_list),
path(Next, Goal, New_been_list), !.

reverse_print_stack(S) :-
empty_stack(S).
reverse_print_stack(S) :-
stack(E, Rest, S),
reverse_print_stack(Rest),
write(E), nl.



% Possible moves:


%movig right rules
/*
move([ [X,Y,W|T],Z ],[ [T],[Y,W,X|Z] ]) :-
writelist(['Move ', X , ' Right Jump 2',[ [X,Y,W|T],Z ],[ [T],[Y,W,X|Z] ]]).

move([ [X,Y|T],Z ],[ [T],[Y,X|Z] ]) :-
writelist(['Move ', X , ' Right Jump 1',[ [X,Y|T],Z ],[ [T],[Y,X|Z] ]]).


move([ [X|T],Z ],[ T,[X|Z] ]) :- length(T,1),
writelist(['Move ', X, ' Right Jump 1',[ [X|T],[Z] ],[ [T],[X|Z] ] ]).


move([ [X|T],Z ],[ T,[X|Z] ]) :- length(T,0),
writelist(['Move ', X, ' Right Jump 0',[ [X|T],[Z] ],[ [T],[X|Z] ] ]).



move([ [X,Y|T],Z ],[ [X|T],[Y|Z] ]) :- length(T,2),
writelist(['Move ', Y , ' Right Jump 2',[ [X,Y|T],Z ],[ [X|T],[Y|Z] ]]).

move([ [X,Y|T],Z ],[ [X|T],[Y|Z] ]) :- length(T,1),
writelist(['Move ', Y, ' Right Jump 1',[ [X,Y|T],Z ],[ [X|T],[Y|Z] ]]).

move([ [X,Y|T],Z ],[ [X|T],[Y|Z] ]) :- length(T,0),
writelist(['Move ', Y, ' Right Jump 0',[ [X,Y|T],Z ],[ [X|T],[Y|Z] ]]).


move([ [X,Y,W|T],Z ],[ [X,Y|T],[W|Z] ]) :- length(T,2),
writelist(['Move ', W , ' Jump 2',[ [X,Y,W|T],Z ],[ [X,Y|T],[W|Z] ]]).

move([ [X,Y,W|T],Z ],[ [X,Y|T],[W|Z] ]) :- length(T,1),
writelist(['Move ', W , ' Jump 1',[ [X,Y,W|T],Z ],[ [X,Y|T],[W|Z] ]]).

move([ [X,Y,W|T],Z ],[ [X,Y|T],[W|Z] ]) :- length(T,0),
writelist(['Move ', W, ' Jump 0',[ [X,Y,W|T],Z ],[ [X,Y|T],[W|Z] ]]).
*/





%moving left rules
move([ X,[Y|Z] ],[ New,Z ]) :- append(X,[Y],New),
writelist(['Move ', Y , ' Left Jump 0', [ X,[Y|Z] ],[ New,Z ]]).

move([ X,[Y,W|Z] ],[ New,Z ]) :- append(X,[W,Y],New),
writelist(['Move ', W , ' Left Jump 1', [ X,[Y,W|Z] ],[ New,Z ]]).

move([ X,[Y,W,U|Z] ],[ New,Z ]) :- append(X,[U,Y,W],New),
writelist(['Move ', U , ' Left Jump 2', [ X,[Y,W,U|Z] ],[ New,Z ]]).





move([ X|Z ],[ X|Z ])
:- writelist(['      BACKTRACK from:',[ X|Z ],[ X|Z ]]), fail.





/*
* Definitions of writelist, and opp.
*/

writelist([]) :- nl.
writelist([H|T]):- print(H), tab(1),  /* "tab(n)" skips n spaces. */
writelist(T).








