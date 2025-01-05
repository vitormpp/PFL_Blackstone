
:- consult('init_form.pl').
:- consult('display_game_helpers.pl').
:- consult('move_helpers.pl').
:- consult('game.pl').

/*
    File: tests.pl
    Description: This file contains the predicates that are used to test the game.
*/

test_valid_moves_final_1:- valid_moves(state(0, player(h,'r'), player(h,'b'), 1, [['r',' ']]), ListOfMoves), length(ListOfMoves,1), member(move(0-0,1-0),ListOfMoves).

test_valid_moves_final_2:- valid_moves(state(0, player(h,'r'), player(h,'b'), 1, [['r',' '],[' ',' ']]), ListOfMoves), length(ListOfMoves,3), member(move(0-0,1-0),ListOfMoves), member(move(0-0,1-1),ListOfMoves), member(move(0-0,0-1),ListOfMoves),!.

test_valid_moves_final_3:- valid_moves(state(0, player(h,'r'), player(h,'b'), 1, [['r',' ',' '],['b',' ',' ']]), ListOfMoves),write(ListOfMoves), length(ListOfMoves,3), member(move(0-0,1-0),ListOfMoves), member(move(0-0,1-1),ListOfMoves), member(move(0-0,2-0),ListOfMoves),!.

test_move_final_1:-move(state(1, player(h,'r'), player(h,'b'), 1, [['r',' ',' ']]), move(0-0,2-0),state(2, player(h,'r'), player(h,'b'), 1, [['x',' ','r']])).

test_move_final_2:-move(state(1, player(h,'r'), player(h,'b'), 1, [['r',' ']]), move(0-0,1-0),state(2, player(h,'r'), player(h,'b'), 1, [['x',' ']])).

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

test_loop_final_3:- gameloop(state(0, player(c-1,'r'), player(c-1,'b'), 1, [['r',' ',' '],['b',' ',' ']])).


test_piece_is_surrounded_final_1:- piece_is_surrounded(0-1,[['x','x',' '],['b','r',' ']]).



test_game_over_final_1:- game_over(state(1, player(h,'r'), player(h,'b'), 1, [['r','r',' '],['r','r','r']]),'r').
test_game_over_final_2:- game_over(state(1, player(h,'r'), player(h,'b'), 1, [['x','x',' '],['x','x','x']]),'r').
test_game_over_final_3:- game_over(state(2, player(h,'r'), player(h,'b'), 1, [['x','x',' '],['x','x','x']]),'r').

test_dead_pieces:-
    get_dead_pieces(1,[['b','r','x'],['x','x','x'],['x',' ',' ']],A),
    get_dead_pieces(2,[['b','r','x'],['x','x','x'],['x',' ',' ']],B), % 0-2 não pode aparecer na lista
    get_dead_pieces(3,[['b','r','x'],['x','x','x'],['x',' ',' ']],C),
    write(A),nl,
    write(B),nl,
    write(C),nl.

test_valid_moves:-
    valid_moves(state(1, player(h,'r'), player(h,'b'), 1, [['x','r',' '],[' ',' ','r']]), A),
    write(A), nl,
    valid_moves(state(1, player(h,'r'), player(h,'b'), 1, [['x',' ',' '],[' ','x','r']]), B),
    write(B), nl,
    valid_moves(state(1, player(h,'r'), player(h,'b'), 1, [['r','r',' ']]), C),
    write(C), nl.

test_between_1:-
    has_piece_between([['r','r',' ']], 0-0, 2-0).

test_between_2:-
    has_piece_between([['r'],['r'],[' ']], 0-0, 0-2).

test_between_3:-
    has_piece_between([['r',' ',' '],[' ','r',' '],[' ',' ',' ']], 0-0, 2-2).

test_value_1:-
    value(state(1,player(c-2,'r'),player(c-1,'b'),1,[['r','b',' '],[' ','r',' ']]),player(c-2,'r'),Value),
    write(Value),nl.

test_value_2:-
    value(state(1,player(c-2,'r'),player(c-1,'b'),1,[['b','x',' '],['x','x',' '], [' ',' ','r']]),player(c-2,'r'),Value),
    write(Value),nl.

test_read_number:- read_number(X), write('You wrote: '),write(X),nl.

test_minimax_1:-
    minimax(state(3,player(c-3,'r'),player(c-3,'b'),1,[['b','r',' '],['x',' ',' '],['b',' ',' ']]),1,player(c-3,'r'),Move),
    write('Final answer: '),write(Move),nl.

test_minimax_2:-
    minimax(state(3,player(c-3,'r'),player(c-3,'b'),1,[['b','r',' '],['x',' ',' '],['b',' ',' ']]),2,player(c-3,'r'),Move),
    write('Final answer: '),write(Move),nl.

test_minimax_3:-
    minimax(state(3,player(c-3,'r'),player(c-3,'b'),1,[['b','r',' '],['x',' ',' '],['b',' ',' ']]),3,player(c-3,'r'),Move),
    write('Final answer: '),write(Move),nl.

test_minimax_4:-
    minimax(state(3,player(c-3,'r'),player(c-3,'b'),1,[['b',' ',' '],[' ',' ',' '],[' ',' ','r']]),1,player(c-3,'r'),Move),
    write('Final answer: '),write(Move),nl.

test_minimax_5_2:-
    minimax(state(20,player(c-3,'r'),player(c-3,'b'),1,
        [
            [' ','x',' ','x',' ','r'],
            [' ','x',' ','x','x','x'],
            ['x','x','x','x','b',' '],
            [' ',' ','x','x','x','x'],
            ['x','x','x',' ','b','r'],
            [' ',' ','x',' ','x',' ']
        ]),
    2,player(c-3,'b'),Move),
    write('Final answer: '),write(Move),nl.

test_minimax_5_3:-
    minimax(state(20,player(c-3,'r'),player(c-3,'b'),1,
        [
            [' ','x',' ','x',' ','r'],
            [' ','x',' ','x','x','x'],
            ['x','x','x','x','b',' '],
            [' ',' ','x','x','x','x'],
            ['x','x','x',' ','b','r'],
            [' ',' ','x',' ','x',' ']
        ]),
    3,player(c-3,'b'),Move),
    write('Final answer: '),write(Move),nl.

test_minimax_5_4:-
    minimax(state(20,player(c-3,'r'),player(c-3,'b'),1,
        [
            [' ','x',' ','x',' ','r'],
            [' ','x',' ','x','x','x'],
            ['x','x','x','x','b',' '],
            [' ',' ','x','x','x','x'],
            ['x','x','x',' ','b','r'],
            [' ',' ','x',' ','x',' ']
        ]),
    4,player(c-3,'b'),Move),
    write('Final answer: '),write(Move),nl.

test_minimax_6_1:-
    minimax(state(20,player(c-3,'r'),player(c-3,'b'),1,
        [
            ['x','x','x','x','x','x'],
            ['x','x',' ','x','x','x'],
            ['x','x','b','x','x','x'],
            ['x','x',' ','x','x','x'],
            ['x',' ',' ',' ',' ','x'],
            ['x',' ',' ',' ','x','r']
        ]),
    1,player(c-3,'b'),Move),
    write('Final answer: '),write(Move),nl.

test_minimax_6_2:-
    minimax(state(20,player(c-3,'r'),player(c-3,'b'),1,
        [
            ['x','x','x','x','x','x'],
            ['x','x',' ','x','x','x'],
            ['x','x','b','x','x','x'],
            ['x','x',' ','x','x','x'],
            ['x',' ',' ',' ',' ','x'],
            ['x',' ',' ',' ','x','r']
        ]),
    2,player(c-3,'b'),Move),
    write('Final answer: '),write(Move),nl.

test_minimax_6_3:-
    minimax(state(20,player(c-3,'r'),player(c-3,'b'),1,
        [
            ['x','x','x','x','x','x'],
            ['x','x',' ','x','x','x'],
            ['x','x','b','x','x','x'],
            ['x','x',' ','x','x','x'],
            ['x',' ',' ',' ',' ','x'],
            ['x',' ',' ',' ','x','r']
        ]),
    3,player(c-3,'b'),Move),
    write('Final answer: '),write(Move),nl.

test_minimax_6_4:-
    minimax(state(20,player(c-3,'r'),player(c-3,'b'),1,
        [
            ['x','x','x','x','x','x'],
            ['x','x',' ','x','x','x'],
            ['x','x','b','x','x','x'],
            ['x','x',' ','x','x','x'],
            ['x',' ',' ',' ',' ','x'],
            ['x',' ',' ',' ','x','r']
        ]),
    3,player(c-3,'b'),Move),
    write('Final answer: '),write(Move),nl.

test_minimax_6_6:-
    minimax(state(20,player(c-3,'r'),player(c-3,'b'),1,
        [
            ['x','x','x','x','x','x'],
            ['x','x',' ','x','x','x'],
            ['x','x','b','x','x','x'],
            ['x','x',' ','x','x','x'],
            ['x',' ',' ',' ',' ','x'],
            ['x',' ',' ',' ','x','r']
        ]),
    6,player(c-3,'b'),Move),
    write('Final answer: '),write(Move),nl.

test_minimax_5_6:-
    minimax(state(20,player(c-3,'r'),player(c-3,'b'),1,
        [
            [' ','x',' ','x',' ','r'],
            [' ','x',' ','x','x','x'],
            ['x','x','x','x','b',' '],
            [' ',' ','x','x','x','x'],
            ['x','x','x',' ','b','r'],
            [' ',' ','x',' ','x',' ']
        ]),
    6,player(c-3,'b'),Move),
    write('Final answer: '),write(Move),nl.

test_valid_moves_1:-
    valid_moves(state(1,player(c-2,'r'),player(c-1,'b'),1,[[' ',' ',' '],[' ','r',' '],[' ',' ',' ']]),Moves),
    write('Final answer: '),write(Moves),nl.

test_minimax_1_1:-
    minimax_aux(state(3,player(c-3,'r'),player(c-3,'b'),1,[['b','r',' '],['x',' ',' '],['b',' ',' ']]),0,player(c-3,'r'),-1000,1000,Value,Move),
    write(Value),nl,
    write(Move),nl.

test_minimax_1_2:-
    minimax_aux(state(3,player(c-3,'r'),player(c-3,'b'),1,[['b','r',' '],['x',' ','r'],['b',' ','r']]),1,player(c-3,'r'),-1000,1000,_,Move),
    write(Move),nl.

test_update_best_1:-
    update_best(state(1,player(c-2,'r'),player(c-1,'b'),1,[['r',' ',' ']]),1,player(c-2,'r'),[],10,7,move(0-0,1-0),NewAlpha,Move),
    write(NewAlpha),nl,
    write(Move),nl.
