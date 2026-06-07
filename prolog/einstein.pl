% ============================================================
% einstein.pl — Problema lui Einstein (Zebra Puzzle)
% Cine deține peștele?
% ============================================================
%
% Există 5 case de culori diferite, așezate în linie (pozițiile 1-5).
% Fiecare casă este locuită de o persoană de naționalitate diferită.
% Fiecare persoană bea o anumită băutură, fumează un anumit brand
% de țigări și deține un anumit animal.
%
% Fiecare casă este reprezentată ca:
%   house(Culoare, Nationalitate, Bautura, Animal, Tigari)

% ============================================================

% next_to(X, Y, List) — X și Y sunt case vecine în lista List
next_to(X, Y, [X,Y|_]).
next_to(X, Y, [Y,X|_]).
next_to(X, Y, [_|T]) :- next_to(X, Y, T).

% left_of(X, Y, List) — X este imediat la stânga lui Y în List
left_of(X, Y, [X,Y|_]).
left_of(X, Y, [_|T]) :- left_of(X, Y, T).

% ============================================================
% solution(Houses)
% Instanțiază lista celor 5 case și verifică toate cele 15 constrângeri.
% ============================================================

solution(Houses) :-
    Houses = [house(_,_,_,_,_), house(_,_,_,_,_), house(_,_,_,_,_),
              house(_,_,_,_,_), house(_,_,_,_,_)],
    % Indiciu 8: persoana din mijloc bea lapte
    Houses = [_, _, house(_, _, lapte, _, _), _, _],
    % Indiciu 9: norvegianul e primul
    Houses = [house(_, norvegian, _, _, _) | _],
    % Indiciu 1: britanicul locuiește în casa roșie
    member(house(rosu, britanic, _, _, _), Houses),
    % Indiciu 2: suedezul ține un câine
    member(house(_, suedez, _, caine, _), Houses),
    % Indiciu 3: danezul bea ceai
    member(house(_, danez, ceai, _, _), Houses),
    % Indiciu 4: Casa verde este imediat la stânga casei albe
    left_of(house(verde, _, _, _, _), house(alb, _, _, _, _), Houses),
    % Indiciu 5: Proprietarul casei verzi bea cafea
    member(house(verde, _, cafea, _, _), Houses),
    % Indiciu 6: Persoana care fumează Pall Mall ține o pasăre
    member(house(_, _, _, pasare, pall_mall), Houses),
    % Indiciu 7: Proprietarul casei galbene fumează Dunhill
    member(house(galben, _, _, _, dunhill), Houses),
    % Indiciu 10: Persoana care fumează Blend locuiește lângă cea cu pisica
    next_to(house(_, _, _, _, blend), house(_, _, _, pisica, _), Houses),
    % Indiciu 11: Omul cu calul locuiește lângă cel care fumează Dunhill
    next_to(house(_, _, _, cal, _), house(_, _, _, _, dunhill), Houses),
    % Indiciu 12: Persoana care fumează BlueMaster bea bere
    member(house(_, _, bere, _, bluemaster), Houses),
    % Indiciu 13: Germanul fumează Prince
    member(house(_, german, _, _, prince), Houses),
    % Indiciu 14: Norvegianul locuiește lângă casa albastră
    next_to(house(_, norvegian, _, _, _), house(albastru, _, _, _, _), Houses),
    % Indiciu 15: Persoana care fumează Blend are un vecin care bea apă
    next_to(house(_, _, _, _, blend), house(_, _, apa, _, _), Houses),
    % Ne asigurăm că cineva chiar are peștele (ca să fie instanțiat un animal cu 'peste')
    member(house(_, _, _, peste, _), Houses).

% Interogarea principală pe care o caută einstein.py
einstein(Owner) :-
    solution(Houses),
    member(house(_, Owner, _, peste, _), Houses).