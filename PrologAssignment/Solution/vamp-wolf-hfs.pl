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
write('\nSolution path is: \n[WL,VL,B,WR,VR]'), nl,
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
%not(unsafe(Next)),
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

legal(WL,VL,WR,VR) :-
% is this state a legal one?
VL>=0, WL>=0, VR>=0, WR>=0,
(VL>=WL ; VL=0),
(VR>=WR ; VR=0).


% Possible moves:
move([WL,VL,left,WR,VR],[WL,VL2,right,WR,VR2]):-
% Two vampires cross left to right.
VR2 is VR+2,
VL2 is VL-2,
legal(WL,VL2,WR,VR2),
writelist(['Two vampires cross left to right',[WL,VL2,right,WR,VR2] ]).

move([WL,VL,left,WR,VR],[WL2,VL,right,WR2,VR]):-
% Two wolves cross left to right.
WR2 is WR+2,
WL2 is WL-2,
legal(WL2,VL,WR2,VR),
writelist(['Two wolves cross left to right',[WL2,VL,right,WR2,VR] ]).

move([WL,VL,left,WR,VR],[WL2,VL2,right,WR2,VR2]):-
%  One vampire and one wolf cross left to right.
WR2 is WR+1,
WL2 is WL-1,
VR2 is VR+1,
VL2 is VL-1,
legal(WL2,VL2,WR2,VR2),
writelist(['One vampire and one wolf cross left to right',[WL2,VL2,right,WR2,VR2] ]).

move([WL,VL,left,WR,VR],[WL,VL2,right,WR,VR2]):-
% One vampire crosses left to right.
VR2 is VR+1,
VL2 is VL-1,
legal(WL,VL2,WR,VR2),
writelist(['One vampire crosses left to right.',[WL,VL2,right,WR,VR2] ]).

move([WL,VL,left,WR,VR],[WL2,VL,right,WR2,VR]):-
% One wolf crosses left to right.
WR2 is WR+1,
WL2 is WL-1,
legal(WL2,VL,WR2,VR),
writelist(['One wolf crosses left to right.',[WL2,VL,right,WR2,VR] ]).

move([WL,VL,right,WR,VR],[WL,VL2,left,WR,VR2]):-
% Two vampires cross right to left.
VR2 is VR-2,
VL2 is VL+2,
legal(WL,VL2,WR,VR2),
writelist(['Two vampires cross right to left.',[WL,VL2,left,WR,VR2] ]).

move([WL,VL,right,WR,VR],[WL2,VL,left,WR2,VR]):-
% Two wolves cross right to left.
WR2 is WR-2,
WL2 is WL+2,
legal(WL2,VL,WR2,VR),
writelist(['Two wolves cross right to left.',[WL2,VL,left,WR2,VR] ]).

move([WL,VL,right,WR,VR],[WL2,VL2,left,WR2,VR2]):-
%  One vampire and one wolf cross right to left.
WR2 is WR-1,
WL2 is WL+1,
VR2 is VR-1,
VL2 is VL+1,
legal(WL2,VL2,WR2,VR2),
writelist(['One vampire and one wolf cross right to left.',[WL2,VL2,left,WR2,VR2] ]).

move([WL,VL,right,WR,VR],[WL,VL2,left,WR,VR2]):-
% One vampire crosses right to left.
VR2 is VR-1,
VL2 is VL+1,
legal(WL,VL2,WR,VR2),
writelist(['One vampire crosses right to left.',[WL,VL2,left,WR,VR2] ]).

move([WL,VL,right,WR,VR],[WL2,VL,left,WR2,VR]):-
% One wolf crosses right to left.
WR2 is WR-1,
WL2 is WL+1,
legal(WL2,VL,WR2,VR),
writelist(['One wolf crosses right to left.',[WL2,VL,left,WR2,VR] ]).


%heuristic is just number of vamps and wolfs on the westside of the river


heuristic([WL,VL,_,_,_], [0,0,right,3,3], H):- H is WL + VL.


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