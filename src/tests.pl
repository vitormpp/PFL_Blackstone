
:- consult('init_form.pl').
:- consult('display_game_helpers.pl').
:- consult('valid_moves_helpers.pl').
:- consult('move_helpers.pl').
:- consult('game.pl').
test1:- state(0, 'H', 'H', 1, [[' ',' ',' ',' ',' ',' '],[' ',' ',' ',' ',' ',' '],[' ',' ',' ',' ',' ',' '],[' ',' ','r',' ',' ',' '],[' ',' ',' ',' ',' ',' '],[' ',' ',' ',' ',' ',' ']]).


test2:- valid_moves(state(0, 'H', 'H', 1, [['r',' ']]), ListOfMoves), member(move(0-0,1-0),ListOfMoves).



