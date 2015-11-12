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

state_record(State, Parent, G, H, F, [State, Parent, G, H, F]).
precedes([_,_,_,_,F1], [_,_,_,_,F2]) :- F1 =< F2.

% go initializes Open and CLosed and calls path
go(Start, Goal) :-
empty_set(Closed),
empty_sort_queue(Empty_open),
heuristic(Start, Goal, H),
state_record(Start, nil, 0, H, H, First_record),
insert_sort_queue(First_record, Empty_open, Open),
path(Open,Closed, Goal).

% Path performs a best first search,
% maintaining Open as a priority queue, and Closed as
% a set.

% Open is empty; no solution found
path(Open,_,_) :-
empty_sort_queue(Open),
write("graph searched, no solution found").

% The next record is a goal
% Print out the list of visited states
path(Open, Closed, Goal) :-
remove_sort_queue(First_record, Open, _),
state_record(State, _, _, _, _, First_record),
State = Goal,
write('Solution path is: '), nl,
printsolution(First_record, Closed).

% The next record is not equal to the goal
% Generate its children, add to open and continue
% Note that bagof in AAIS prolog fails if its goal fails,
% I needed to use the or to make it return an empty list in this case
path(Open, Closed, Goal) :-
remove_sort_queue(First_record, Open, Rest_of_open),
(bagof(Child, moves(First_record, Open, Closed, Child, Goal), Children);Children = []),
insert_list(Children, Rest_of_open, New_open),
add_to_set(First_record, Closed, New_closed),
path(New_open, New_closed, Goal),!.

% moves generates all children of a state that are not already on
% open or closed.  The only wierd thing here is the construction
% of a state record, test, that has unbound variables in all positions
% except the state.  It is used to see if the next state matches
% something already on open or closed, irrespective of that states parent
% or other attributes
% Also, I've commented out unsafe since the way I've coded the water jugs
% problem I don't really need it.
moves(State_record, Open, Closed,Child, Goal) :-
state_record(State, _, G, _,_, State_record),
move(State, Next),
not(unsafe(Next)),
state_record(Next, _, _, _, _, Test),
not(member_sort_queue(Test, Open)),
not(member_set(Test, Closed)),
G_new is G + 1,
heuristic(Next, Goal, H),
F is G_new + H,
state_record(Next, State, G_new, H, F, Child).

%insert_list inserts a list of states obtained from a  call to
% bagof and  inserts them in a priotrity queue, one at a time
insert_list([], L, L).
insert_list([State | Tail], L, New_L) :-
insert_sort_queue(State, L, L2),
insert_list(Tail, L2, New_L).

% Printsolution prints out the solution path by tracing
% back through the states on closed using parent links.
printsolution(Next_record, _):-
state_record(State, nil, _, _,_, Next_record),
write(State), nl.
printsolution(Next_record, Closed) :-
state_record(State, Parent, _, _,_, Next_record),
state_record(Parent, _, _, _, _, Parent_record),
member_set(Parent_record, Closed),
printsolution(Parent_record, Closed),
write(State), nl.

heuristic(state(e,e,e,e,e,e,X), state(e,e,e,e,e,e,e), 0).

heuristic(state(w,w,w,w,w,w,X), state(e,e,e,e,e,e,e), 6).
heuristic(state(w,w,w,w,w,e,X), state(e,e,e,e,e,e,e), 5).
heuristic(state(w,w,w,w,e,w,X), state(e,e,e,e,e,e,e), 5).
heuristic(state(w,w,w,w,e,e,X), state(e,e,e,e,e,e,e), 4).
heuristic(state(w,w,w,e,w,w,X), state(e,e,e,e,e,e,e), 5).
heuristic(state(w,w,w,e,w,e,X), state(e,e,e,e,e,e,e), 4).
heuristic(state(w,w,w,e,e,w,X), state(e,e,e,e,e,e,e), 4).
heuristic(state(w,w,w,e,e,e,X), state(e,e,e,e,e,e,e), 3).

heuristic(state(w,w,e,w,w,w,X), state(e,e,e,e,e,e,e), 5).
heuristic(state(w,w,e,w,w,e,X), state(e,e,e,e,e,e,e), 4).
heuristic(state(w,w,e,w,e,w,X), state(e,e,e,e,e,e,e), 3).
heuristic(state(w,w,e,w,e,e,X), state(e,e,e,e,e,e,e), 3).
heuristic(state(w,w,e,e,w,w,X), state(e,e,e,e,e,e,e), 4).
heuristic(state(w,w,e,e,w,e,X), state(e,e,e,e,e,e,e), 3).
heuristic(state(w,w,e,e,e,w,X), state(e,e,e,e,e,e,e), 3).
heuristic(state(w,w,e,e,e,e,X), state(e,e,e,e,e,e,e), 2).

heuristic(state(w,e,w,w,w,w,X), state(e,e,e,e,e,e,e), 5).
heuristic(state(w,e,w,w,w,e,X), state(e,e,e,e,e,e,e), 4).
heuristic(state(w,e,w,w,e,w,X), state(e,e,e,e,e,e,e), 3).
heuristic(state(w,e,w,w,e,e,X), state(e,e,e,e,e,e,e), 3).
heuristic(state(w,e,w,e,w,w,X), state(e,e,e,e,e,e,e), 4).
heuristic(state(w,e,w,e,w,e,X), state(e,e,e,e,e,e,e), 3).
heuristic(state(w,e,w,e,e,w,X), state(e,e,e,e,e,e,e), 3).
heuristic(state(w,e,w,e,e,e,X), state(e,e,e,e,e,e,e), 2).

heuristic(state(w,e,e,w,w,w,X), state(e,e,e,e,e,e,e), 4).
heuristic(state(w,e,e,w,w,e,X), state(e,e,e,e,e,e,e), 3).
heuristic(state(w,e,e,w,e,w,X), state(e,e,e,e,e,e,e), 2).
heuristic(state(w,e,e,w,e,e,X), state(e,e,e,e,e,e,e), 2).
heuristic(state(w,e,e,e,w,w,X), state(e,e,e,e,e,e,e), 3).
heuristic(state(w,e,e,e,w,e,X), state(e,e,e,e,e,e,e), 2).
heuristic(state(w,e,e,e,e,w,X), state(e,e,e,e,e,e,e), 2).
heuristic(state(w,e,e,e,e,e,X), state(e,e,e,e,e,e,e), 1).

heuristic(state(e,w,w,w,w,w,X), state(e,e,e,e,e,e,e), 5).
heuristic(state(e,w,w,w,w,e,X), state(e,e,e,e,e,e,e), 4).
heuristic(state(e,w,w,w,e,w,X), state(e,e,e,e,e,e,e), 4).
heuristic(state(e,w,w,w,e,e,X), state(e,e,e,e,e,e,e), 3).
heuristic(state(e,w,w,e,w,w,X), state(e,e,e,e,e,e,e), 4).
heuristic(state(e,w,w,e,w,e,X), state(e,e,e,e,e,e,e), 3).
heuristic(state(e,w,w,e,e,w,X), state(e,e,e,e,e,e,e), 3).
heuristic(state(e,w,w,e,e,e,X), state(e,e,e,e,e,e,e), 2).

heuristic(state(e,w,e,w,w,w,X), state(e,e,e,e,e,e,e), 4).
heuristic(state(e,w,e,w,w,e,X), state(e,e,e,e,e,e,e), 3).
heuristic(state(e,w,e,w,e,w,X), state(e,e,e,e,e,e,e), 3).
heuristic(state(e,w,e,w,e,e,X), state(e,e,e,e,e,e,e), 2).
heuristic(state(e,w,e,e,w,w,X), state(e,e,e,e,e,e,e), 3).
heuristic(state(e,w,e,e,w,e,X), state(e,e,e,e,e,e,e), 2).
heuristic(state(e,w,e,e,e,w,X), state(e,e,e,e,e,e,e), 2).
heuristic(state(e,w,e,e,e,e,X), state(e,e,e,e,e,e,e), 1).

heuristic(state(e,e,w,w,w,w,X), state(e,e,e,e,e,e,e), 4).
heuristic(state(e,e,w,w,w,e,X), state(e,e,e,e,e,e,e), 3).
heuristic(state(e,e,w,w,e,w,X), state(e,e,e,e,e,e,e), 3).
heuristic(state(e,e,w,w,e,e,X), state(e,e,e,e,e,e,e), 2).
heuristic(state(e,e,w,e,w,w,X), state(e,e,e,e,e,e,e), 3).
heuristic(state(e,e,w,e,w,e,X), state(e,e,e,e,e,e,e), 2).
heuristic(state(e,e,w,e,e,w,X), state(e,e,e,e,e,e,e), 2).
heuristic(state(e,e,w,e,e,e,X), state(e,e,e,e,e,e,e), 1).

heuristic(state(e,e,e,w,w,w,X), state(e,e,e,e,e,e,e), 3).
heuristic(state(e,e,e,w,w,e,X), state(e,e,e,e,e,e,e), 2).
heuristic(state(e,e,e,w,e,w,X), state(e,e,e,e,e,e,e), 2).
heuristic(state(e,e,e,w,e,e,X), state(e,e,e,e,e,e,e), 1).
heuristic(state(e,e,e,e,w,w,X), state(e,e,e,e,e,e,e), 2).
heuristic(state(e,e,e,e,w,e,X), state(e,e,e,e,e,e,e), 1).
heuristic(state(e,e,e,e,e,w,X), state(e,e,e,e,e,e,e), 1).
heuristic(state(e,e,e,e,e,e,X), state(e,e,e,e,e,e,e), 0).





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