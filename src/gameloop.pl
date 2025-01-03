% play_without_preamble/0 is the main entry point of the game.
play_without_preamble:-	
    input_form(GameConfig),
    initial_state(GameConfig, GameState),
    gameloop(GameState).

% read_play_again/0 reads the user input to check if the user wants to play again.
read_play_again:-
    get_char('y'),
    play_without_preamble,!. 
read_play_again:- 
    write('Ending game!\n').

% checkMainLoopIteration(+GameState)
% checkMainLoopIteration/1 checks if the game is over and displays the winner.
checkMainLoopIteration(NewState):-
    game_over(NewState,Winner),
    display_game(NewState), 
    write('Game over: winner is '), 
    write(Winner),
    write('!\n'),!,
    write('Do you want to play again?(y/n)\n'),
    read_play_again.

checkMainLoopIteration(NewState):-!, 
gameloop(NewState).

% gameloop(+GameState)
% gameloop/1 is the main loop of the game.
% It displays the game, asks for a move, applies the move and checks if the game is over.
gameloop(state(TurnNumber, Player1, Player2, Variant, Board) ):-
    display_game(state(TurnNumber, Player1,Player2, Variant,Board)),!,
    choose_move(state(TurnNumber, Player1,Player2, Variant,Board),0,Move),!,%assume choose move return valid move
    move(state(TurnNumber, Player1,Player2, Variant,Board),Move,NewState),!,
    checkMainLoopIteration(NewState).
    %todo: the number should be the level of difficulty and should come from gamestate...

    
    