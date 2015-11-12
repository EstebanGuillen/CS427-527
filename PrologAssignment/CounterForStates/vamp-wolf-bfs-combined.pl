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




/*
* Definitions of writelist, and opp.
*/

writelist([]) :- nl.
writelist([H|T]):- print(H), tab(1),  /* "tab(n)" skips n spaces. */
writelist(T).



