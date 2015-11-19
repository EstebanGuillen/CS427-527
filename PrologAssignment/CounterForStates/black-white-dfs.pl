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


move([ [X|T],Z ],[ T,[X|Z] ]) :-
writelist(['Move X Right',[ [X|T],[Z] ],[ [T],[X|Z] ] ]).



%move([ [X,Y|T],Z ],[ [X|T],[Y|Z] ]) :-
%writelist(['Move Y Right',[ [X,Y|T],Z ],[ [X|T],[Y|Z] ]]).




%move([ [X,Y,W|T],Z ],[ [X,Y|T],[W|Z] ]) :-
%writelist(['Move W Right',[ [X,Y,W|T],Z ],[ [X,Y|T],[W|Z] ]]).



%move([ Z,[X|T] ],[ [X|Z],T ]) :-
%writelist(['Move X Left',[ Z,[X|T] ],[ [X|Z],T ] ]).


%move([ [X,Y|T],Z ],[ [X|T],[Y|Z] ]) :-

%writelist(['Move Y Left',[ [X,Y|T],Z ],[ [X|T],[Y|Z] ]]).

%move([ [X,Y,W|T],Z ],[ [X,Y|T],[W|Z] ]) :-
%writelist(['Move W Left',[ [X,Y,W|T],Z ],[ [X,Y|T],[W|Z] ]]).




move([ X,Z ],[ X,Z ])
:- writelist(['      BACKTRACK from:',[ X,Z ],[ X,Z ]]), fail.





/*
* Definitions of writelist, and opp.
*/

writelist([]) :- nl.
writelist([H|T]):- print(H), tab(1),  /* "tab(n)" skips n spaces. */
writelist(T).








