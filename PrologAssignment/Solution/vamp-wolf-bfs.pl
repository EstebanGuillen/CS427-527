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
path(Goal, Goal, Been_list) :- write('\nSolution path is: \n[WL,VL,B,WR,VR]'), nl,
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








