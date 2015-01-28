%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                              %
%         276 Introduction to Prolog           %
%                                              %
%         Coursework 2014-15 (crossings)       %
%                                              %
%         Exercise 2                           %
%                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% ------------  (utilities) DO NOT EDIT



forall(P,Q) :- \+ (P, \+ Q).



% The following might be useful for testing.
% You may edit it if you want to adjust
% the layout. DO NOT USE it in your submitted code.

write_list(List) :-
  forall(member(X, List),
         (write('  '), write(X), nl)
        ).


% solutions for testing 

solution([f+g,f,f+w,f+g,f+c,f,f+b,f,f+g]).
solution([f+g,f,f+c,f+g,f+w,f,f+b,f,f+g]).
solution([f+g,f,f+b,f,f+w,f+g,f+c,f,f+g]).
solution([f+g,f,f+b,f,f+c,f+g,f+w,f,f+g]).


%% --------- END (utilities)



% ------ geography

opp(n,s).
opp(s,n).


% --------------------- succeeds/1 and journey/3

succeeds(Sequence) :-
   initial(Initial),
   journey(Initial, [], Sequence).
    

journey(State, _, []) :-
   goal(State).

journey(State, History, [Move|Rest]) :-
   \+ goal(State),   % can be omitted
   crossing(State, Move, Next),
   safe_state(Next),
   \+ visited(Next, History),
   journey(Next, [State|History], Rest).



% ---------------------- initial/1

initial([loc(f)=n, loc(w)=n, loc(g)=n, loc(c)=n, loc(b)=n]).


%% ------ Add your code to this file here.

%% Step 1

goal(State) :-
   length(State, 5),
   member(loc(f)=s,State),
   member(loc(w)=s,State),
   member(loc(c)=s,State),
   member(loc(g)=s,State),
   member(loc(b)=s,State).

safe_state(List) :- \+ unsafe_state(List).
unsafe_state([]) :- false.
unsafe_state([H|T]) :- check_farmer_north([H|T])-> check_bank([H|T],s); check_bank([H|T],n).

check_farmer_north([H|T]) :- member(loc(f)=n,[H|T]).
check_bank([H|T],B) :- member(loc(w)=B,[H|T]), member(loc(g)=B,[H|T]).
check_bank([H|T],B) :- member(loc(c)=B,[H|T]), member(loc(g)=B,[H|T]).

visited(State, History) :- member(State, History).

%% Step 2

select_replace(X,[X|[]], Y,[]) :- true.
select_replace(X,[], Y,[H|T]) :- false.
select_replace(X,[H|T], Y,[]) :- false.
select_replace(X,[], Y,[]) :- false.
select_replace(X,[H1|T1], Y,[H2|T2]) :-
   X = H1, compare([Y|T1],[H2|T2]);
   H1 = H2, select_replace(X,T1,Y,T2);
   false.

compare([],[]) :- true.
compare([H|T],[]) :- false.
compare([],[H|T]) :- false.
compare([H1|T1],[H2|T2]) :- 
   H1 = H2, compare(T1,T2);
   false.

%% Step 3

crossing(State, f, Next) :- 
check_farmer_north(State)-> select_replace(loc(f)=n, State, loc(f)=s, Next);select_replace(loc(f)=s, State, loc(f)=n, Next).

crossing(State, f+Thing, Next) :- check_farmer_north(State)->member(loc(Thing)=n,State),crossing2(State, f+Thing, Next);member(loc(Thing)=s,State),crossing3(State, f+Thing, Next).

crossing2(State, f+Thing, Next) :- Thing \= f,crossing_help1(State, Thing, Next).
crossing3(State, f+Thing, Next) :- Thing \= f,crossing_help2(State, Thing, Next).
crossing_help1(State, Thing, Next) :- select_replace(loc(Thing)=n, State, loc(Thing)=s, Next1),select_replace(loc(f)=n, Next1, loc(f)=s, Next).
crossing_help2(State, Thing, Next) :- select_replace(loc(Thing)=s, State, loc(Thing)=n, Next1),select_replace(loc(f)=s, Next1, loc(f)=n, Next).




