% generates possible moves
moveAI(PreviousBoard, Board, FinalBoard, Color, Adversary, GameStatus, Row, Column, NewRow, NewColumn) :-
    genPosition(Row, Column),
    checkPosition(Row, Column, Color, Board),
    checkMoveAI(PreviousBoard, Row, Column, NewRow, NewColumn, Board, FinalBoard, Color, Adversary, GameStatus).


% confirms the direction each piece can move
checkMoveAI(PreviousBoard, Row, Column, R, C, Board, FinalBoard, Color, Adversary, GameStatus) :-
    % up movement
    R is Row - 1,
    R > 0,
    C = Column,
    checkRowAI(Row, R, Column, PreviousBoard, Board, FinalBoard, Color, Adversary, GameStatus)
    ;
    % down movement
    R is Row + 1,
    R < 6,
    C = Column,
    checkRowAI(Row, R, Column, PreviousBoard, Board, FinalBoard, Color, Adversary, GameStatus)
    ;
    % left movement
    C is Column - 1,
    C > 0,
    R = Row,
    checkColumnAI(Row, C, Column, PreviousBoard, Board, FinalBoard, Color, Adversary, GameStatus)
    ;
    % right movement
    C is Column + 1,
    C < 6,
    R = Row,
    checkColumnAI(Row, C, Column, PreviousBoard, Board, FinalBoard, Color, Adversary, GameStatus)
    ;
    fail.

% checks if the horizontal move is valid
checkRowAI(Row, R, Column, PreviousBoard, Board, FinalBoard, Color, Adversary, GameStatus) :-
    once(checkNudge(Row, Column, Row, Column, R, Column, Color, Adversary, Board, FinalBoard, 0, GameStatus, 0)),
    once(checkReturnPosition(PreviousBoard, FinalBoard, 0)).

% checks if the vertical move is valid
checkColumnAI(Row, C, Column, PreviousBoard, Board, FinalBoard, Color, Adversary, GameStatus) :-
    once(checkNudge(Row, Column, Row, Column, Row, C, Color, Adversary, Board, FinalBoard, 0, GameStatus, 0)),
    once(checkReturnPosition(PreviousBoard, FinalBoard, 0)).

% winning moves -> NewWin, other moves -> NewOther
value([], Board, Board, Board1, Board1, _) :- !.
value([Head-R-C-NR-NC|Tail], Win, NewWin, Other, NewOther, Adversary) :-
    (
        gameOverAI(Head, Adversary, 0),
        join_lists(Other, [Head-R-C-NR-NC], Other2),
        join_lists(Win, [], Win2)
        ;
        join_lists(Win, [Head-R-C-NR-NC], Win2),
        join_lists(Other, [], Other2)
    ),
    value(Tail, Win2, NewWin, Other2, NewOther, Adversary).

% winning moves -> NewWin, other moves -> NewOther
value2([], Board, Board, Board1, Board1, _) :- !.
value2([Head-R-C-NR-NC-R2-C2-NR2-NC2|Tail], Win, NewWin, Other, NewOther, Adversary) :-
    (
        gameOverAI(Head, Adversary, 0),
        join_lists(Other, [Head-R-C-NR-NC-R2-C2-NR2-NC2], Other2),
        join_lists(Win, [], Win2)
        ;
        join_lists(Win, [Head-R-C-NR-NC-R2-C2-NR2-NC2], Win2),
        join_lists(Other, [], Other2)
    ),
    value2(Tail, Win2, NewWin, Other2, NewOther, Adversary).

% finds all possible moves with two plays
valid_moves([], _, _, _, _, Board, Board) :- !.
valid_moves([Head-Row-Column-NR-NC|Tail], PreviousBoard, Color, Adversary, GameStatus, AllBoards, FinalistBoard) :-
    findall(NewFinalBoard-Row-Column-NR-NC-Row2-Column2-NewRow2-NewColumn2, moveAI(PreviousBoard, Head, NewFinalBoard, Color, Adversary, GameStatus, Row2, Column2, NewRow2, NewColumn2), NewAllBoards),
    join_lists(AllBoards, NewAllBoards, FinalAllBoards),
    valid_moves(Tail, PreviousBoard, Color, Adversary, GameStatus, FinalAllBoards, FinalistBoard).

% checks if a certain move is victorious (for the AI to decide if it should play it)
gameOverAI(Board, Adversary, EndGame) :-
    % finds number of pieces of the opponent on the board
    findall(FinalBoard, pieceCounter(Board, FinalBoard, Adversary), AllPieces),
    length(AllPieces, Length),
    Length == 3
    ;
    % black wins because white has less than 3 pieces on the board
    EndGame == 1,
    Adversary == white,
    playerTwoWins
    ;
    % white wins because black has less than 3 pieces on the board
    EndGame == 1,
    Adversary == black,
    playerOneWins
    ;
    % used to check if it's a winner board, but not ending the game
    !, 
    fail.

    gameOverAIT(Board, Adversary, EndGame, GameStatus) :-
    % finds number of pieces of the opponent on the board
    findall(FinalBoard, pieceCounter(Board, FinalBoard, Adversary), AllPieces),
    length(AllPieces, Length),
    write('here7'),
    Length == 3
    ;
    % black wins because white has less than 3 pieces on the board
    EndGame == 1,
    write('please'),
    Adversary == white,
    write('here4'),
    GameStatus = 1,
    write('here2'),
    playerTwoWins
        
    ;
    % white wins because black has less than 3 pieces on the board
    EndGame == 1,
        write('please'),
    Adversary == black,
    write('here1'),
    GameStatus =1,
    write('here3'),
    playerOneWins.