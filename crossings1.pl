%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                              %
%         276 Introduction to Prolog           %
%                                              %
%         Coursework 2014-15 (crossings)       %
%                                              %
%         Exercise 1                           %
%                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% ------------  (utilities) DO NOT EDIT



forall(P,Q) :- \+ (P, \+ Q).


app_select(X,List,Remainder) :-
  append(Front, [X|Back], List),
  append(Front, Back, Remainder).


% The following might be useful for testing.
% You may edit it if you want to adjust
% the layout. DO NOT USE it in your submitted code.

write_list(List) :-
  forall(member(X, List),
         (write('  '), write(X), nl)
        ).

write_state(N-S) :-
write('\nbegin\n'),
write_list(N),
write('\n---\n'),
write_list(S),
write('\nend\n').

% solutions for testing 

solution([f+g,f,f+w,f+g,f+c,f,f+b,f,f+g]).
solution([f+g,f,f+c,f+g,f+w,f,f+b,f,f+g]).
solution([f+g,f,f+b,f,f+w,f+g,f+c,f,f+g]).
solution([f+g,f,f+b,f,f+c,f+g,f+w,f,f+g]).


%% --------- END (utilities)



% --------------------- succeeds/1 and journey/3

succeeds(Sequence) :-
   initial(Initial),
   journey(Initial, [], Sequence).
    

journey(State, _, []) :-
   goal(State).

journey(State, History, [Move|Rest]) :-
   \+ goal(State),   % can be omitted
   crossing(State, Move, Next),
   (safe_state(Next)->true;false),
   \+ visited(Next, History),
   journey(Next, [State|History], Rest).



% ---------------------- initial/1

initial([f,w,g,c,b]-[]).


%% ------ Add your code to this file here.

%% ----- Step 1

safe_bank([]).
safe_bank([H|[]]).
safe_bank([f|T]).
safe_bank(Bank) :- \+ member(f,Bank),\+ unsafe_bank(Bank).

unsafe_bank(Bank) :- 
  member(w,Bank), member(g,Bank).
unsafe_bank(Bank) :-
  member(g,Bank), member(c,Bank).

%% ----- Step 2

safe_state([]-[]):- false.
safe_state(N-[]).
safe_state([]-S).
safe_state(N-S):- 
   safe_bank(N),
   safe_bank(S).

%% ----- Step 3

equiv(N1-S1, N2-S2):- equiv_bank(N1, N2), equiv_bank(S1,S2). 

equiv_bank(B1,B2) :- sort(B1, X) ,sort(B2, X).

%% ----- Step 4

goal(N-[F|T]) :- 
   length(N, 0),
   F = f, 
   length(T, 4), 
   member(g,T),
   member(w,T),
   member(b,T),
   member(c,T).

%% ----- Step 5

visited(State, History) :- member(State1, History), equiv(State, State1).

%% ----- Step 6

select(X,[X|[]],[]) :- true.
select(X,[],[H|T]) :- false.
select(X,[H|T],[]) :- false.
select(X,[],[]) :- false.
select(X,[H1|T1],[H2|T2]) :-
   X = H1, compare(T1,[H2|T2]);
   H1 = H2, select(X,T1,T2);
   false.

compare([],[]) :- true.
compare([H|T],[]) :- false.
compare([],[H|T]) :- false.
compare([H1|T1],[H2|T2]) :- 
   H1 = H2, compare(T1,T2);
   false.

%% ----- Step 7

crossing(N-S, X, Next) :-
   member(f,N) -> crossingN(N-S, X, Next);
   crossingS(N-S, X, Next).

crossingN(N-S, f, Next) :- crossing_helpN2(N,S,Next).
crossingN(N-S, f+Thing, N1-S1) :- member(Thing,N), Thing \= f, crossing_helpN(N,S,Thing,N1,S1).
crossing_helpN([f|Rest],S,Thing,Rest2,[f|S2]) :- select(Thing, Rest, Rest2), help2([Thing|S],S2).

help2(X,X).
crossing_helpN2([f|Rest],S,Rest-[f|S]).


crossingS(N-S, f, Next) :- crossing_helpS2(N,S,Next).
crossingS(N-S, f+Thing, N1-S1) :- member(Thing, S), Thing \= f, crossing_helpS(N,S,Thing,N1,S1).
crossing_helpS(N,[f|Rest],Thing,[f|N2],Rest2) :- select(Thing,Rest,Rest2), help2([Thing|N],N2).
crossing_helpS2(N,[f|Rest],[f|N]-Rest).

%% ----- Step 8

count_items(List, Stats) :-
   count_items(List, [], Stats).

count_items([], Accum, Stats) :-
   compare(Accum, Stats).
count_items([H|T], Accum, Stats) :-
   member((H,_), Accum) -> added(H, Accum, NewAccum1), count_items(T, NewAccum1, Stats);
   inserted(H, Accum, NewAccum2), count_items(T, NewAccum2, Stats).

added(E, [H|T], []) :- false.
added(E, [(X,N)|T1], [H|T2]) :-
   E = X, M is N+1, compare([(X,M)|T1], [H|T2]);
   (X,N) = H, added(E, T1, T2).

inserted(E, Accum, NewAccum) :-
   append(Accum, [(E,1)], Result), compare(Result, NewAccum).

%% ----- Step 9

g_journeys(Seq,N) :- succeeds(Seq), scount_items(Seq, Stat), member(f+N, Seq).
