# pfl_project_2
##TODO:
- move initial game state creation functions into a different file, for consistency's sake.
- value(GameState, Player, Value) . -> pls do this. actually, write it like this everywhere: value(GameState, _ , Value). Because the player variable won't be used anyway, as it si stored in the state. If the amount of parameters of the function wasn't predetermined, I would just put two. By the way: player 1 plays on even turns, player 2 plays on odd turns. Use mod 2. 

Maybe we should have an "access tutorial" button/option somewhere.




to check if we're on linux so we can use special characters and colors, we can use:


:- prolog_flag(host_type,Flag),atom_chars(Flag, List), append(_,[ 'l','i','n','u','x'| _],List), (do things that should only happen on linux - the best way is to consult a special linux-only file, because special characters cause the thing on windows to crash even if they're not executed.).

By the way, this readme will need to be changed, because it is supposed to include actual information about our actual code.
