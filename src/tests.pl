
:- consult('init_form.pl').
:- consult('display_game_helpers.pl').
:- consult('move_helpers.pl').
:- consult('game.pl').

test_valid_moves_final_1:- valid_moves(state(0, player(h,'r'), player(h,'b'), 1, [['r',' ']]), ListOfMoves), length(ListOfMoves,1), member(move(0-0,1-0),ListOfMoves).

test_valid_moves_final_2:- valid_moves(state(0, player(h,'r'), player(h,'b'), 1, [['r',' '],[' ',' ']]), ListOfMoves), length(ListOfMoves,3), member(move(0-0,1-0),ListOfMoves), member(move(0-0,1-1),ListOfMoves), member(move(0-0,0-1),ListOfMoves),!.



test_valid_moves_final_3:- valid_moves(state(0, player(h,'r'), player(h,'b'), 1, [['r',' ',' '],['b',' ',' ']]), ListOfMoves),write(ListOfMoves), length(ListOfMoves,3), member(move(0-0,1-0),ListOfMoves), member(move(0-0,1-1),ListOfMoves), member(move(0-0,2-0),ListOfMoves),!.


test_move_final_1:-move(state(0, player(h,'r'), player(h,'b'), 1, [['r',' ',' ']]), move(0-0,2-0),state(1, player(h), player(h), 1, [['x',' ','r']])).

test_move_final_2:-move(state(0, player(h,'r'), player(h,'b'), 1, [['r',' ']]), move(0-0,1-0),state(1, player(h), player(h), 1, [['x',' ']])).

test_move_3_helper:-move(state(1, player(h,'r'), player(h,'b'), 1, [['x','x',' '],['x','b','r']]), move(1-1,2-0),State),write(State).
test_move_final_3:-move(state(1, player(h,'r'), player(h,'b'), 1, [['x','x',' '],['x','b','r']]), move(1-1,2-0),state(1, player(h), player(h), 1, [['x','x',' '],['x','x',' ']])).

test_remove_dead_pieces:-remove_dead_pieces(1,[['x','x','b'],['x','x','r']], NBoard),write(NBoard).
test_remove_dead_pieces_final_1:-remove_dead_pieces(1,[['x','x','b'],['x','x','r']], [['x','x',' '],['x','x',' ']]). %is failing. It shouldn't fail!!!
test_get_dead_pieces_helper:-get_dead_pieces(1,[['x','x','b'],['x','x','r']], Pieces),write(Pieces).

test_display_final_1:- display_game(state(0, player(h,'r'), player(h,'b'), 1, [['r',' ']])).
test_display_final_2:- display_game(state(0, player(h,'r'), player(h,'b'), 1, [['r',' '],[' ','x']])).




test_move_helper_1(R):-create_new_board('r',[['r',' ']],move(0-0,1-0), R).
test_move_helper_2(R):-get_dead_pieces(0,[['x','r']],R).
test_move_helper_3(R):-remove_dead_pieces(0,[['x','r']], R).


test_choose_move_final_1:-choose_move(state(0, player(h,'r'), player(h,'b'), 1, [['r',' ']]),_,move(0-0,1-0)).
test_choose_move_final_2:-choose_move(state(0, player(c-1,'r'), player(h,'b'), 1, [['r',' ']]),_,move(0-0,1-0)),!.
test_choose_move_helper:-choose_move(state(1, player(h,'r'), player(h,'b'), 1, [['x',' ',' '],['b','r',' ']]),_,Move),write(Move).


test_loop_final_1:- gameloop(state(0, player(h,'r'), player(h,'b'), 1, [['r',' ',' '],['b',' ',' ']])).

test_loop_final_2:- gameloop(state(0, player(h,'r'), player(c-1,'b'), 1, [['r',' ',' '],['b',' ',' ']])).


test_piece_is_surrounded_final_1:- piece_is_surrounded(0-1,[['x','x',' '],['b','r',' ']]).

test_get_board_position_final_1:- between(0,1,Y), between(0,2,X), get_board_position(X-Y,[['x',' ',' '],['b','r',' ']],Elem),write(Elem).


test_game_over_final_1:- game_over(state(1, player(h,'r'), player(h,'b'), 1, [['x','x',' '],['x','x','x']]),'x').