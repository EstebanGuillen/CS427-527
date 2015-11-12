% Search problem for Vampire and Werewolves
% To run the code in SWI-Prolog, do
%       ?- ['vampwolf.pl'].
%       ?- find.

% Represent a state as [VampsLeft, WolvesLeft, Boat, VampsRight, WolvesRight]

start([3,3,left,0,0]).
goal([0,0,right,3,3]).

legal(VL,WL,VR,WR) :-
    % is this state safe?
    VL>=0, WL>=0, VR>=0, WR>=0,
    (VL>=WL ; VL=0),
    (VR>=WR ; VR=0).

% Possible moves
move([VL,WL,left,VR,WR],[VL2,WL,right,VR2,WR]):-
    % Two vampires cross to the right
    VR2 is VR+2,
    VL2 is VL+2,
    legal(VL2,WL,VR2,WR).

move([VL,WL,left,VR,WR],[VL,WL2,right,VR,WR2]):-
    % Two wolves cross left to right.
    WR2 is WR+2,
    WL2 is WL-2,
    legal(VL,WL2,VL,WR2).


move([VL,WL,left,VR,WR],[VL2,WL2,right,VR2,WR2]):-
    % One missionary and one cannibal cross left to right
    WR2 is WR+1,
    WL2 is WL-1,
    VR2 is VR+1,
    VL2 is VL-1,
    legal(VL2,WL2,VR2,WR2).

move([VL,WL,left,VR,WR],[VL2,WL,right,VR2,WR]):-
    % One vampire crosses left to right.
    VR2 is VR+1,
    VL2 is VL-1,
    legal(VL2,WL,VR2,WR).

move([VL,WL,left,VR,WR],[VL,WL2,right,VR,WR2]):-
    % One wolf crosses left to right.
    WR2 is WR+1,
    WL2 is WL-1,
    legal(VL,WL2,VR,WR2).

move([VL,WL,right,VR,WR],[VL2,WL,left,VR2,WR]):-
    % Two vampires cross right to left.
    VR2 is VR-2,
    VL2 is VL+2,
    legal(VL2,WL,VR2,WR).

move([VL,WL,right,VR,WR],[VL,WL2,left,VR,WR2]):-
    % Two wolves cross right to left.
    WR2 is WR-2,
    WL2 is WL+2,
    legal(VL,WL2,VR,WR2).

move([VL,WL,right,VR,WR],[VL2,WL2,left,VR2,WR2]):-
    %  One vampire and one wolf cross right to left.
    VR2 is VR-1,
    VL2 is VL+1,
    WR2 is WR-1,
    WL2 is WL+1,
    legal(VL2,WL2,VR2,WR2).

move([VL,WL,right,VR,WR],[VL2,WL,left,VR2,WR]):-
    % One vampire crosses right to left.
    VR2 is VR-1,
    VL2 is VL+1,
    legal(VL2,WL,VR2,WR).

move([VL,WL,right,VR,WR],[VL,WL2,left,VR,WR2]):-
    % One wolf crosses right to left.
    WR2 is WR-1,
    WL2 is WL+1,
    legal(VL,WL2,VR,WR2).

% Recursive call to solve the problem
    path([VL1,WL1,B1,VR1,WR1],[VL2,WL2,B2,VR2,WR2],Explored,MovesList) :-
    move([VL1,WL1,B1,VR1,WR1],[VL3,WL3,B3,VR3,WR3]),
    not(member([VL3,WL3,B3,VR3,WR3],Explored)),
    path([VL3,WL3,B3,VR3,WR3],[VL2,WL2,B2,VR2,WR2],[[VL3,WL3,B3,VR3,WR3]|Explored],[ [[VL3,WL3,B3,VR3,WR3],[VL1,WL1,B1,VR1,WR1]] | MovesList ]).
    
% Solution found
path([VL,WL,B,VR,WR],[VL,WL,B,VR,WR],_,MovesList):-
    output(MovesList).

% Printing
output([]) :- nl.
output([[A,B]|MovesList]) :-
    output(MovesList),
    write(B), write(' -> '), write(A), nl.

% Find the solution for the vampires and werewolves problem
find :-
    path([3,3,left,0,0],[0,0,right,3,3],[[3,3,left,0,0]],_).
