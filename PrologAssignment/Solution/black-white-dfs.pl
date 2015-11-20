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

:- [adts]. /* consults (reconsults) file containing the various ADTs (Stack, Queue, etc.) */



go(Start, Goal) :-
empty_stack(Empty_been_list),
stack(Start, Empty_been_list, Been_list),
path(Start, Goal, Been_list).

% path implements a depth first search in PROLOG

% Current state = goal, print out been list
path(Goal, Goal, Been_list) :- write('Solution path is: \n P1,P2,P3,P4,P5,P6,P7'), nl,
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


move(state(X,Y,X3,X4,X5,X6,X7), state(Y,X,X3,X4,X5,X6,X7))
:- opp(X,Y), writelist(['Swap position 1 and 2',Y,X,X3,X4,X5,X6,X7]).

move(state(X,X2,Y,X4,X5,X6,X7), state(Y,X2,X,X4,X5,X6,X7))
:- opp(X,Y), writelist(['Swap position 1 and 3',Y,X2,X,X4,X5,X6,X7]).


move(state(X,X2,X3,Y,X5,X6,X7), state(Y,X2,X3,X,X5,X6,X7))
:- opp(X,Y), writelist(['Swap position 1 and 4',Y,X2,X3,X,X5,X6,X7]).

move(state(X1,X,Y,X4,X5,X6,X7), state(X1,Y,X,X4,X5,X6,X7))
:- opp(X,Y), writelist(['Swap position 2 and 3',X1,Y,X,X4,X5,X6,X7]).

move(state(X1,X,X3,Y,X5,X6,X7), state(X1,Y,X3,X,X5,X6,X7))
:- opp(X,Y), writelist(['Swap position 2 and 4',X1,Y,X3,X,X5,X6,X7]).

move(state(X1,X,X3,X4,Y,X6,X7), state(X1,Y,X3,X4,X,X6,X7))
:- opp(X,Y), writelist(['Swap position 2 and 5',X1,Y,X3,X4,X,X6,X7]).

move(state(X1,X2,X,Y,X5,X6,X7), state(X1,X2,Y,X,X5,X6,X7))
:- opp(X,Y), writelist(['Swap position 3 and 4',X1,X2,Y,X,X5,X6,X7]).

move(state(X1,X2,X,X4,Y,X6,X7), state(X1,X2,Y,X4,X,X6,X7))
:- opp(X,Y), writelist(['Swap position 3 and 5',X1,X2,Y,X4,X,X6,X7]).

move(state(X1,X2,X,X4,X5,Y,X7), state(X1,X2,Y,X4,X5,X,X7))
:- opp(X,Y), writelist(['Swap position 3 and 6',X1,X2,Y,X4,X5,X,X7]).

move(state(X1,X2,X3,X,Y,X6,X7), state(X1,X2,X3,Y,X,X6,X7))
:- opp(X,Y), writelist(['Swap position 4 and 5',X1,X2,X3,Y,X,X6,X7]).

move(state(X1,X2,X3,X,X5,Y,X7), state(X1,X2,X3,Y,X5,X,X7))
:- opp(X,Y), writelist(['Swap position 4 and 6',X1,X2,X3,Y,X5,X,X7]).

move(state(X1,X2,X3,X,X5,X6,Y), state(X1,X2,X3,Y,X5,X6,X))
:- opp(X,Y), writelist(['Swap position 4 and 7',X1,X2,X3,Y,X5,X6,X]).

move(state(X1,X2,X3,X4,X,Y,X7), state(X1,X2,X3,X4,Y,X,X7))
:- opp(X,Y), writelist(['Swap position 5 and 6',X1,X2,X3,X4,Y,X,X7]).

move(state(X1,X2,X3,X4,X,X6,Y), state(X1,X2,X3,X4,Y,X6,X))
:- opp(X,Y), writelist(['Swap position 5 and 7',X1,X2,X3,X4,Y,X6,X]).

move(state(X1,X2,X3,X4,X5,X,Y), state(X1,X2,X3,X4,X5,Y,X))
:- opp(X,Y), writelist(['Swap position 6 and 7',X1,X2,X3,X4,X5,Y,X]).


move(state(X1,X2,X3,X4,X5,X6,X7), state(X1,X2,X3,X4,X5,X6,X7))
:- writelist(['      BACKTRACK from:',X1,X2,X3,X4,X5,X6,X7]), fail.



/*
* Definitions of writelist, and opp.
*/

writelist([]) :- nl.
writelist([H|T]):- print(H), tab(1),  /* "tab(n)" skips n spaces. */
writelist(T).

opp(w,e).
opp(e,w).
opp(b,e).
opp(e,b).

