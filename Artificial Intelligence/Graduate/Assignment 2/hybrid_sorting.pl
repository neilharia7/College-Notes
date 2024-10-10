:- dynamic random_list/2.
:- dynamic sort_time/3.

/* randomList: Generate a random list of N elements */
randomList(N, List) :-
    length(List, N),
    maplist(random_element, List).

/* random_element: Generate a random element between 1 and 1000 */
random_element(X) :-
    random(1, 1001, X).

/* generate_and_assertz_random_list: Create 50 random lists and assert them */
generate_and_assertz_random_list :-
    forall(between(1, 50, I),
           (randomList(100, List),
            assertz(random_list(I, List)))).

/* swap: swap the first two elements if they are not in order */
swap([X,Y|T], [Y,X|T]) :-
    X > Y, !.

/* swap: swap elements in the tail*/
swap([H|T], [H|T1]) :-
    swap(T, T1).

/* bubbleSort: repeatedly apply swap operation until no swaps are needed,
 * sorting the list */
bubbleSort(L, SL) :-
    swap(L, L1), % at least one swap is needed
    !,
    bubbleSort(L1, SL).
bubbleSort(L, L) :- % here, the list is already sorted
	ordered(L). % validate

/* ordered: checks if a list is sorted in non-decreasing order */
ordered([]).
ordered([_X]).
ordered([H1, H2|T]) :-
    H1 =< H2,
    ordered([H2|T]).

/* insert: inserts an element E into the sorted list SL to get a new sorted list SLE */
insert(X, [], [X]).
insert(E, [H|T], [E, H|T]) :-
    E =< H,
    !.
insert(E, [H|T], [H|T1]) :-
    insert(E, T, T1).

/* insertionSort: sorts the list by recursively inserting elements into a sorted sublist */
insertionSort([], []).
insertionSort([H|T], SORTED) :-
    insertionSort(T, T1),
    insert(H, T1, SORTED),
    ordered(SORTED).

/* mergeSort: sorts the list by recursively dividing and merging */
mergeSort([], []).
mergeSort([X], [X]) :- !.
mergeSort(List, Sorted) :-
    split_in_half(List, L1, L2),
    mergeSort(L1, SL1),
    mergeSort(L2, SL2),
    merge(SL1, SL2, Sorted),
    ordered(Sorted).

% intDiv: Integer division helper
intDiv(N, N1, R) :- R is div(N, N1).

% split_in_half: Split a list into two halves
split_in_half([], _, _):-!, fail.
split_in_half([X], [], [X]).
split_in_half(L, L1, L2) :-
    length(L, N),         % Get the length of the list
    intDiv(N, 2, Mid),    % Calculate the middle index u	sing intDiv
    length(L1, Mid),      % Set the length of the first half
    append(L1, L2, L).    % Split the list into two halves

/* merge: merges two sorted lists into a single sorted list */
merge([], L, L). % if the first list is empty, the result is the second list
merge(L, [], L). % if the second list ist empty, the result is the first list
merge([H1|T1], [H2|T2], [H1|Merged]) :-
    H1 =< H2,
    merge(T1, [H2|T2], Merged).
merge([H1|T1], [H2|T2], [H2|Merged]) :-
    merge([H1|T1], T2, Merged).

/* split for quickSort: splits the list into elements smaller and bigger than a pivot */
split(_, [], [], []).
split(X, [H|T], [H|SMALL], BIG) :-
    H =< X,
    split(X, T, SMALL, BIG).
split(X, [H|T], SMALL, [H|BIG]) :-
    X < H,
    split(X, T, SMALL, BIG).

/* quickSort: sorts the list by partitioning around a pivot */
quickSort([], []).
quickSort([H|T], LS) :-
    split(H, T, SMALL, BIG),
    quickSort(SMALL, S),
    quickSort(BIG, B),
    append(S, [H|B], LS),
    ordered(LS).

/* hybridSort: uses a small-scale algorithm for lists below a threshold, and a large-scale algorithm otherwise */
hybridSort(LIST, SMALLALG, BIGALG, THRESHOLD, SLIST) :-
    length(LIST, N),
    (   N =< THRESHOLD
    ->  call(SMALLALG, LIST, SLIST)
    ;   (   BIGALG == mergeSort
        ->  split_in_half(LIST, L1, L2),
            hybridSort(L1, SMALLALG, BIGALG, THRESHOLD, SL1),
            hybridSort(L2, SMALLALG, BIGALG, THRESHOLD, SL2),
            merge(SL1, SL2, SLIST)
        ;   LIST = [H|T],
            split(H, T, L, R),
            hybridSort(L, SMALLALG, BIGALG, THRESHOLD, SL),
            hybridSort(R, SMALLALG, BIGALG, THRESHOLD, SR),
            append(SL, [H|SR], SLIST)
        )
    ),
    ordered(SLIST). % validate

% run_sorting: Run sorting algorithms and time their execution
run_sorting :-
    forall(random_list(I, List),
           (time_sort(bubbleSort, List, BubbleSortTime),
            time_sort(insertionSort, List, InsertionSortTime),
            time_sort(mergeSort, List, MergeSortTime),
            time_sort(quickSort, List, QuickSortTime),
            time_hybrid(bubbleSort, mergeSort, 5, List, HybridSort1Time),
            time_hybrid(insertionSort, mergeSort, 5, List, HybridSort2Time),
            time_hybrid(bubbleSort, quickSort, 5, List, HybridSort3Time),
            time_hybrid(insertionSort, quickSort, 5, List, HybridSort4Time),
            assertz(sort_time(I, bubbleSort, BubbleSortTime)),
            assertz(sort_time(I, insertionSort, InsertionSortTime)),
            assertz(sort_time(I, mergeSort, MergeSortTime)),
            assertz(sort_time(I, quickSort, QuickSortTime)),
            assertz(sort_time(I, hybrid1, HybridSort1Time)),
            assertz(sort_time(I, hybrid2, HybridSort2Time)),
            assertz(sort_time(I, hybrid3, HybridSort3Time)),
            assertz(sort_time(I, hybrid4, HybridSort4Time)))).

% time_sort: Calculate the CPU time for individual algorithms
time_sort(Algorithm, List, T) :-
    statistics(cputime, T0),
    call(Algorithm, List, _),
    statistics(cputime, T1),
    T is T1 - T0,
	format('CPU time: ~w ~w ~n', [Algorithm, T]).

% time_hybrid: Calculate the CPU time for hybrid algorithms
time_hybrid(SmallAlg, BigAlg, Threshold, List, T) :-
    statistics(cputime, T0),
    hybridSort(List, SmallAlg, BigAlg, Threshold, _),
    statistics(cputime, T1),
    T is T1 - T0,
	format('Hybrid Algo ~w/~w CPU time: ~w ~n', [SmallAlg, BigAlg, T]).

% analyze_results: Analyze results
analyze_results :-
    findall(Alg, (sort_time(_, Alg, _), Alg \= hybrid1, Alg \= hybrid2, Alg \= hybrid3, Alg \= hybrid4), Algorithms),
    list_to_set(Algorithms, UniqueAlgorithms),
    format('--------------------------------------------------'),
    forall(member(Alg, UniqueAlgorithms),
           (findall(Time, sort_time(_, Alg, Time), Times),
            average(Times, Avg),
            format('Average time for ~w: ~6f seconds~n', [Alg, Avg]))),
    forall(between(1, 4, I),
           (atom_concat(hybrid, I, HybridAlg),
            findall(Time, sort_time(_, HybridAlg, Time), Times),
            average(Times, Avg),
            format('Average time for ~w: ~6f seconds~n', [HybridAlg, Avg]))).

% average: taking the average of the times
average(List, Avg) :-
    sum_list(List, Sum),
    length(List, Len),
    Avg is Sum / Len.

% Testing
% :- generate_and_assertz_random_list, run_sorting, analyze_results.


/*
Sample Output

CPU time: bubbleSort 0.033326339999999996
CPU time: insertionSort 0.002441470000000001
CPU time: mergeSort 0.0011791520000000028
CPU time: quickSort 0.001155428
Hybrid Algo bubbleSort/mergeSort CPU time: 0.0010577439999999994
Hybrid Algo insertionSort/mergeSort CPU time: 0.0005028730000000009
Hybrid Algo bubbleSort/quickSort CPU time: 0.00046328899999999174
Hybrid Algo insertionSort/quickSort CPU time: 0.001357295999999994
CPU time: bubbleSort 0.03654882500000001
CPU time: insertionSort 0.0022404530000000034
CPU time: mergeSort 0.0009530880000000047
CPU time: quickSort 0.0004579590000000078
Hybrid Algo bubbleSort/mergeSort CPU time: 0.0004439430000000022
Hybrid Algo insertionSort/mergeSort CPU time: 0.0004634300000000008
Hybrid Algo bubbleSort/quickSort CPU time: 0.00048086199999999857
Hybrid Algo insertionSort/quickSort CPU time: 0.0005994340000000098
CPU time: bubbleSort 0.032072517999999994
CPU time: insertionSort 0.002789803999999979
CPU time: mergeSort 0.0007311819999999969
CPU time: quickSort 0.0005062899999999926
Hybrid Algo bubbleSort/mergeSort CPU time: 0.00044010599999999567
Hybrid Algo insertionSort/mergeSort CPU time: 0.00043932399999999094
Hybrid Algo bubbleSort/quickSort CPU time: 0.00045262900000000994
Hybrid Algo insertionSort/quickSort CPU time: 0.0019938100000000125
CPU time: bubbleSort 0.03671429600000001
CPU time: insertionSort 0.002663367
CPU time: mergeSort 0.0004898390000000197
CPU time: quickSort 0.00043230099999999605
Hybrid Algo bubbleSort/mergeSort CPU time: 0.000438321999999991
Hybrid Algo insertionSort/mergeSort CPU time: 0.00043752100000002403
Hybrid Algo bubbleSort/quickSort CPU time: 0.00048404900000001416
Hybrid Algo insertionSort/quickSort CPU time: 0.00045783899999998767
CPU time: bubbleSort 0.03338949800000002
CPU time: insertionSort 0.0024948109999999857
CPU time: mergeSort 0.0005057890000000065
CPU time: quickSort 0.00043404399999999455
Hybrid Algo bubbleSort/mergeSort CPU time: 0.00044696799999999204
Hybrid Algo insertionSort/mergeSort CPU time: 0.0004449350000000074
Hybrid Algo bubbleSort/quickSort CPU time: 0.0004996069999999853
Hybrid Algo insertionSort/quickSort CPU time: 0.0005402230000000063
CPU time: bubbleSort 0.031376192000000025
CPU time: insertionSort 0.0021092470000000363
CPU time: mergeSort 0.0004899899999999957
CPU time: quickSort 0.0006135609999999847
Hybrid Algo bubbleSort/mergeSort CPU time: 0.000628187999999974
Hybrid Algo insertionSort/mergeSort CPU time: 0.0004921239999999827
Hybrid Algo bubbleSort/quickSort CPU time: 0.0005113090000000153
Hybrid Algo insertionSort/quickSort CPU time: 0.000594045000000043
CPU time: bubbleSort 0.031315307000000014
CPU time: insertionSort 0.0019409710000000135
CPU time: mergeSort 0.00048591200000003276
CPU time: quickSort 0.00039365899999999066
Hybrid Algo bubbleSort/mergeSort CPU time: 0.0004436520000000166
Hybrid Algo insertionSort/mergeSort CPU time: 0.00043894300000002495
Hybrid Algo bubbleSort/quickSort CPU time: 0.00042119999999995494
Hybrid Algo insertionSort/quickSort CPU time: 0.0004153990000000385
CPU time: bubbleSort 0.031667869000000015
CPU time: insertionSort 0.0018929010000000024
CPU time: mergeSort 0.0004927040000000105
CPU time: quickSort 0.0004177029999999915
Hybrid Algo bubbleSort/mergeSort CPU time: 0.0004459269999999571
Hybrid Algo insertionSort/mergeSort CPU time: 0.0004437330000000017
Hybrid Algo bubbleSort/quickSort CPU time: 0.00041180199999996114
Hybrid Algo insertionSort/quickSort CPU time: 0.0004203979999999885
CPU time: bubbleSort 0.036564304999999964
CPU time: insertionSort 0.001976917999999994
CPU time: mergeSort 0.0005034749999999755
CPU time: quickSort 0.00042642000000003843
Hybrid Algo bubbleSort/mergeSort CPU time: 0.00044396299999999167
Hybrid Algo insertionSort/mergeSort CPU time: 0.000445446000000016
Hybrid Algo bubbleSort/quickSort CPU time: 0.0005261069999999979
Hybrid Algo insertionSort/quickSort CPU time: 0.0005570950000000074
CPU time: bubbleSort 0.033160619
CPU time: insertionSort 0.0019070480000000223
CPU time: mergeSort 0.0004941780000000118
CPU time: quickSort 0.00046579299999999213
Hybrid Algo bubbleSort/mergeSort CPU time: 0.0004442339999999878
Hybrid Algo insertionSort/mergeSort CPU time: 0.00044416399999996914
Hybrid Algo bubbleSort/quickSort CPU time: 0.0004910519999999918
Hybrid Algo insertionSort/quickSort CPU time: 0.0004920029999999631
CPU time: bubbleSort 0.034824630999999995
CPU time: insertionSort 0.0019772290000000248
CPU time: mergeSort 0.0004951290000000386
CPU time: quickSort 0.0009010500000000143
Hybrid Algo bubbleSort/mergeSort CPU time: 0.0004564059999999648
Hybrid Algo insertionSort/mergeSort CPU time: 0.0005277399999999988
Hybrid Algo bubbleSort/quickSort CPU time: 0.0005362260000000285
Hybrid Algo insertionSort/quickSort CPU time: 0.000588264000000005
CPU time: bubbleSort 0.03558873400000001
CPU time: insertionSort 0.00230205799999994
CPU time: mergeSort 0.0004909410000000225
CPU time: quickSort 0.0003909529999999162
Hybrid Algo bubbleSort/mergeSort CPU time: 0.001114841000000033
Hybrid Algo insertionSort/mergeSort CPU time: 0.00043949500000006747
Hybrid Algo bubbleSort/quickSort CPU time: 0.00041737299999999866
Hybrid Algo insertionSort/quickSort CPU time: 0.00044303099999998263
CPU time: bubbleSort 0.034022526
CPU time: insertionSort 0.0019301509999999356
CPU time: mergeSort 0.0007396170000000257
CPU time: quickSort 0.0004590719999999493
Hybrid Algo bubbleSort/mergeSort CPU time: 0.0004815529999999679
Hybrid Algo insertionSort/mergeSort CPU time: 0.000504245999999986
Hybrid Algo bubbleSort/quickSort CPU time: 0.0004895079999999163
Hybrid Algo insertionSort/quickSort CPU time: 0.0004448350000000323
CPU time: bubbleSort 0.037436029999999954
CPU time: insertionSort 0.0022718419999999684
CPU time: mergeSort 0.0004931750000000124
CPU time: quickSort 0.0004302169999998995
Hybrid Algo bubbleSort/mergeSort CPU time: 0.0004883160000000997
Hybrid Algo insertionSort/mergeSort CPU time: 0.00044667799999997815
Hybrid Algo bubbleSort/quickSort CPU time: 0.00046169600000001143
Hybrid Algo insertionSort/quickSort CPU time: 0.00045631600000006767
CPU time: bubbleSort 0.03153762400000004
CPU time: insertionSort 0.0019480050000000304
CPU time: mergeSort 0.0005348030000000836
CPU time: quickSort 0.00044765000000002164
Hybrid Algo bubbleSort/mergeSort CPU time: 0.00045746899999998814
Hybrid Algo insertionSort/mergeSort CPU time: 0.00044401299999996535
Hybrid Algo bubbleSort/quickSort CPU time: 0.00048570199999997676
Hybrid Algo insertionSort/quickSort CPU time: 0.0004499940000000091
CPU time: bubbleSort 0.03492896599999995
CPU time: insertionSort 0.0020366309999999554
CPU time: mergeSort 0.000758874000000076
CPU time: quickSort 0.0004985349999999666
Hybrid Algo bubbleSort/mergeSort CPU time: 0.00047096300000004643
Hybrid Algo insertionSort/mergeSort CPU time: 0.00046006300000001055
Hybrid Algo bubbleSort/quickSort CPU time: 0.0005221999999999172
Hybrid Algo insertionSort/quickSort CPU time: 0.000518092000000081
CPU time: bubbleSort 0.03394417999999999
CPU time: insertionSort 0.002029938999999925
CPU time: mergeSort 0.0005000779999999594
CPU time: quickSort 0.0011433750000000575
Hybrid Algo bubbleSort/mergeSort CPU time: 0.0004568870000000169
Hybrid Algo insertionSort/mergeSort CPU time: 0.0004531300000000238
Hybrid Algo bubbleSort/quickSort CPU time: 0.0004987859999999733
Hybrid Algo insertionSort/quickSort CPU time: 0.00047109400000000523
CPU time: bubbleSort 0.03406308200000008
CPU time: insertionSort 0.001976777999999957
CPU time: mergeSort 0.0004953500000000055
CPU time: quickSort 0.0010154949999999774
Hybrid Algo bubbleSort/mergeSort CPU time: 0.0004582090000000427
Hybrid Algo insertionSort/mergeSort CPU time: 0.0004469289999999848
Hybrid Algo bubbleSort/quickSort CPU time: 0.00041230399999991896
Hybrid Algo insertionSort/quickSort CPU time: 0.0004085670000000263
CPU time: bubbleSort 0.03275100100000006
CPU time: insertionSort 0.0019710379999999805
CPU time: mergeSort 0.0004953500000000055
CPU time: quickSort 0.00045742800000003747
Hybrid Algo bubbleSort/mergeSort CPU time: 0.0004429409999999745
Hybrid Algo insertionSort/mergeSort CPU time: 0.001422939000000012
Hybrid Algo bubbleSort/quickSort CPU time: 0.0004925639999999731
Hybrid Algo insertionSort/quickSort CPU time: 0.000490320000000044
CPU time: bubbleSort 0.03512210900000001
CPU time: insertionSort 0.0021836469999999553
CPU time: mergeSort 0.000595797000000009
CPU time: quickSort 0.0005869309999999572
Hybrid Algo bubbleSort/mergeSort CPU time: 0.0014467340000000606
Hybrid Algo insertionSort/mergeSort CPU time: 0.0005113290000000603
Hybrid Algo bubbleSort/quickSort CPU time: 0.0006010579999999877
Hybrid Algo insertionSort/quickSort CPU time: 0.0006260150000000353
CPU time: bubbleSort 0.03500980899999995
CPU time: insertionSort 0.0020337049999999968
CPU time: mergeSort 0.00053490299999992
CPU time: quickSort 0.0004746799999999496
Hybrid Algo bubbleSort/mergeSort CPU time: 0.00044276100000006924
Hybrid Algo insertionSort/mergeSort CPU time: 0.00044655699999995857
Hybrid Algo bubbleSort/quickSort CPU time: 0.0015043220000000579
Hybrid Algo insertionSort/quickSort CPU time: 0.0004730470000000597
CPU time: bubbleSort 0.03620512099999995
CPU time: insertionSort 0.0020586719999999836
CPU time: mergeSort 0.0010595970000000232
CPU time: quickSort 0.00049324499999992
Hybrid Algo bubbleSort/mergeSort CPU time: 0.0005083030000000432
Hybrid Algo insertionSort/mergeSort CPU time: 0.00047593300000003946
Hybrid Algo bubbleSort/quickSort CPU time: 0.0005873220000000012
Hybrid Algo insertionSort/quickSort CPU time: 0.0004862519999999648
CPU time: bubbleSort 0.031665784999999946
CPU time: insertionSort 0.002017975999999977
CPU time: mergeSort 0.0005360460000000122
CPU time: quickSort 0.0005425369999999541
Hybrid Algo bubbleSort/mergeSort CPU time: 0.00047009200000003304
Hybrid Algo insertionSort/mergeSort CPU time: 0.0004544520000000496
Hybrid Algo bubbleSort/quickSort CPU time: 0.0005428389999999617
Hybrid Algo insertionSort/quickSort CPU time: 0.0006375159999999491
CPU time: bubbleSort 0.03042615999999998
CPU time: insertionSort 0.0021404959999999917
CPU time: mergeSort 0.0006255930000000909
CPU time: quickSort 0.0006985609999999864
Hybrid Algo bubbleSort/mergeSort CPU time: 0.0005299739999999886
Hybrid Algo insertionSort/mergeSort CPU time: 0.0005410250000000838
Hybrid Algo bubbleSort/quickSort CPU time: 0.0007101520000000194
Hybrid Algo insertionSort/quickSort CPU time: 0.0007298589999999994
CPU time: bubbleSort 0.033596908000000036
CPU time: insertionSort 0.0019947620000000388
CPU time: mergeSort 0.0005280909999998418
CPU time: quickSort 0.00042232200000014153
Hybrid Algo bubbleSort/mergeSort CPU time: 0.0014117379999998292
Hybrid Algo insertionSort/mergeSort CPU time: 0.00045517400000005814
Hybrid Algo bubbleSort/quickSort CPU time: 0.00045055500000001913
Hybrid Algo insertionSort/quickSort CPU time: 0.0004275719999999872
CPU time: bubbleSort 0.03379866600000003
CPU time: insertionSort 0.001970977999999901
CPU time: mergeSort 0.0005000779999999594
CPU time: quickSort 0.0004201280000000196
Hybrid Algo bubbleSort/mergeSort CPU time: 0.0012002120000000893
Hybrid Algo insertionSort/mergeSort CPU time: 0.00044124699999992245
Hybrid Algo bubbleSort/quickSort CPU time: 0.00045195799999997455
Hybrid Algo insertionSort/quickSort CPU time: 0.00044031599999994064
CPU time: bubbleSort 0.032315633999999926
CPU time: insertionSort 0.0019568809999999104
CPU time: mergeSort 0.0004894779999999876
CPU time: quickSort 0.0004250470000000117
Hybrid Algo bubbleSort/mergeSort CPU time: 0.00044191900000001283
Hybrid Algo insertionSort/mergeSort CPU time: 0.0004400860000000062
Hybrid Algo bubbleSort/quickSort CPU time: 0.0015303710000000859
Hybrid Algo insertionSort/quickSort CPU time: 0.0005410450000000733
CPU time: bubbleSort 0.030374502999999997
CPU time: insertionSort 0.001957603000000141
CPU time: mergeSort 0.0004926240000000526
CPU time: quickSort 0.0003960129999998063
Hybrid Algo bubbleSort/mergeSort CPU time: 0.00044248000000002286
Hybrid Algo insertionSort/mergeSort CPU time: 0.00045670700000011166
Hybrid Algo bubbleSort/quickSort CPU time: 0.00041529900000014663
Hybrid Algo insertionSort/quickSort CPU time: 0.0004286540000000283
CPU time: bubbleSort 0.035282489999999944
CPU time: insertionSort 0.002303520999999975
CPU time: mergeSort 0.0005588080000000772
CPU time: quickSort 0.0004415789999998587
Hybrid Algo bubbleSort/mergeSort CPU time: 0.0004544930000001113
Hybrid Algo insertionSort/mergeSort CPU time: 0.0004961510000001113
Hybrid Algo bubbleSort/quickSort CPU time: 0.0004860620000000093
Hybrid Algo insertionSort/quickSort CPU time: 0.0004640100000001812
CPU time: bubbleSort 0.029917965999999963
CPU time: insertionSort 0.0019332270000000928
CPU time: mergeSort 0.0005123309999999215
CPU time: quickSort 0.00041351600000005817
Hybrid Algo bubbleSort/mergeSort CPU time: 0.0004751810000001022
Hybrid Algo insertionSort/mergeSort CPU time: 0.00044279099999999794
Hybrid Algo bubbleSort/quickSort CPU time: 0.0004420099999999927
Hybrid Algo insertionSort/quickSort CPU time: 0.0004341240000000912
CPU time: bubbleSort 0.034031794000000115
CPU time: insertionSort 0.002001295000000125
CPU time: mergeSort 0.0004919930000000239
CPU time: quickSort 0.0010678630000000577
Hybrid Algo bubbleSort/mergeSort CPU time: 0.00044541499999994905
Hybrid Algo insertionSort/mergeSort CPU time: 0.00044040599999983776
Hybrid Algo bubbleSort/quickSort CPU time: 0.000449303000000123
Hybrid Algo insertionSort/quickSort CPU time: 0.00045102599999991
CPU time: bubbleSort 0.034963100999999996
CPU time: insertionSort 0.0020079070000000865
CPU time: mergeSort 0.0008234549999999174
CPU time: quickSort 0.00038589400000010876
Hybrid Algo bubbleSort/mergeSort CPU time: 0.0004549730000000807
Hybrid Algo insertionSort/mergeSort CPU time: 0.0004406060000001766
Hybrid Algo bubbleSort/quickSort CPU time: 0.00040715399999990964
Hybrid Algo insertionSort/quickSort CPU time: 0.00040385799999986816
CPU time: bubbleSort 0.033876271999999874
CPU time: insertionSort 0.002019739000000076
CPU time: mergeSort 0.0005207670000000331
CPU time: quickSort 0.0012481819999998756
Hybrid Algo bubbleSort/mergeSort CPU time: 0.0004765440000000787
Hybrid Algo insertionSort/mergeSort CPU time: 0.00044786999999990584
Hybrid Algo bubbleSort/quickSort CPU time: 0.00045728800000000014
Hybrid Algo insertionSort/quickSort CPU time: 0.0004554249999999538
CPU time: bubbleSort 0.03303351099999996
CPU time: insertionSort 0.001949656999999938
CPU time: mergeSort 0.0004952389999999252
CPU time: quickSort 0.00042008800000004065
Hybrid Algo bubbleSort/mergeSort CPU time: 0.00044877199999993067
Hybrid Algo insertionSort/mergeSort CPU time: 0.00045451299999998973
Hybrid Algo bubbleSort/quickSort CPU time: 0.00044495500000008015
Hybrid Algo insertionSort/quickSort CPU time: 0.0017414369999999568
CPU time: bubbleSort 0.03451068300000015
CPU time: insertionSort 0.0019658680000000928
CPU time: mergeSort 0.0004981649999997728
CPU time: quickSort 0.00048153299999986743
Hybrid Algo bubbleSort/mergeSort CPU time: 0.0011907739999998945
Hybrid Algo insertionSort/mergeSort CPU time: 0.00044444400000021034
Hybrid Algo bubbleSort/quickSort CPU time: 0.0005062200000001127
Hybrid Algo insertionSort/quickSort CPU time: 0.0005018619999999085
CPU time: bubbleSort 0.029945888999999948
CPU time: insertionSort 0.001930731999999935
CPU time: mergeSort 0.0004958799999998931
CPU time: quickSort 0.0003948409999998681
Hybrid Algo bubbleSort/mergeSort CPU time: 0.000459913000000034
Hybrid Algo insertionSort/mergeSort CPU time: 0.00045497299999985863
Hybrid Algo bubbleSort/quickSort CPU time: 0.00042891400000000246
Hybrid Algo insertionSort/quickSort CPU time: 0.0004193969999999325
CPU time: bubbleSort 0.03624149900000018
CPU time: insertionSort 0.00228192100000002
CPU time: mergeSort 0.0005556219999998113
CPU time: quickSort 0.0004790379999999317
Hybrid Algo bubbleSort/mergeSort CPU time: 0.0004519279999999348
Hybrid Algo insertionSort/mergeSort CPU time: 0.00044601600000016006
Hybrid Algo bubbleSort/quickSort CPU time: 0.0004927850000000511
Hybrid Algo insertionSort/quickSort CPU time: 0.0004859019999998715
CPU time: bubbleSort 0.033107139000000174
CPU time: insertionSort 0.0019215150000002623
CPU time: mergeSort 0.0004889870000002183
CPU time: quickSort 0.00046038300000006416
Hybrid Algo bubbleSort/mergeSort CPU time: 0.0004398850000000287
Hybrid Algo insertionSort/mergeSort CPU time: 0.0013901979999999536
Hybrid Algo bubbleSort/quickSort CPU time: 0.00047989099999989904
Hybrid Algo insertionSort/quickSort CPU time: 0.00047954999999988424
CPU time: bubbleSort 0.035970580999999946
CPU time: insertionSort 0.002239310999999855
CPU time: mergeSort 0.0004898190000000024
CPU time: quickSort 0.0004656229999999706
Hybrid Algo bubbleSort/mergeSort CPU time: 0.0004499840000000699
Hybrid Algo insertionSort/mergeSort CPU time: 0.0004683879999998197
Hybrid Algo bubbleSort/quickSort CPU time: 0.0005117400000000938
Hybrid Algo insertionSort/quickSort CPU time: 0.0004886969999999824
CPU time: bubbleSort 0.03621187300000006
CPU time: insertionSort 0.002270558999999839
CPU time: mergeSort 0.0005432389999999732
CPU time: quickSort 0.0004549540000000629
Hybrid Algo bubbleSort/mergeSort CPU time: 0.0004463369999998523
Hybrid Algo insertionSort/mergeSort CPU time: 0.00047136400000002965
Hybrid Algo bubbleSort/quickSort CPU time: 0.0004732780000000769
Hybrid Algo insertionSort/quickSort CPU time: 0.00047517199999980164
CPU time: bubbleSort 0.030708699999999922
CPU time: insertionSort 0.0018814500000001733
CPU time: mergeSort 0.0005226510000002627
CPU time: quickSort 0.00042024799999995643
Hybrid Algo bubbleSort/mergeSort CPU time: 0.0005013710000001392
Hybrid Algo insertionSort/mergeSort CPU time: 0.0004497539999999134
Hybrid Algo bubbleSort/quickSort CPU time: 0.0004491630000000857
Hybrid Algo insertionSort/quickSort CPU time: 0.00043684899999973936
CPU time: bubbleSort 0.032805393000000294
CPU time: insertionSort 0.001967692000000021
CPU time: mergeSort 0.0004879760000000566
CPU time: quickSort 0.0004358879999999399
Hybrid Algo bubbleSort/mergeSort CPU time: 0.0004437120000000405
Hybrid Algo insertionSort/mergeSort CPU time: 0.00044498400000003713
Hybrid Algo bubbleSort/quickSort CPU time: 0.001470548000000127
Hybrid Algo insertionSort/quickSort CPU time: 0.0004669459999999681
CPU time: bubbleSort 0.031221460999999895
CPU time: insertionSort 0.0018826819999999689
CPU time: mergeSort 0.0004982150000001351
CPU time: quickSort 0.00042085899999988463
Hybrid Algo bubbleSort/mergeSort CPU time: 0.0004923639999998564
Hybrid Algo insertionSort/mergeSort CPU time: 0.0004396950000000732
Hybrid Algo bubbleSort/quickSort CPU time: 0.0004583290000002016
Hybrid Algo insertionSort/quickSort CPU time: 0.0004457360000000854
CPU time: bubbleSort 0.03438388400000014
CPU time: insertionSort 0.002002916999999993
CPU time: mergeSort 0.00050178100000009
CPU time: quickSort 0.0011178069999999707
Hybrid Algo bubbleSort/mergeSort CPU time: 0.00045315000000001326
Hybrid Algo insertionSort/mergeSort CPU time: 0.000440847000000133
Hybrid Algo bubbleSort/quickSort CPU time: 0.00048821599999993026
Hybrid Algo insertionSort/quickSort CPU time: 0.0004833169999998166
CPU time: bubbleSort 0.03383750900000004
CPU time: insertionSort 0.0019486060000000194
CPU time: mergeSort 0.0005203160000000207
CPU time: quickSort 0.00040320599999987827
Hybrid Algo bubbleSort/mergeSort CPU time: 0.0013332710000000247
Hybrid Algo insertionSort/mergeSort CPU time: 0.00044662799999994895
Hybrid Algo bubbleSort/quickSort CPU time: 0.0004213100000001191
Hybrid Algo insertionSort/quickSort CPU time: 0.0004175140000000077
CPU time: bubbleSort 0.03609666700000003
CPU time: insertionSort 0.00226220399999999
CPU time: mergeSort 0.0004891670000000126
CPU time: quickSort 0.00043580699999989925
Hybrid Algo bubbleSort/mergeSort CPU time: 0.000463189000000197
Hybrid Algo insertionSort/mergeSort CPU time: 0.0005405039999999417
Hybrid Algo bubbleSort/quickSort CPU time: 0.00048181400000002483
Hybrid Algo insertionSort/quickSort CPU time: 0.0004666049999999533
CPU time: bubbleSort 0.03324733199999974
CPU time: insertionSort 0.0019975169999999487
CPU time: mergeSort 0.0004925439999998726
CPU time: quickSort 0.0004845990000001965
Hybrid Algo bubbleSort/mergeSort CPU time: 0.00045422299999997584
Hybrid Algo insertionSort/mergeSort CPU time: 0.0004462969999998734
Hybrid Algo bubbleSort/quickSort CPU time: 0.0005425780000001268
Hybrid Algo insertionSort/quickSort CPU time: 0.0005153070000001314
CPU time: bubbleSort 0.03361512200000005
CPU time: insertionSort 0.0020319220000000193
CPU time: mergeSort 0.0004931450000000837
CPU time: quickSort 0.00046912999999992877
Hybrid Algo bubbleSort/mergeSort CPU time: 0.0011702360000001022
Hybrid Algo insertionSort/mergeSort CPU time: 0.0004426700000002004
Hybrid Algo bubbleSort/quickSort CPU time: 0.0005302140000003064
Hybrid Algo insertionSort/quickSort CPU time: 0.0005084439999998303
CPU time: bubbleSort 0.03191280900000004
CPU time: insertionSort 0.0019480450000000094
CPU time: mergeSort 0.0005297940000001944
CPU time: quickSort 0.0004527089999999401
Hybrid Algo bubbleSort/mergeSort CPU time: 0.0004616560000001435
Hybrid Algo insertionSort/mergeSort CPU time: 0.00044409300000003427
Hybrid Algo bubbleSort/quickSort CPU time: 0.00047514100000012327
Hybrid Algo insertionSort/quickSort CPU time: 0.0017988349999997766
CPU time: bubbleSort 0.032671201000000094
CPU time: insertionSort 0.0020302089999999495
CPU time: mergeSort 0.0004968519999999366
CPU time: quickSort 0.0003998499999999794
Hybrid Algo bubbleSort/mergeSort CPU time: 0.00044502499999987677
Hybrid Algo insertionSort/mergeSort CPU time: 0.001377222999999983
Hybrid Algo bubbleSort/quickSort CPU time: 0.00044448399999996724
Hybrid Algo insertionSort/quickSort CPU time: 0.00042147000000003487
--------------------------------------------------Average time for bubbleSort: 0.033627 seconds
Average time for insertionSort: 0.002080 seconds
Average time for mergeSort: 0.000564 seconds
Average time for quickSort: 0.000545 seconds
Average time for hybrid1: 0.000587 seconds
Average time for hybrid2: 0.000516 seconds
Average time for hybrid3: 0.000544 seconds
Average time for hybrid4: 0.000585 seconds
true

*/