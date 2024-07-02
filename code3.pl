% Tic-Tac-Toe game using Minimax algorithm

% Utility predicates
empty_board([[' ', ' ', ' '], [' ', ' ', ' '], [' ', ' ', ' ']]).

% Display the Tic-Tac-Toe board
display_board([Row1, Row2, Row3]) :-
    write('  1   2   3'), nl,
    display_row(Row1), nl,
    write('  -----------'), nl,
    display_row(Row2), nl,
    write('  -----------'), nl,
    display_row(Row3), nl.

display_row([A, B, C]) :-
    write(A), write(' | '), write(B), write(' | '), write(C).

% Check if the current player has won
winner(Board, Player) :-
    member([Player, Player, Player], Board). % Rows
winner(Board, Player) :-
    transpose(Board, Transposed),
    member([Player, Player, Player], Transposed). % Columns
winner(Board, Player) :-
    diagonals(Board, Diagonals),
    member([Player, Player, Player], Diagonals). % Diagonals

% Transpose a matrix
transpose([[], [], []], []).
transpose([[A1, B1, C1], [A2, B2, C2], [A3, B3, C3]],
          [[A1, A2, A3], [B1, B2, B3], [C1, C2, C3]]).

% Get the diagonals of a matrix
diagonals([[A, _, C], [_, B, _], [D, _, E]], [[A, B, E], [C, B, D]]).

% Minimax algorithm
minimax(Board, Player, Value) :-
    (winner(Board, 'X'), Player = 'O', Value is 1, !; % X wins, O loses
    winner(Board, 'O'), Player = 'X', Value is -1, !; % O wins, X loses
    findall(Move-Value, (empty_spot(Board, Move), make_move(Board, Player, Move, NewBoard),
                        switch_player(Player, NextPlayer),
                        minimax(NewBoard, NextPlayer, Value)), Moves),
    choose_best(Moves, Player, BestMove-Value)).

empty_spot(Board, [Row, Col]) :-
    member(Row, [1, 2, 3]),
    member(Col, [1, 2, 3]),
    nth1(Row, Board, RowList),
    nth1(Col, RowList, ' ').

make_move(Board, Player, [Row, Col], NewBoard) :-
    move(Board, Player, [Row, Col], NewBoard).

move(Board, Player, [Row, Col], NewBoard) :-
    nth1(Row, Board, OldRow),
    replace(OldRow, Col, Player, NewRow),
    replace(Board, Row, NewRow, NewBoard).

replace([_|T], 1, X, [X|T]).
replace([H|T], I, X, [H|R]) :-
    I > 1,
    NI is I - 1,
    replace(T, NI, X, R).

choose_best([Move-Value], _, Move-Value).
choose_best([Move-Value | Rest], Player, BestMove- BestValue) :-
    choose_best(Rest, Player, Move2-Value2),
    (Player = 'X', Value > Value2, !, BestMove = Move-Value; % maximize for X
     Player = 'O', Value < Value2, !, BestMove = Move-Value; % minimize for O
     BestMove = Move2-Value2).

% Predicate to switch players
switch_player('X', 'O').
switch_player('O', 'X').

% Main predicate to play the game
play_tic_tac_toe :-
    empty_board(Board),
    display_board(Board),
    play(Board, 'X').

play(Board, _) :-
    winner(Board, 'X'),
    display_board(Board),
    write('Player X wins!'), nl.

play(Board, _) :-
    winner(Board, 'O'),
    display_board(Board),
    write('Player O wins!'), nl.

play(Board, Player) :-
    display_board(Board),
    write('Player '), write(Player), write(', enter your move (row and column): '),
    read(Move),
    make_move(Board, Player, Move, NewBoard),
    switch_player(Player, NextPlayer),
    minimax(NewBoard, NextPlayer, _-BestMove),
    make_move(NewBoard, Player, BestMove, UpdatedBoard),
    switch_player(Player, NextPlayer2),
    play(UpdatedBoard, NextPlayer2).

% Example usage:
% play_tic_tac_toe.
