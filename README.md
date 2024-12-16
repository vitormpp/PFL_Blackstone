# pfl_project_2
##TODO:
- move initial game state creation functions into a different file, for consistency's sake.
- value(GameState, Player, Value) . -> pls do this. actually, write it like this everywhere: value(GameState, _ , Value). Because the player variable won't be used anyway, as it si stored in the state. If the amount of parameters of the function wasn't predetermined, I would just put two. By the way: player 1 plays on even turns, player 2 plays on odd turns. Use mod 2. - actually, I made it so that the color codes are passed, to make it easier to interpret

- we need to improve the move predicate to iterate through valid moves, instead of gathering the valid moves in valid_moves... Basicallly, valid_moves should become :- findall move (STATE,X,NS). Even if we don't make this change, the move predicate should still be made to validate the input move. -> the verifying if it's valid now works and makes the move predicate "iterable", but valid moves wasn't changed

- add a verification that the board size is an even number 


Maybe we should have an "access tutorial" button/option somewhere.




to check if we're on linux so we can use special characters and colors, we can use:


:- prolog_flag(host_type,Flag),atom_chars(Flag, List), append(_,[ 'l','i','n','u','x'| _],List), (do things that should only happen on linux - the best way is to consult a special linux-only file, because special characters cause the thing on windows to crash even if they're not executed.).

By the way, this readme will need to be changed, because it is supposed to include actual information about our actual code.
