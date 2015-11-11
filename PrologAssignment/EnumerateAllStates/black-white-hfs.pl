- [adts]. /* consults (reconsults) file containing the various ADTs (Stack, Queue, etc.) */


/*
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

*/

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
% not(unsafe(Next)),
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



heuristic(state(w,w,w,X,X1,X2,X3), state(w,w,w,X11,X22,X33,X44), 0).

heuristic(state(b,b,b,e,X1,X2,X3), state(w,w,w,X11,X22,X33,X44), 6).
heuristic(state(b,b,w,e,X1,X2,X3), state(w,w,w,X11,X22,X33,X44), 4).
heuristic(state(b,w,b,e,X1,X2,X3), state(w,w,w,X11,X22,X33,X44), 4).
heuristic(state(w,b,b,e,X1,X2,X3), state(w,w,w,X11,X22,X33,X44), 4).

heuristic(state(w,b,w,e,X1,X2,X3), state(w,w,w,X11,X22,X33,X44), 1).
heuristic(state(b,w,w,e,X1,X2,X3), state(w,w,w,X11,X22,X33,X44), 1).
heuristic(state(w,w,b,e,X1,X2,X3), state(w,w,w,X11,X22,X33,X44), 1).
%heuristic(state(w,w,w,e,X1,X2,X3), state(w,w,w,X11,X22,X33,X44), 0).



heuristic(state(X1,X2,X3,X4,e,w,w), state(w,w,w,X11,X22,X33,X44), 5).
heuristic(state(X1,X2,X3,X4,e,w,b), state(w,w,w,X11,X22,X33,X44), 3).
heuristic(state(X1,X2,X3,X4,e,b,w), state(w,w,w,X11,X22,X33,X44), 3).
heuristic(state(X1,X2,X3,X4,e,b,b), state(w,w,w,X11,X22,X33,X44), 1).

heuristic(state(X1,X2,X3,X4,X5,e,w), state(w,w,w,X11,X22,X33,X44), 4).
heuristic(state(X1,X2,X3,X4,X5,e,b), state(w,w,w,X11,X22,X33,X44), 2).



heuristic(state(X1,X2,X3,X4,X5,X6,e), state(w,w,w,X11,X22,X33,X44), 3).

heuristic(state(b,b,e,X1,X2,X3,X4), state(w,w,w,X11,X22,X33,X44), 5).
heuristic(state(b,w,e,X1,X2,X3,X4), state(w,w,w,X11,X22,X33,X44), 3).
heuristic(state(w,b,e,X1,X2,X3,X4), state(w,w,w,X11,X22,X33,X44), 3).
heuristic(state(w,w,e,X1,X2,X3,X4), state(w,w,w,X11,X22,X33,X44), 1).


heuristic(state(b,e,X1,X2,X3,X4,X5), state(w,w,w,X11,X22,X33,X44), 4).
heuristic(state(w,e,X1,X2,X3,X4,X5), state(w,w,w,X11,X22,X33,X44), 2).


heuristic(state(e,X1,X2,X3,X4,X5,X6), state(w,w,w,X11,X22,X33,X44), 3).




move(state(X,Y,X3,X4,X5,X6,X7), state(Y,X,X3,X4,X5,X6,X7))
:- opp(X,Y), writelist(['try swap position 1 and 2',Y,X,X3,X4,X5,X6,X7]).

move(state(X,X2,Y,X4,X5,X6,X7), state(Y,X2,X,X4,X5,X6,X7))
:- opp(X,Y), writelist(['try swap position 1 and 3',Y,X2,X,X4,X5,X6,X7]).


move(state(X,X2,X3,Y,X5,X6,X7), state(Y,X2,X3,X,X5,X6,X7))
:- opp(X,Y), writelist(['try swap position 1 and 4',Y,X2,X3,X,X5,X6,X7]).

move(state(X1,X,Y,X4,X5,X6,X7), state(X1,Y,X,X4,X5,X6,X7))
:- opp(X,Y), writelist(['try swap position 2 and 3',X1,Y,X,X4,X5,X6,X7]).

move(state(X1,X,X3,Y,X5,X6,X7), state(X1,Y,X3,X,X5,X6,X7))
:- opp(X,Y), writelist(['try swap position 2 and 4',X1,Y,X3,X,X5,X6,X7]).

move(state(X1,X,X3,X4,Y,X6,X7), state(X1,Y,X3,X4,X,X6,X7))
:- opp(X,Y), writelist(['try swap position 2 and 5',X1,Y,X3,X4,X,X6,X7]).

move(state(X1,X2,X,Y,X5,X6,X7), state(X1,X2,Y,X,X5,X6,X7))
:- opp(X,Y), writelist(['try swap position 3 and 4',X1,X2,Y,X,X5,X6,X7]).

move(state(X1,X2,X,X4,Y,X6,X7), state(X1,X2,Y,X4,X,X6,X7))
:- opp(X,Y), writelist(['try swap position 3 and 5',X1,X2,Y,X4,X,X6,X7]).

move(state(X1,X2,X,X4,X5,Y,X7), state(X1,X2,Y,X4,X5,X,X7))
:- opp(X,Y), writelist(['try swap position 3 and 6',X1,X2,Y,X4,X5,X,X7]).

move(state(X1,X2,X3,X,Y,X6,X7), state(X1,X2,X3,Y,X,X6,X7))
:- opp(X,Y), writelist(['try swap position 4 and 5',X1,X2,X3,Y,X,X6,X7]).

move(state(X1,X2,X3,X,X5,Y,X7), state(X1,X2,X3,Y,X5,X,X7))
:- opp(X,Y), writelist(['try swap position 4 and 6',X1,X2,X3,Y,X5,X,X7]).

move(state(X1,X2,X3,X,X5,X6,Y), state(X1,X2,X3,Y,X5,X6,X))
:- opp(X,Y), writelist(['try swap position 4 and 7',X1,X2,X3,Y,X5,X6,X]).

move(state(X1,X2,X3,X4,X,Y,X7), state(X1,X2,X3,X4,Y,X,X7))
:- opp(X,Y), writelist(['try swap position 5 and 6',X1,X2,X3,X4,Y,X,X7]).

move(state(X1,X2,X3,X4,X,X6,Y), state(X1,X2,X3,X4,Y,X6,X))
:- opp(X,Y), writelist(['try swap position 5 and 7',X1,X2,X3,X4,Y,X6,X]).

move(state(X1,X2,X3,X4,X5,X,Y), state(X1,X2,X3,X4,X5,Y,X))
:- opp(X,Y), writelist(['try swap position 6 and 7',X1,X2,X3,X4,X5,Y,X]).

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