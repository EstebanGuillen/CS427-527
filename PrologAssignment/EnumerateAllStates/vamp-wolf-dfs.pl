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
path(Goal, Goal, Been_list) :- write('Solution path is: \n V1,V2,V3,W1,W2,W3,B'), nl,
reverse_print_stack(Been_list).

path(State, Goal, Been_list) :-
move(State, Next),
not(unsafe(Next)),
not(member_stack(Next, Been_list)),
stack(Next, Been_list, New_been_list),
path(Next, Goal, New_been_list), !.

reverse_print_stack(S) :-
empty_stack(S).
reverse_print_stack(S) :-
stack(E, Rest, S),
reverse_print_stack(Rest),
write(E), nl.






move(state(X,V2,V3,W1,W2,W3,X), state(Y,V2,V3,W1,W2,W3,Y))
:- opp(X,Y), not(unsafe(state(Y,V2,V3,W1,W2,W3,Y))),
writelist(['try move one vampire(1)',Y,V2,V3,W1,W2,W3,Y]).



move(state(V1,X,V3,W1,W2,W3,X), state(V1,Y,V3,W1,W2,W3,Y))
:- opp(X,Y), not(unsafe(state(V1,Y,V3,W1,W2,W3,Y))),
writelist(['try move one vampire(2)',V1,Y,V3,W1,W2,W3,Y]).



move(state(V1,V2,X,W1,W2,W3,X), state(V1,V2,Y,W1,W2,W3,Y))
:- opp(X,Y), not(unsafe(state(V1,V2,Y,W1,W2,W3,Y))),
writelist(['try move one vampire(3)',V1,V2,Y,W1,W2,W3,Y]).


move(state(X,X,V3,W1,W2,W3,X), state(Y,Y,V3,W1,W2,W3,Y))
:- opp(X,Y), not(unsafe(state(Y,Y,V3,W1,W2,W3,Y))),
writelist(['try move two vampires(1,2)',Y,Y,V3,W1,W2,W3,Y]).

move(state(X,V2,X,W1,W2,W3,X), state(Y,V2,Y,W1,W2,W3,Y))
:- opp(X,Y), not(unsafe(state(Y,V2,Y,W1,W2,W3,Y))),
writelist(['try move two vampires(1,3)',Y,V2,Y,W1,W2,W3,Y]).

move(state(V1,X,X,W1,W2,W3,X), state(V1,Y,Y,W1,W2,W3,Y))
:- opp(X,Y), not(unsafe(state(V1,Y,Y,W1,W2,W3,Y))),
writelist(['try move two vampires(2,3)',V1,Y,Y,W1,W2,W3,Y]).


move(state(V1,V2,V3,X,X,W3,X), state(V1,V2,V3,Y,Y,W3,Y))
:- opp(X,Y), not(unsafe(state(V1,V2,V3,Y,Y,W3,Y))),
writelist(['try move two werewolfs(1,2)',V1,V2,V3,Y,Y,W3,Y]).

move(state(V1,V2,V3,X,W2,X,X), state(V1,V2,V3,Y,W2,Y,Y))
:- opp(X,Y), not(unsafe(state(V1,V2,V3,Y,W2,Y,Y))),
writelist(['try move two werewolfs(1,3)',V1,V2,V3,Y,W2,Y,Y]).

move(state(V1,V2,V3,W1,X,X,X), state(V1,V2,V3,W1,Y,Y,Y))
:- opp(X,Y), not(unsafe(state(V1,V2,V3,W1,Y,Y,Y))),
writelist(['try move two werewolfs(2,3)',V1,V2,V3,W1,Y,Y,Y]).


move(state(V1,V2,V3,X,W2,W3,X), state(V1,V2,V3,Y,W2,W3,Y))
:- opp(X,Y), not(unsafe(state(V1,V2,V3,Y,W2,W3,Y))),
writelist(['try move one werewolf(1)',V1,V2,V3,Y,W2,W3,Y]).

move(state(V1,V2,V3,W1,X,W3,X), state(V1,V2,V3,W1,Y,W3,Y))
:- opp(X,Y), not(unsafe(state(V1,V2,V3,W1,Y,W3,Y))),
writelist(['try move one werewolf(2)',V1,V2,V3,W1,Y,W3,Y]).

move(state(V1,V2,V3,W1,W2,X,X), state(V1,V2,V3,W1,W2,Y,Y))
:- opp(X,Y), not(unsafe(state(V1,V2,V3,W1,W2,Y,Y))),
writelist(['try move one werewolf(3)',V1,V2,V3,W1,W2,Y,Y]).





move(state(X,V2,V3,X,W2,W3,X), state(Y,V2,V3,Y,W2,W3,Y))
:- opp(X,Y), not(unsafe(state(Y,V2,V3,Y,W2,W3,Y))),
writelist(['try move one vampire(1) and one werewolf(1)',Y,V2,V3,Y,W2,W3,Y]).

move(state(X,V2,V3,W1,X,W3,X), state(Y,V2,V3,W1,Y,W3,Y))
:- opp(X,Y), not(unsafe(state(Y,V2,V3,W1,Y,W3,Y))),
writelist(['try move one vampire(1) and one werewolf(2)',Y,V2,V3,W1,Y,W3,Y]).

move(state(X,V2,V3,W1,W2,X,X), state(Y,V2,V3,W1,W2,Y,Y))
:- opp(X,Y), not(unsafe(state(Y,V2,V3,W1,W2,Y,Y))),
writelist(['try move one vampire(1) and one werewolf(3)',Y,V2,V3,W1,W2,Y,Y]).

move(state(V1,X,V3,X,W2,W3,X), state(V1,Y,V3,Y,W2,W3,Y))
:- opp(X,Y), not(unsafe(state(V1,Y,V3,Y,W2,W3,Y))),
writelist(['try move one vampire(2) and one werewolf(1)',V1,Y,V3,Y,W2,W3,Y]).

move(state(V1,X,V3,W1,X,W3,X), state(V1,Y,V3,W1,Y,W3,Y))
:- opp(X,Y), not(unsafe(state(V1,Y,V3,W1,Y,W3,Y))),
writelist(['try move one vampire(2) and one werewolf(2)',V1,Y,V3,W1,Y,W3,Y]).

move(state(V1,X,V3,W1,W2,X,X), state(V1,Y,V3,W1,W2,Y,Y))
:- opp(X,Y), not(unsafe(state(V1,Y,V3,W1,W2,Y,Y))),
writelist(['try move one vampire(2) and one werewolf(3)',V1,Y,V3,W1,W2,Y,Y]).

move(state(V1,V2,X,X,W2,W3,X), state(V1,V2,Y,Y,W2,W3,Y))
:- opp(X,Y), not(unsafe(state(V1,V2,Y,Y,W2,W3,Y))),
writelist(['try move one vampire(3) and one werewolf(1)',V1,V2,Y,Y,W2,W3,Y]).

move(state(V1,V2,X,W1,X,W3,X), state(V1,V2,Y,W1,Y,W3,Y))
:- opp(X,Y), not(unsafe(state(V1,V2,Y,W1,Y,W3,Y))),
writelist(['try move one vampire(3) and one werewolf(2)',V1,V2,Y,W1,Y,W3,Y]).


move(state(V1,V2,X,W1,W2,X,X), state(V1,V2,Y,W1,W2,Y,Y))
:- opp(X,Y), not(unsafe(state(V1,V2,Y,W1,W2,Y,Y))),
writelist(['try move one vampire(3) and one werewolf(3)',V1,V2,Y,W1,W2,Y,Y]).



move(state(V1,V2,V3,W1,W2,W3,B), state(V1,V2,V3,W1,W2,W3,B))
:- writelist(['      BACKTRACK from:',V1,V2,V3,W1,W2,W3,B]), fail.





unsafe(state(X,Y,Y,X,X,X,B)) :- opp(X,Y).
unsafe(state(Y,X,Y,X,X,X,B)) :- opp(X,Y).
unsafe(state(Y,Y,X,X,X,X,B)) :- opp(X,Y).

unsafe(state(X,X,Y,X,X,X,B)) :- opp(X,Y).
unsafe(state(Y,X,X,X,X,X,B)) :- opp(X,Y).
unsafe(state(X,Y,X,X,X,X,B)) :- opp(X,Y).

unsafe(state(X,Y,Y,Y,X,X,B)) :- opp(X,Y).
unsafe(state(Y,X,Y,Y,X,X,B)) :- opp(X,Y).
unsafe(state(Y,Y,X,Y,X,X,B)) :- opp(X,Y).

unsafe(state(X,Y,Y,X,Y,X,B)) :- opp(X,Y).
unsafe(state(Y,X,Y,X,Y,X,B)) :- opp(X,Y).
unsafe(state(Y,Y,X,X,Y,X,B)) :- opp(X,Y).

unsafe(state(X,Y,Y,X,X,Y,B)) :- opp(X,Y).
unsafe(state(Y,X,Y,X,X,Y,B)) :- opp(X,Y).
unsafe(state(Y,Y,X,X,X,Y,B)) :- opp(X,Y).


/*
* Definitions of writelist, and opp.
*/

writelist([]) :- nl.
writelist([H|T]):- print(H), tab(1),  /* "tab(n)" skips n spaces. */
writelist(T).

opp(e,w).
opp(w,e).

reverse_print_stack(S) :-
empty_stack(S).
reverse_print_stack(S) :-
stack(E, Rest, S),
reverse_print_stack(Rest),
write(E), nl.