
:- consult('init_form.pl').
:- consult('display_game_helpers.pl').
:- consult('valid_moves_helpers.pl').
:- consult('move_helpers.pl').
:- consult('game.pl').

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