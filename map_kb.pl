% ==========================================
% KNOWLEDGE BASE: BERMUDA MAP FACTS
% Format: connected(Node_A, Node_B, Distance).
% ==========================================

% --- Northern Sector ---
connected('Shipyard', 'Bullseye', 150).
connected('Shipyard', 'Mill', 300).
connected('Shipyard', 'Plantation', 250).
connected('Shipyard', 'Riverside', 200).
connected('Bullseye', 'Graveyard', 50).
connected('Graveyard', 'Observatory', 150).
connected('Graveyard', 'Katulistiwa', 200).


% --- Western Sector ---
connected('Observatory', 'Hangar', 200).
connected('Hangar', 'Clock Tower', 150).
connected('Hangar', 'Rim Nam Village', 250).
connected('Rim Nam Village', 'Clock Tower', 300).
connected('Rim Nam Village', 'Factory', 200).

% --- Central Sector ---
connected('Katulistiwa', 'Bimasakti Strip', 150).
connected('Katulistiwa', 'Hangar', 175).
connected('Bimasakti Strip', 'Plantation', 200).
connected('Plantation', 'Riverside', 100).
connected('Bimasakti Strip', 'Peak', 250).
connected('Bimasakti Strip', 'Clock Tower', 200).
connected('Peak', 'Mill', 250).
connected('Peak', 'Pochinok', 200).
connected('Peak', 'Kota Tua', 250).
connected('Peak', 'Riverside', 200).
connected('Clock Tower', 'Peak', 150).
connected('Katulistiwa', 'Plantation', 200).

% --- Eastern Sector ---
connected('Riverside', 'Mill', 150).
connected('Mill', 'Keraton', 150).
connected('Keraton', 'Cape Town', 100).
connected('Cape Town', 'Kota Tua', 200).
connected('Cape Town', 'Sentosa', 350).
connected('Kota Tua', 'Sentosa', 300).
connected('Kota Tua', 'Pochinok', 200).
connected('Pochinok', 'Sentosa', 250).
connected('Sentosa', 'Mars Electric', 250).

% --- Southern Sector ---
connected('Clock Tower', 'Factory', 150).
connected('Factory', 'Pochinok', 150).
connected('Factory', 'Mars Electric', 250).
connected('Pochinok', 'Mars Electric', 200).


% ==========================================
% RULES: MOVEMENT AND DYNAMIC CONSTRAINTS
% ==========================================

% 1. Bidirectional Movement
route(X, Y, Distance) :- connected(X, Y, Distance).
route(X, Y, Distance) :- connected(Y, X, Distance).

% 2. Dynamic Obstacles (Injected by Python at runtime)
:- dynamic red_zone/1.
:- dynamic enemy_area/1.

% 3. Node Validation (Only travel if NOT a red zone AND NOT an enemy area)
valid_node(Node) :- 
    \+ red_zone(Node), 
    \+ enemy_area(Node).

% 4. Legal Step (Check connection and validation)
legal_step(Start, Next, Distance) :-
    route(Start, Next, Distance),
    valid_node(Next).


% ==========================================
% AI SEARCH ENGINE: PATHFINDING ALGORITHM
% ==========================================

% Base case for travel: We have reached the Target.
% [FIX APPLIED]: Just reverse the list, don't add the Current node twice.
travel(Current, Current, Visited, FinalPath, 0) :-
    reverse(Visited, FinalPath).

% Recursive step for travel: Find a legal step, ensure we haven't visited it, and keep moving.
travel(Current, Target, Visited, FinalPath, TotalDist) :-
    legal_step(Current, Next, DistToNext),
    \+ member(Next, Visited), % Prevents infinite loops
    travel(Next, Target, [Next|Visited], FinalPath, RestDist),
    TotalDist is DistToNext + RestDist.

% Wrapper rule: Initializes the Visited list and validates the Start node.
% [FIX APPLIED]: Starts the Visited list with the Start node so it isn't skipped.
find_path(Start, End, Path, TotalDistance) :-
    valid_node(Start),
    travel(Start, End, [Start], Path, TotalDistance).

% OPTIMIZATION: Finds ALL possible valid paths, sorts them by distance, and returns the shortest.
shortest_path(Start, End, OptimalPath, MinDistance) :-
    setof([Dist, Path], find_path(Start, End, Path, Dist), [[MinDistance, OptimalPath]|_]).