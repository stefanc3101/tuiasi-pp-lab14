% ============================================================
% family.pl — Baza de cunoștințe despre relații de familie
% ============================================================

% --- Fapte: relația tată ---
tatal(ilie, vasale).
tatal(popa, vasale).
tatal(george, ilie).
tatal(maria, ilie).
tatal(petru, popa).
tatal(vasilica, cobelea).
tatal(dana, pavel).

% --- Fapte: relația mamă ---
mama(george, vasilica).
mama(maria, vasilica).
mama(vasilica, diana).
mama(petru, dana).
mama(matcu, dana).
mama(dana, elena).
mama(ilie, elena).
mama(popa, elena).

% --- Fapte: genul persoanelor ---
barbat(george). barbat(petru). barbat(ilie). barbat(popa).
barbat(vasale). barbat(cobelea). barbat(pavel).

femeie(maria). femeie(matcu). femeie(vasilica). femeie(ileana).
femeie(dana). femeie(diana). femeie(elena).

% --- Fapte: relația de soți ---
sot(vasilica, ilie).
sot(dana, popa).
sot(ileana, petru).

% --- Fapte: relația de unchi (explicite) ---
unchi(george, popa).
unchi(petru, ilie).

% --- Reguli: frate și soră ---
frate(X, Y) :- tatal(X, A), tatal(Y, A), barbat(X), barbat(Y), X \= Y.
frate(X, Y) :- frate(Y, X), barbat(X), barbat(Y).

sora(X, Y) :- tatal(X, A), tatal(Y, A), femeie(Y), X \= Y.

% --- Reguli: mătușă ---
matusa(X, Y) :- sot(Y, Z), frate(Z, W), Z \= W, tatal(X, W).

% --- Reguli: bunic și bunică ---
bunicul(X, Y) :- barbat(Y), tatal(X, W), tatal(W, Y).
bunicul(X, Y) :- barbat(Y), mama(X, W), tatal(W, Y).

bunica(X, Y) :- femeie(Y), tatal(X, W), mama(W, Y).
bunica(X, Y) :- femeie(Y), mama(X, W), mama(W, Y).

% ============================================================
% Tema 1: Relații extinse de familie
% ============================================================

% Regula de bază ajutătoare: Părinte (abstractizează mama și tatăl)
parinte(Copil, Parinte) :- tatal(Copil, Parinte).
parinte(Copil, Parinte) :- mama(Copil, Parinte).

% Văr(X, Y) - X este văr cu Y dacă părinții lor sunt frați/surori
var(X, Y) :-
    parinte(X, P1),
    parinte(Y, P2),
    % Părinții pot fi frați sau surori
    (frate(P1, P2) ; frate(P2, P1) ; sora(P1, P2) ; sora(P2, P1)),
    X \= Y.

% Nepot(X, Y)
% Cazul 1: Nepot față de bunic/bunică (Părintele lui X are un părinte care este Y)
nepot(X, Y) :-
    parinte(X, P),
    parinte(P, Y).

% Cazul 2: Nepot față de unchi/mătușă (Y este fratele/sora părintelui lui X)
nepot(X, Y) :-
    parinte(X, P),
    (frate(P, Y) ; frate(Y, P) ; sora(P, Y) ; sora(Y, P)).