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


state_record(State, Parent, [State, Parent]).

go(Start, Goal) :-
empty_queue(Empty_open),
state_record(Start, nil, State),
add_to_queue(State, Empty_open, Open),
empty_set(Closed),
path(Open, Closed, Goal).

path(Open,_,_) :- empty_queue(Open),
write('graph searched, no solution found').

path(Open, Closed, Goal) :-
remove_from_queue(Next_record, Open, _),
state_record(State, _, Next_record),
State = Goal,
write('Solution path is: \n P1,P2,P3,P4,P5,P6,P7'), nl,
printsolution(Next_record, Closed).

path(Open, Closed, Goal) :-
remove_from_queue(Next_record, Open, Rest_of_open),
(bagof(Child, moves(Next_record, Open, Closed, Child), Children);Children = []),
add_list_to_queue(Children, Rest_of_open, New_open),
add_to_set(Next_record, Closed, New_closed),
path(New_open, New_closed, Goal),!.

moves(State_record, Open, Closed, Child_record) :-
state_record(State, _, State_record),
move(State, Next),
%not(unsafe(Next)),
state_record(Next, _, Test),
not(member_queue(Test, Open)),
not(member_set(Test, Closed)),
state_record(Next, State, Child_record).

printsolution(State_record, _):-
state_record(State,nil, State_record),
write(State), nl.
printsolution(State_record, Closed) :-
state_record(State, Parent, State_record),
state_record(Parent, _, Parent_record),
member(Parent_record, Closed),
printsolution(Parent_record, Closed),
write(State), nl.

add_list_to_queue([], Queue, Queue).
add_list_to_queue([H|T], Queue, New_queue) :-
add_to_queue(H, Queue, Temp_queue),
add_list_to_queue(T, Temp_queue, New_queue).



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
:- opp(X,Y), writelist(['try swap position 3 and 6',X1,X2,Y,X4,X5,X,X7]).

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

reverse_print_stack(S) :-
empty_stack(S).
reverse_print_stack(S) :-
stack(E, Rest, S),
reverse_print_stack(Rest),
write(E), nl.