# Aoc2025

Solving advent of code 2025 in Elixir!


## Diary
- Day08: Did DFS to determine all connected components of a graph, was fun to figure out! 
Then naively used that on part 2, which worked but was slow. Did allow me to find profiling:
```
> mix profile.eprof -e "Day08.part2()"
#                                                                       CALLS     %      TIME µS/CALL
Total                                                              4048660501 100.0 423928536    0.10
Integer.parse/1                                                          3000  0.00       175    0.06
:prim_file.close_nif/1                                                      1  0.00       681  681.00
Integer.parse/2                                                          3000  0.00       730    0.24
Enum.take/2                                                              2001  0.00      1191    0.60
:re.import/1                                                             1000  0.00      1210    1.21
Integer.count_digits_nosign/3                                           17669  0.00      1290    0.07
:re.run/3                                                                1000  0.00      1386    1.39
anonymous fn/3 in Day08.part2/1                                          2001  0.00      1480    0.74
:prim_file.read_nif/2                                                       2  0.00      1538  769.00
:prim_file.open_nif/2                                                       1  0.00      7254 7254.00
Day08.all_connected?/2                                                   2001  0.00      7481    3.74
:lists.keysplit_2_1/10                                                 173330  0.00     13015    0.08
Map.new/1                                                                2001  0.01     21976   10.98
:lists.keysplit_2/8                                                    326169  0.01     23552    0.07
Map.get/2                                                              450861  0.01     26946    0.06
Enum.reduce/3                                                          451866  0.01     31154    0.07
anonymous fn/2 in Day08.all_connected?/2                               450861  0.01     37132    0.08
:lists.reverse/2                                                        51792  0.01     42230    0.82
anonymous fn/3 in Day08.dfs/3                                         1713426  0.06    241231    0.14
anonymous fn/1 in Day08.connect_closest/3                             2001000  0.06    246688    0.12
Enum.map/2                                                            2005011  0.06    247280    0.12
Enum.take_list/2                                                      2009000  0.07    292101    0.15
anonymous fn/2 in Day08.all_connected?/2                              4002000  0.08    334481    0.08
anonymous fn/1 in Day08.sorted_distance_graph/1                        499500  0.08    336290    0.67
:maps.from_list/1                                                        2004  0.08    353375  176.33
anonymous fn/2 in Enum.sort_by/3                                       499500  0.09    363594    0.73
Enum."-reduce/3-lists^foldl/2-0-"/3                                   3166304  0.09    395503    0.12
Enum.map_range/4                                                      1000500  0.10    437593    0.44
anonymous fn/2 in Day08.all_connected?/2                              2001000  0.26   1094993    0.55
Enum."-map/2-lists^map/1-1-"/2                                        9006010  0.44   1852987    0.21
anonymous fn/2 in Day08.all_connected?/2                           2001000000 36.55 154965164    0.08
Enum.filter_list/2                                                 2003001000 61.38 260214118    0.13
```


