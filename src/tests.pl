
:- consult('init_form.pl').
:- consult('display_game_helpers.pl').
:- consult('valid_moves_helpers.pl').
:- consult('move_helpers.pl').
:- consult('game.pl').

test_valid_moves_final_1:- valid_moves(state(0, 'H', 'H', 1, [['r',' ']]), ListOfMoves), length(ListOfMoves,1), member(move(0-0,1-0),ListOfMoves).

test_valid_moves_final_2:- valid_moves(state(0, 'H', 'H', 1, [['r',' '],[' ',' ']]), ListOfMoves), length(ListOfMoves,3), member(move(0-0,1-0),ListOfMoves), member(move(0-0,1-1),ListOfMoves), member(move(0-0,0-1),ListOfMoves),!.


test_move_final_1:-move(state(0, 'H', 'H', 1, [['r',' ',' ']]), move(0-0,2-0),state(0, 'H', 'H', 1, [['x',' ','r']])).


test_move_final_2(M):-move(state(0, 'H', 'H', 1, [['r',' ']]), move(0-0,1-0),state(1, 'H', 'H', 1, [['x',' ']])).






test1( ListOfMoves):- S=state(0, 'H', 'H', 1, [[' ',' ',' ',' ',' ',' '],[' ',' ',' ',' ',' ',' '],[' ',' ',' ',' ',' ',' '],[' ',' ','r',' ',' ',' '],[' ',' ',' ',' ',' ',' '],[' ',' ',' ',' ',' ',' ']]),valid_moves(S, ListOfMoves).


test2(ListOfMoves):- valid_moves(state(0, 'H', 'H', 1, [['r',' ']]), ListOfMoves).


test3(Elem):-Board= [['r',' ']],
    length(Board,Len),
    Len2 is Len-1,
    between(0,Len2,Y),
    nth0(Y,Board,Line),

    nth0(Y,Board,Line),
    length(Line,LLen),
    LLen2 is LLen-1,
    between(0,LLen2,X),

    nth0(X,Line,Elem).


test4(Elem):-Board= [['r',' ']],get_board_position(0-0,Board,Elem).

test5(Elem):-Board= [['r',' ']],explore_direction(Board,0-0,0-0,(1)-0,Elem).



test6(Elem):-Board= [['r',' ']],explore_space(0-0,Board,Elem).



test(M):- merge_moves([[move(0-0,1-0)],[],[],[]],M).