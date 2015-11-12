% to run the code in SWI-Prolog, do
%        ?- ['vampwolf.pl'].
%        ?- find.

% Represent a state as [WL,VL,B,WR,VR]
start([3,3,left,0,0]).
goal([0,0,right,3,3]).

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
legal(WL,VL2,WR,VR2).

move([WL,VL,left,WR,VR],[WL2,VL,right,WR2,VR]):-
% Two wolves cross left to right.
WR2 is WR+2,
WL2 is WL-2,
legal(WL2,VL,WR2,VR).

move([WL,VL,left,WR,VR],[WL2,VL2,right,WR2,VR2]):-
%  One vampire and one wolf cross left to right.
WR2 is WR+1,
WL2 is WL-1,
VR2 is VR+1,
VL2 is VL-1,
legal(WL2,VL2,WR2,VR2).

move([WL,VL,left,WR,VR],[WL,VL2,right,WR,VR2]):-
% One vampire crosses left to right.
VR2 is VR+1,
VL2 is VL-1,
legal(WL,VL2,WR,VR2).

move([WL,VL,left,WR,VR],[WL2,VL,right,WR2,VR]):-
% One wolf crosses left to right.
WR2 is WR+1,
WL2 is WL-1,
legal(WL2,VL,WR2,VR).

move([WL,VL,right,WR,VR],[WL,VL2,left,WR,VR2]):-
% Two vampires cross right to left.
VR2 is VR-2,
VL2 is VL+2,
legal(WL,VL2,WR,VR2).

move([WL,VL,right,WR,VR],[WL2,VL,left,WR2,VR]):-
% Two wolves cross right to left.
WR2 is WR-2,
WL2 is WL+2,
legal(WL2,VL,WR2,VR).

move([WL,VL,right,WR,VR],[WL2,VL2,left,WR2,VR2]):-
%  One vampire and one wolf cross right to left.
WR2 is WR-1,
WL2 is WL+1,
VR2 is VR-1,
VL2 is VL+1,
legal(WL2,VL2,WR2,VR2).

move([WL,VL,right,WR,VR],[WL,VL2,left,WR,VR2]):-
% One vampire crosses right to left.
VR2 is VR-1,
VL2 is VL+1,
legal(WL,VL2,WR,VR2).

move([WL,VL,right,WR,VR],[WL2,VL,left,WR2,VR]):-
% One wolf crosses right to left.
WR2 is WR-1,
WL2 is WL+1,
legal(WL2,VL,WR2,VR).


% Recursive call to solve the problem
path([WL1,VL1,B1,WR1,VR1],[WL2,VL2,B2,WR2,VR2],Explored,MovesList) :-
move([WL1,VL1,B1,WR1,VR1],[WL3,VL3,B3,WR3,VR3]),
not(member([WL3,VL3,B3,WR3,VR3],Explored)),
path([WL3,VL3,B3,WR3,VR3],[WL2,VL2,B2,WR2,VR2],[[WL3,VL3,B3,WR3,VR3]|Explored],[ [[WL3,VL3,B3,WR3,VR3],[WL1,VL1,B1,WR1,VR1]] | MovesList ]).

% Solution found
path([WL,VL,B,WR,VR],[WL,VL,B,WR,VR],_,MovesList):-
output(MovesList).

% Printing
output([]) :- nl.
output([[A,B]|MovesList]) :-
output(MovesList),
write(B), write(' -> '), write(A), nl.

% Find the solution for the vampires and werewolves problem
find :-
path([3,3,left,0,0],[0,0,right,3,3],[[3,3,left,0,0]],_).