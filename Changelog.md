# Change log

### v0.11.0 (released on 13 May 2023)
#### Polished
- **The expansion size of the Flexibly expandable ring buffer for agents and names**: Nodes in Inpla are managed by the ring buffer. A set of nodes is inserted to the ring buffer when all nodes are used up. The size of the new nodes was based on the size of the set where we found all the nodes had run out, but this was turned out to be inefficient, especially for the reuse optimisation. So, it is now based on the size of the buffer where the last node was placed. It improves the reuse optimisation. The annotations for the optimisation were selected heuristically. Now they are placed systematically based on an algorithm. The execution times are shown in the table below. We can get more or less almost the same ones (the bold ones mean faster or the same). This will be the basis for the automatic placement of the annotations.

  |              | v0.10.8-1 |         |  ->  | v0.11.0  |          |
  | ------------ | :-------: | :-----: | :--: | :------: | :------: |
  |              |  Inpla8   | Inpla8r |      |  Inpla8  | Inpra8r  |
  | n-queens 12  |   0.54    |  0.36   |      |   0.55   |   0.40   |
  | ack(3,11)    |   0.90    |  0.73   |      |   0.91   | **0.68** |
  | fib 38       |   0.43    |  0.45   |      | **0.43** | **0.45** |
  | bsort 20000  |   2.38    |  1.48   |      | **2.31** | **1.45** |
  | isort 20000  |   0.32    |  0.32   |      | **0.32** |   0.33   |
  | qsort 260000 |   0.15    |  0.12   |      | **0.15** | **0.12** |
  | msort 260000 |   0.14    |  0.16   |      | **0.14** |   0.17   |



### v0.10.8-1 minor update (released on 7 May 2023)

#### Bug fix
- **Segmentation faults in rule definitions**: This was caused by a lack of linearity checking, which had been omitted for some experiments. Also, the compilation environment was updated for incomplete rule definitions. These are now fixed. Previously, the segmentation fault error was caused as follows:

  ```
  Inpla 0.10.8 : Interaction nets as a programming language [built: 29 April 2023]
  >>> eps() >< S(x) => eps~x;     // This should be the linearity error
  >>> eps() >< S(x) => eps~x;     // The `eps' is recognised as a global name
  Segmentation fault
  ```

  Of course, it works now:

  ```
  Inpla 0.10.8-1 : Interaction nets as a programming language [built: 7 May 2023]
  >>> eps() >< S(x) => eps~x;
  ERROR: `eps' is referred not twice in the right-hand side of the rule:
    eps >< S.
  >>> eps() >< S(x) => eps()~x;
  >>>
  ```

#### Polished

- **Pretty printing of agents**: 0-arity agents whose names start with a lowercase letters are printed with round brackets like `eps()`.

  ```
  >>> (a,b,c) ~ (Z, S(Z), eps());
  (1 interactions, 0.00 sec)
  >>> ifce;
  a b c
  
  Connections:
  a ->Z
  b ->S(Z)
  c ->eps()                       // Previously, it was `c ->eps'.
  
  >>>
  ```

  



### v0.10.8 (released on 29 April 2023)
#### Bug fix
- **Segmentation faults due to use of 4-tuples or built-in Eraser**: These are now resolved. 





### v0.10.7 (released on 11 March 2023)

|              |                       Inpla8                        |                        Inpla8r                         |
| ------------ | :-------------------------------------------------: | :----------------------------------------------------: |
| n-queens 12  |    [**0.54**](comparison/Inpla/src/nqueen-12.in)    |    [0.36](comparison/Inpla/src/nqueen-12-reuse.in)     |
| ack(3,11)    | [**0.90**](comparison/Inpla/src/ack-stream_3-11.in) | [0.73](comparison/Inpla/src/ack-stream_3-11-reuse.in)  |
| fib 38       |     [**0.43**](comparison/Inpla/src/fib-38.in)      |    [**0.45**](comparison/Inpla/src/fib-38-reuse.in)    |
| bsort 20000  |   [**2.38**](comparison/Inpla/src/bsort-20000.in)   |   [1.48](comparison/Inpla/src/bsort-20000-reuse.in)    |
| isort 20000  |   [**0.32**](comparison/Inpla/src/isort-20000.in)   | [**0.32**](comparison/Inpla/src/isort-20000-reuse.in)  |
| qsort 260000 |    [0.15](comparison/Inpla/src/qsort-260000.in)     |   [0.12](comparison/Inpla/src/qsort-260000-reuse.in)   |
| msort 260000 |    [0.14](comparison/Inpla/src/msort-260000.in)     | [**0.16**](comparison/Inpla/src/msort-260000-reuse.in) |

#### Polished

- **Stop using MKAGENTn**: In generally, to make an *n*-arity agent, we need the following operation:

  - Get memory area for the agent,
  - Assign ports information to the memory area.

  So, to make a 3-arity agent requires 1+3 steps. But, it can be one step if we provide a special operation to make 3-arity agents. The bytecode`makeagent3` does just so. This time I stopped using such folding operations in order to observe a more theoretical behaviour . Some become slower (shown in bold font in the table above), but in the case of the reused ones the change seems not to be so much. In the future, the reused one will be the default setting, so I would like to accept this change for now.

  To enable `mkagentN` again, uncomment the following line in `config.h`:

  ```
  // Use MKAGENTn codes
  //#define USE_MKAGENT_N
  ```







### v0.10.6 (released on 6 February 2023)

|              |                     Inpla8                      |                        Inpla8r                         |
| ------------ | :---------------------------------------------: | :----------------------------------------------------: |
| n-queens 12  |    [0.53](comparison/Inpla/src/nqueen-12.in)    |    [0.36](comparison/Inpla/src/nqueen-12-reuse.in)     |
| ack(3,11)    | [0.86](comparison/Inpla/src/ack-stream_3-11.in) | [0.75](comparison/Inpla/src/ack-stream_3-11-reuse.in)  |
| fib 38       |     [0.41](comparison/Inpla/src/fib-38.in)      |      [0.43](comparison/Inpla/src/fib-38-reuse.in)      |
| bsort 20000  |   [2.23](comparison/Inpla/src/bsort-20000.in)   | [**1.48**](comparison/Inpla/src/bsort-20000-reuse.in)  |
| isort 20000  | [**0.31**](comparison/Inpla/src/isort-20000.in) |   [0.33](comparison/Inpla/src/isort-20000-reuse.in)    |
| qsort 260000 |  [0.15](comparison/Inpla/src/qsort-260000.in)   | [**0.12**](comparison/Inpla/src/qsort-260000-reuse.in) |
| msort 260000 |  [0.15](comparison/Inpla/src/msort-260000.in)   | [**0.15**](comparison/Inpla/src/msort-260000-reuse.in) |

#### Polished

- **Two-addressing for mkagent4**: Two-addressing, which reduces the number of operands by one, is now available by default for `mkagent4` as well. To disable it, comment out the following line in `config.h`:

  ```
  #define OPTIMISE_TWO_ADDRESS_MKAGENT4 // For MKAGENT4
  ```

  In the benchmark result, we could expect that `n-queen` could be performed faster in the `Inpla8` execution, but it seems that the effect is small and just within the noise margin.

  

### v0.10.5 (released on 3 February 2023)

#### Bug fix

- **Code generation for Tail Call Optimisation**: Tail Call Optimisation turns an active pair execution into a loop operation. When the loop is executed, each port information needs to be updated, but some were skipped if the argument names in the ports were the same and their assigned registers are changed during execution. This is now fixed.

### v0.10.4 (released on 28 January 2023)

#### Bug fix

- **A reuse annotation with the abbreviation `<<`**: The abbreviation `<<` could not be parsed with a reuse annotation. This is now fixed, and we can write it as follows:

  ```
  foo(r) >< (int n)
  | n == 0 => r~n
  | _ => r << (*L)foo(n-1);  
  //          ^ This (*L) setting caused a parse error in a previous version.
  ```

  

### v0.10.3 quite minor update (released on 12 January 2023)

#### Minor bug fix

- **The maximum number of ports**: The number of ports in agents is defined by `MAX_PORT` in `config.h`, but it put an error when we used these ports out fully. Now we use these ports the same as the definition.



### v0.10.2 minor update (released on 29 December 2022)

#### Polished

- **Avoiding suddenly crushing due to compilation errors**: The compilation process crushed and then the system aborted when property variables were referred to before the declaration, but it is now resolved. For instance, the system keeps working without avoiding for the following net where `x` is referred to before its declaration:

  ```
  >>> r~(x+10);
  ERROR: `x' is referred to as a property variable in an expression, although it has not yet been declared (as so).
  >>>
  ```

  So, even if we write the following rule having `r~(r1+r2) `, the system will not abort suddenly, although the compilation crushes:

  ```
  >>> fib(r) >< (int n)
  ... | n == 0 => ret~0
  ... | n == 1 => ret~1
  ... | _ => r~(r1+r2), fib(r1)~(n-1), fib(r2)~(n-2);
  ERROR: `r1' is referred to as a property variable in an expression, although it has not yet been declared (as so).
  ERROR: Compilation failure for fib >< Int.
  >>>
  ```

- **New sample programs**: Two programs of *higher-order operations* are joined in sample programs:

  - `map.in`: It explains how map operation can be performed with built-in and not built-in agent and `%` notation.
  - `reduce.in`: Here, Foldr and Foldl are realised.





### v0.10.1 minor update (released on 22 December 2022)
#### Polished
* **Warning messages**: Inpla puts warning messages when names are connected to expressions because Runtime Error can be caused. In addition, messages are put when names are included in expressions as well. In future, those will be detected by a type inference system, not such ad hoc finding, I hope.

  ```
  >>> A(r)><B(int x) => r~1, x~100;
  Warning: The variable `x' is connected to an expression. It may cause runtime error.
  ```

  ```
  >>> A(r, y)><B(int x) => r~(x+y);
  Warning: The agent `A' has been previously defined of arity 1, but is now used of arity 2.
  Warning: `y' is used as a property variable, although is is not declared as so.
  ```

  ```
  >>> A(r, y)><B(int x)
  ... | y==0 => r~x, y~x
  ... | _ => r~x+1, y~x;
  Warning: `y' is used as a property variable, although is is not declared as so.
  ```
#### Minor change
* **Messages of applying Tail Call Optimisation** : A message was put when the optimisation is applied, but now it turns off because this is for developers. To enable this, make the following line uncommented in `config.h`:

  ```
  //#define VERBOSE_TCO                // Put message when TCO is enable.
  ```



### v0.10.0 (released on 17 September 2022)

|              |                   Haskell                   |                  OCaml                  |                   SML                   |                   Python                   |                     Inpla8                      |                        Inpla8r                         |
| ------------ | :-----------------------------------------: | :-------------------------------------: | :-------------------------------------: | :----------------------------------------: | :---------------------------------------------: | :----------------------------------------------------: |
| n-queens 12  | [**0.23**](comparison/Haskell/nqueen-12.hs) |  [0.44](comparison/OCaml/nqueen12.ml)   |   [0.60](comparison/SML/ack3-11.sml)    |   [3.81](comparison/Python/nqueen-12.py)   |    [0.54](comparison/Inpla/src/nqueen-12.in)    |    [0.36](comparison/Inpla/src/nqueen-12-reuse.in)     |
| ack(3,11)    |    [2.36](comparison/Haskell/ack3-11.hs)    |   [0.57](comparison/OCaml/ack3_11.ml)   | [**0.42**](comparison/SML/ack3-11.sml)  |     [-](comparison/Python/ack3-11.py)      | [0.88](comparison/Inpla/src/ack-stream_3-11.in) | [0.76](comparison/Inpla/src/ack-stream_3-11-reuse.in)  |
| fib 38       |    [1.61](comparison/Haskell/fib-38.hs)     |  [**0.15**](comparison/OCaml/fib38.ml)  |    [0.27](comparison/SML/fib-38.sml)    |    [9.17](comparison/Python/fib-38.py)     |     [0.42](comparison/Inpla/src/fib-38.in)      |      [0.43](comparison/Inpla/src/fib-38-reuse.in)      |
| bsort 20000  |  [5.01](comparison/Haskell/bsort-20000.hs)  | [6.44](comparison/OCaml/bsort20000.ml)  | [2.37](comparison/SML/bsort-20000.sml)  | [20.58](comparison/Python/bsort-20000.py)  |   [2.17](comparison/Inpla/src/bsort-20000.in)   | [**1.49**](comparison/Inpla/src/bsort-20000-reuse.in)  |
| isort 20000  |  [2.16](comparison/Haskell/isort-20000.hs)  | [1.48](comparison/OCaml/isort20000.ml)  | [0.60](comparison/SML/isort-20000.sml)  |  [9.34](comparison/Python/isort-20000.py)  | [**0.30**](comparison/Inpla/src/isort-20000.in) |   [0.33](comparison/Inpla/src/isort-20000-reuse.in)    |
| qsort 260000 | [0.36](comparison/Haskell/qsort-800000.hs)  | [0.22](comparison/OCaml/qsort260000.ml) | [0.27](comparison/SML/qsort-260000.sml) | [15.04](comparison/Python/qsort-260000.py) |  [0.16](comparison/Inpla/src/qsort-260000.in)   | [**0.12**](comparison/Inpla/src/qsort-260000-reuse.in) |
| msort 260000 | [0.38](comparison/Haskell/msort-800000.hs)  | [0.17](comparison/OCaml/msort260000.ml) | [0.26](comparison/SML/msort-260000.sml) | [15.55](comparison/Python/msort-260000.py) |  [0.16](comparison/Inpla/src/msort-260000.in)   | [**0.15**](comparison/Inpla/src/msort-260000-reuse.in) |

#### Polished (inner)
* **New instruction set for reuse active pairs**: Inpla supports annotations to reuse active active pairs by putting (\*L) and (\*R) in front of agents in rules as an experiment option. It was just to reuse only nodes for active pairs, but now we can specify the reuse method in the level of ports. As an example, we take the following rule:
  
  ```
  A(r) >< B(a,b,c) =>  (*L)C(r) ~ (*R)B(a,b,c);
  ```
  This means that `C(r)` is created on the memory of `A(r)`, and `B(a,b,c)` is reused as it is. This compiled into the following codes by the old instruction set. Actually, these active pair agents are reused, but the ID and all ports are specified again the same as MKAGENT.
  
  ```
   0:     REUSEAGENT1 var11 id:34 var1
   1:     REUSEAGENT3 var12 id:32 var6 var7 var8
   2:     PUSH var11 var12
   3:     RET
  ```
  Now, it is compiled as follows:
  ```
   0:     CHID_L $34            // The idL is just changed.
   1:     PUSH var11 var12
   2:     RET
	```
	It becomes quite reasonable, but there is no significant improvement in terms of execution speed than I expected. It becomes useful to demonstrate the execution performance obtained by the theoretical analysis. 
	
	To keep using the old version, uncomment the following in `config.h`:
	
	```
	//#define OLD_REUSEAGENT
	```
	
	

### v0.9.2-3 (released on 22 August 2022)
#### Bux fix

* **Invalid register allocation**: When a rule `A(x1,...)><B(y1,...)` is given, Inpla also defines the symmetry version `B(y1,...)><A(x1,...)`. The symmetry one had not been correctly compiled due to the invalid register allocation. For another invalid allocation issue, some tail recursive optimisation had not work correctly. These work well now!

#### Polished
* **Maximum port numbers**: The number of agent ports is defined as `5` in `config.h` as follows:

  ```
  // ------------------------------------------------
  // Number of Agent Ports 
  // ------------------------------------------------
  // MAX_PORT defines a number of ports of agents.
  // Default is 5 and should be 2 or more.
  
  #define MAX_PORT 5
  ```

  Change it when more ports are required. Typically, less port numbers, faster execusion.

* **Filename given by `-f` option**: Inpla can be invoked with `-f` option to specify an input script file. When a given filename is not found, Inpla in this version looks for a filename adding `.in` file extension.





### v0.9.2-2 (released on 21 August 2022)
#### Bux fix
* **Output of lists that are not terminated at []**: Generally lists are written with `[` and `]` like `[1,2,3]`. It can be written by using `:` as `1:2:3:[]`. This means we can write a Cons agent chain that is not terminated at Nil agent like `1:anet(2)`. However, it caused Segmentation fault:

  ```
  >>> a~1:2:3:aNet(4);
  (0 interactions, 0.00 sec)
  >>> ifce;
  a
  
  Connections:
  Segmentation fault
  ```

  Now such chains are outputted without the error as follows:

  ```
  >>> ifce;
  a
  
  Connections:
  a ->[1,2,3:aNet(4)
  
  >>>
  ```

  

  


### v0.9.2-1 (released on 2 August 2022)
#### Bux fix
* `%` **for more than 1-arity agents was something wrong**: It was just an implementation error. Now, it works well:
  
  ```
  >>> %Add ~ ((r,100),20);     // The `%Add' can abstract arguments of `Add'
  (3 interactions, 0.00 sec)
  >>> ifce;                    // The above works as Add(r,100)~2.
  r
  
  Connections:
  r ->120
  >>> free ifce;
  >>>
  ```
  ```
  >>> %Add ~ (arg_pair,20);     // We can also give concrete ones later by this bug fix.
  (2 interactions, 0.00 sec)
  >>> arg_pair~(r,100);
  (2 interactions, 0.00 sec)
  >>> ifce;
  r
  
  Connections:
  r ->120
  
  >>>
  ```


### v0.9.2 (released on 30 July 2022)
#### New Features
* **A built-in agent** `Map`: Map function operation is realised by the following definition:

  ```
  Map(result, f) >< []   => result~[], Eraser~f;
  Map(result, f) >< x:xs => Dup(f1,f2)~f, 
                            result~w:ws, 
                            f1 ~ (w, x), Map(ws, f2)~xs;
  ```
  Now, the Map has been implemented as built-in.
  ```
  >>> inc(r)><(int i)=>r~i+1;
  >>> Map(r1, (r, inc(r))) ~ [1,2,3];
  (22 interactions, 0.00 sec)
  >>> r1;
  [2,3,4]
  >>> Map(r2, (r, Add(r,10))) ~ [1,2,3];
  (26 interactions, 0.00 sec)
  >>> r2;
  [11,12,13]
  >>> Map(r3, %inc) ~ [1,2,3];
  (12 interactions, 0.00 sec)
  >>> r3;
  [2,3,4]
  >>>
  ```



### v0.9.1 (released on 28 July 2022)
#### New Features
* **A built-in agent** `Zip`: It takes two lists and returns a list whose elements are pairs of the given two lists elements such that:
  ```
  Zip(r,[1,2,...])~[10,20,...] -->* r~[(1,10),(2,20),...].
  ```
  The length of the result will be the same to the shorter one in the given lists:
  ```
  Zip(r,[1,2])~[10,20,30,...] -->* r~[(1,10),(2,20)].
  ```
  We can write it with the abbreviation as well:
  ```
  >>> r << Zip([1,2,3], [10,20,30]);
  (8 interactions, 0.00 sec)
  >>> r; free r;
  [(1,10),(2,20),(3,30)]
  >>>
  ```

### v0.9.0 (released on 25 July 2022)
#### New Features

* **New abbreviation**:
  An abbreviation `%foo` for an agent `foo` will be re-written internally depending on the arity of the `foo`:
  ```
  The abbreviation form is decided from the followings by the arity of a given agent to the %.
  %foo1  === (r, foo1(r))
  %foo2  === ((r,x), foo2(r,x))
  %foo3  === ((r,x,y), foo3(r,x,y))
  %foo4  === ((r,x,y,z), foo4(r,x,y,z))
  %foo5  === ((r,x,y,z,zz), foo5(r,x,y,z,zz))
    where r,x,y,z,zz are fresh names.
  ```
  For instance, when `foo` is an agent whose arity is 5, `%foo` can make the following computation simply:
  ```
  %foo ~ ((result,1,2,3,4), 5)   ===  ((r,x,y,z,zz), foo5(r,x,y,z,zz)) ~ ((result,1,2,3,4), 5)
    -->* foo(result,1,2,3,4)~5.
  ```

* **Why do we need it?**: Map and reduce computation can be realised easily because we can give the `%foo` to the map as a seed function operation. We suppose that an incrementor agent `inc` is defined as follows:
  ```
  inc(r)><(int i) => r~(i+1);
  ```
  By giving `%inc` to a `map` agent (explained later), each list element will be increased by 1:
  ```
  >>> map(result, %inc) ~ [1,2,3];
  >>> result;
  [2,3,4]
  >>>
  ```
  The map is defined as follows. It looks complicated? No problem! It is OK if we can use the `map`:
  ```
  map(result, f) >< []   => result~[], Eraser~f;
  map(result, f) >< x:xs => Dup(f1,f2)~f,
                            result~w:ws,
                            f1 ~ (w, x), map(ws, f2)~xs;
  ```
  In future, the map would be prepared as built-in as well. With respect to the reduce functions `foldr` and `foldl`, see [Gentle_introduction_Inpla.md](Gentle_introduction_Inpla.md)!


### v0.8.3-1 minor update (released on 21 July 2022)
#### Polished
* **Built-in agent** `Dup`: it can duplicate attributes also immediately. For instance, with respect to `Cons(int, xs)`, it performs as follows:
  ```
  Dup(a1,a2) >< (int i):xs => a1~i:w1, a2~i:w2, Dup(w1,w2)~xs;
  ```





### v0.8.3 (released on 19 July 2022)
#### New Features

* **Built-in agent** `Dup`: it duplicates any nets gradually with the following rules:
  ![Eraser](pic/dup.png)
  ```
  >>> Dup(a1,a2) ~ [1,2,3];
  (7 interactions, 0.00 sec)
  >>> ifce;
  a1 a2
  
  Connections:
  a1 ->[1,2,3]
  a2 ->[1,2,3]
  
  >>>
  ```

### v0.8.2-2 minor update (released on 30 May 2022)

|              |                  Haskell                   |                  OCaml                  |                   SML                   |                   Python                   |                      Inpla8                      |                        Inpla8r                         |
| ------------ | :----------------------------------------: | :-------------------------------------: | :-------------------------------------: | :----------------------------------------: | :----------------------------------------------: | :----------------------------------------------------: |
| ack(3,11)    |   [2.30](comparison/Haskell/ack3-11.hs)    |   [0.46](comparison/OCaml/ack3_11.ml)   | [**0.43**](comparison/SML/ack3-11.sml)  |     [-](comparison/Python/ack3-11.py)      | [0.86](comparison/Inpla/src/ack-stream_3-11.in)  | [0.71](comparison/Inpla/src/ack-stream_3-11-reuse.in)  |
| fib 38       |    [1.60](comparison/Haskell/fib38.hs)     |  [**0.15**](comparison/OCaml/fib38.ml)  |    [0.27](comparison/SML/fib38.sml)     |     [8.88](comparison/Python/fib38.py)     |      [0.40](comparison/Inpla/src/fib-38.in)      |      [0.43](comparison/Inpla/src/fib-38-reuse.in)      |
| bsort 20000  | [4.98](comparison/Haskell/bsort-40000.hs)  | [6.78](comparison/OCaml/bsort40000.ml)  | [2.38](comparison/SML/bsort-40000.sml)  | [19.91](comparison/Python/bsort-40000.py)  |   [2.16](comparison/Inpla/src/bsort-40000.in)    | [**1.58**](comparison/Inpla/src/bsort-40000-reuse.in)  |
| isort 20000  | [2.15](comparison/Haskell/isort-40000.hs)  | [1.52](comparison/OCaml/isort40000.ml)  | [0.60](comparison/SML/isort-40000.sml)  |  [9.58](comparison/Python/isort-40000.py)  | [**0.29**](comparison/Inpla/src/isort-40000.in)  |   [0.33](comparison/Inpla/src/isort-40000-reuse.in)    |
| qsort 260000 | [0.34](comparison/Haskell/qsort-800000.hs) | [0.25](comparison/OCaml/qsort800000.ml) | [0.27](comparison/SML/qsort-800000.sml) | [10.40](comparison/Python/qsort-800000.py) |   [0.15](comparison/Inpla/src/qsort-800000.in)   | [**0.11**](comparison/Inpla/src/qsort-800000-reuse.in) |
| msort 260000 | [0.39](comparison/Haskell/msort-800000.hs) | [0.29](comparison/OCaml/msort800000.ml) | [0.26](comparison/SML/msort-800000.sml) | [10.96](comparison/Python/msort-800000.py) | [**0.15**](comparison/Inpla/src/msort-800000.in) | [**0.15**](comparison/Inpla/src/msort-800000-reuse.in) |

#### Bug fix

* **`and` and `or` operations**: These operations had not work well due to bad effects of bytecode optimisations, and these has been fixed.

#### Changes
* **The benchmark table**: Bubble sort in Inpla has been changed to be done in the same method to others, and still Inpla keeps the fastest. 



### v0.8.2-1 minor update (released on 2 May 2022)

|              |                  Haskell                   |                  OCaml                  |                   SML                   |                   Python                   |                      Inpla8                      |                        Inpla8r                         |
| ------------ | :----------------------------------------: | :-------------------------------------: | :-------------------------------------: | :----------------------------------------: | :----------------------------------------------: | :----------------------------------------------------: |
| ack(3,11)    |   [2.30](comparison/Haskell/ack3-11.hs)    |   [0.46](comparison/OCaml/ack3_11.ml)   | [**0.43**](comparison/SML/ack3-11.sml)  |     [-](comparison/Python/ack3-11.py)      | [0.84](comparison/Inpla/src/ack-stream_3-11.in)  | [0.71](comparison/Inpla/src/ack-stream_3-11-reuse.in)  |
| fib 38       |    [1.60](comparison/Haskell/fib38.hs)     |  [**0.15**](comparison/OCaml/fib38.ml)  |    [0.27](comparison/SML/fib38.sml)     |     [8.88](comparison/Python/fib38.py)     |      [0.41](comparison/Inpla/src/fib-38.in)      |      [0.43](comparison/Inpla/src/fib-38-reuse.in)      |
| bsort 40000  | [34.48](comparison/Haskell/bsort-40000.hs) | [34.62](comparison/OCaml/bsort40000.ml) | [12.06](comparison/SML/bsort-40000.sml) | [79.53](comparison/Python/bsort-40000.py)  |   [3.02](comparison/Inpla/src/bsort-40000.in)    | [**2.52**](comparison/Inpla/src/bsort-40000-reuse.in)  |
| isort 40000  | [12.54](comparison/Haskell/isort-40000.hs) | [7.45](comparison/OCaml/isort40000.ml)  | [2.94](comparison/SML/isort-40000.sml)  | [36.89](comparison/Python/isort-40000.py)  | [**1.15**](comparison/Inpla/src/isort-40000.in)  |   [1.24](comparison/Inpla/src/isort-40000-reuse.in)    |
| qsort 260000 | [0.34](comparison/Haskell/qsort-800000.hs) | [0.25](comparison/OCaml/qsort800000.ml) | [0.27](comparison/SML/qsort-800000.sml) | [10.40](comparison/Python/qsort-800000.py) |   [0.15](comparison/Inpla/src/qsort-800000.in)   | [**0.12**](comparison/Inpla/src/qsort-800000-reuse.in) |
| msort 260000 | [0.39](comparison/Haskell/msort-800000.hs) | [0.29](comparison/OCaml/msort800000.ml) | [0.26](comparison/SML/msort-800000.sml) | [10.96](comparison/Python/msort-800000.py) | [**0.15**](comparison/Inpla/src/msort-800000.in) | [**0.15**](comparison/Inpla/src/msort-800000-reuse.in) |

#### Bug fix

* **Output format of integers** (again): Only these outputs had been fixed on v0.8.1-2, so these calculation and management had been 32-bit format. Now re-fixed as 64-bit format.

#### Changes

* In the benchmark table from this version Quick and Merge sorts are for smaller lists whose elements are 260000, while it was 400000. This is because OCaml raises stack overflow error for over 260000 elements. As shown the following graph, the speed-up ratio has changed not so good, while these sort works for 800000 elements have good performance. So, it seems that 260K elements are too small for Inpla to perform in parallel.

  ![speedup-ratio-v0.8.2-1-280k](pic/benchmark_reuse_v0.8.2-1-260K.png)

![speedup-ratio-v0.8.2-1](pic/benchmark_reuse_v0.8.2-1.png)

### v0.8.2 (released on 28 April 2022)

![speedup-ratio-v0.8.2](pic/benchmark_reuse_v0.8.2.png)

|              |                  Haskell                   |                  OCaml                  |                   SML                   |                   Python                    |                     Inpla8                      |                        Inpla8r                         |
| ------------ | :----------------------------------------: | :-------------------------------------: | :-------------------------------------: | :-----------------------------------------: | :---------------------------------------------: | :----------------------------------------------------: |
| ack(3,11)    |   [2.30](comparison/Haskell/ack3-11.hs)    |   [0.46](comparison/OCaml/ack3_11.ml)   | [**0.43**](comparison/SML/ack3-11.sml)  |      [-](comparison/Python/ack3-11.py)      | [0.83](comparison/Inpla/src/ack-stream_3-11.in) | [0.71](comparison/Inpla/src/ack-stream_3-11-reuse.in)  |
| fib 38       |    [1.60](comparison/Haskell/fib38.hs)     |  [**0.15**](comparison/OCaml/fib38.ml)  |    [0.27](comparison/SML/fib38.sml)     |     [8.88](comparison/Python/fib38.py)      |     [0.39](comparison/Inpla/src/fib-38.in)      |      [0.40](comparison/Inpla/src/fib-38-reuse.in)      |
| bsort 40000  | [34.48](comparison/Haskell/bsort-40000.hs) | [34.62](comparison/OCaml/bsort40000.ml) | [12.06](comparison/SML/bsort-40000.sml) |  [79.53](comparison/Python/bsort-40000.py)  | [**2.98**](comparison/Inpla/src/bsort-40000.in) |   [2.48](comparison/Inpla/src/bsort-40000-reuse.in)    |
| isort 40000  | [12.54](comparison/Haskell/isort-40000.hs) | [7.45](comparison/OCaml/isort40000.ml)  | [2.94](comparison/SML/isort-40000.sml)  |  [36.89](comparison/Python/isort-40000.py)  | [**1.15**](comparison/Inpla/src/isort-40000.in) |   [1.21](comparison/Inpla/src/isort-40000-reuse.in)    |
| qsort 800000 | [1.56](comparison/Haskell/qsort-800000.hs) |  [-](comparison/OCaml/qsort800000.ml)   | [1.14](comparison/SML/qsort-800000.sml) | [97.37](comparison/Python/qsort-800000.py)  |  [0.66](comparison/Inpla/src/qsort-800000.in)   | [**0.37**](comparison/Inpla/src/qsort-800000-reuse.in) |
| msort 800000 | [1.55](comparison/Haskell/msort-800000.hs) |  [-](comparison/OCaml/msort800000.ml)   | [1.04](comparison/SML/msort-800000.sml) | [100.04](comparison/Python/msort-800000.py) |  [0.48](comparison/Inpla/src/msort-800000.in)   | [**0.35**](comparison/Inpla/src/msort-800000-reuse.in) |

#### New Features

* **A built-in agent** `Eraser`: it disposes any nets gradually with the following rules:

![Eraser](pic/eraser.png)

#### Bug fix
* **The benchmark table was wrong**: With respect to the results in Haskell, the execution times of sort works were too short. This is thanks to its lazy evaluation strategy, quite nice, that gets only the first 10 elements the same as the written program, though these are expected to be taken after finishing these sort works. So, every sort work will be followed by a validation check if a given list is correctly sorted, not only in Haskell but also in others.



### v0.8.1-2 minor update (released on 16 April 2022)

#### Bug fix
* **Output format of integers**: Integer numbers had been outputted with 32-bit format, though it is manages as 61bit FIXINT. Now these are looked as long integers.


#### Polished

* **The benchmark table**: Several OCaml execution times have been added to the benchmark table. These programs are stored in `comparison/OCaml`.



### v0.8.1-1 minor update (released on 10 March 2022)

#### Polished

* **Sample file (Tower of Hanoi)**: A new sample file for Tower of Hanoi is included in `sample` directory.

* **The abbreviation**: it can take an empty arguments list on its left-hand side like:

  ```
  << Agent(paramlist,param)    // this is an abbreviation for Agent(paramlist)~param
  ```

  This could be handy for elimination operation:

  ```
  Eps >< Z =>;
  Eps >< S(x) => Eps~x;
  
  // Nets
  Eps ~ S(Z);
  
  // Abbreviated notation of the nets
  << Eps(S(Z));
  ```

* **Makefile**: The configuration file `src/config.h` is also included as update files in `Makefile`. So, `make` command works when the configuration file is changed.

* **Rule table**: A simple implementation with arrays is prepared. It could be expected to work better, but it seems not so differences. It becomes available by making the following definition un-comment in `src/config.h`:

  ```
  // ------------------------------------------------
  // RuleTable
  // ------------------------------------------------
  // There are two implementation for the rule table:
  //   * Hashed linear table (default)
  //   * Simple array table
  // To use the hashed one, comment out the following RULETABLE_SIMPLE definition.
  
  //#define RULETABLE_SIMPLE
  ```

  

  


### v0.8.1 (released on 3 March 2022)

|              | Haskell  |   SML    | Python | Inpla1 | Inpla1_r | Inpla7 | Inpla7_r |
| ------------ | :------: | :------: | :----: | :----: | :------: | :----: | :------: |
| ack(3,11)    |   2.31   | **0.41** |   -    |  4.32  |   3.49   |  0.86  |   0.73   |
| fib 38       |   1.60   | **0.26** |  8.49  |  2.29  |   2.80   |  0.43  |   0.45   |
| bsort 40000  |  34.81   |  11.17   | 76.72  | 18.01  |  16.42   |  2.79  | **2.61** |
| isort 40000  | **0.02** |   2.97   | 36.63  |  6.98  |   8.08   |  1.22  |   1.30   |
| qsort 800000 | **0.15** |   1.16   | 97.30  |  6.09  |   1.79   |  0.63  |   0.37   |
| msort 800000 |   0.46   |   1.00   | 98.27  |  3.93  |   1.35   |  0.46  | **0.35** |

#### New Features:
* **Introduced a configuration file**: A configuration file `src/config.h` is introduced such as for optimisation and heap data structures. Change it as your programs can be executed faster.

* **Two address codes**: Virtual machines and the compiler support two-address codes. It seems that these could work efficiently but not so significant, a little fluctuated, so I am not sure that it is strongly recommendable. Actually I stopped applying this method for arithmetic operations and other MKAGENT operations. A section is prepared in the configuration file `src/config.h`, so select your appropriate level by making these comments out.

  ```
  // Generate virtual machine codes with two-address notation
  #define OPTIMISE_TWO_ADDRESS
  
  #ifdef OPTIMISE_TWO_ADDRESS
  #define OPTIMISE_TWO_ADDRESS_MKAGENT1 // For MKAGENT1
  #define OPTIMISE_TWO_ADDRESS_MKAGENT2 // For MKAGENT2
  #define OPTIMISE_TWO_ADDRESS_MKAGENT3 // For MKAGENT3
  //#define OPTIMISE_TWO_ADDRESS_UNARY // For Unary operator like INC, DEC
  #endif  
  ```

#### Polished:

* **Retrieved the old version of expandable ring buffers**: The old version of the expandable ring buffer has been retrieved. One heap structure could work well for some problems, but it might not so well for others. Choose an appropriate heap structure by making the following comments out in the configuration file `src/config.h`:

  ```
  /* Heaps ------------------------------------------ 
     Choose one among the following three definitions:
     -------------------------------------------------- */
  #define FLEX_EXPANDABLE_HEAP     // Inserted heaps size can be flexible.
  //#define EXPANDABLE_HEAP        // Expandable heaps for agents and names
  //#define FIXED_HEAP             // The heap size is fixed. (Default)
  ```

  

  


### v0.8.0 (released on 27 February 2022)

|              | Haskell  |   SML    | Python | Inpla1 | Inpla1_r | Inpla7 | Inpla7_r |
| ------------ | :------: | :------: | :----: | :----: | :------: | :----: | :------: |
| ack(3,11)    |   2.31   | **0.41** |   -    |  4.42  |   3.53   |  0.88  |   0.75   |
| fib 38       |   1.60   | **0.26** |  8.49  |  2.30  |   2.83   |  0.42  |   0.46   |
| bsort 40000  |  34.81   |  11.17   | 76.72  | 17.64  |  16.92   |  2.75  | **2.70** |
| isort 40000  | **0.02** |   2.97   | 36.63  |  6.72  |   8.34   |  1.20  |   1.34   |
| qsort 800000 | **0.15** |   1.16   | 97.30  |  6.07  |   1.81   |  0.64  |   0.37   |
| msort 800000 |   0.46   |   1.00   | 98.27  |  3.92  |   1.36   |  0.46  | **0.35** |

#### New Features:

* **Flexibly expandable ring buffer for agents and names**: We can change the size of buffers that are inserted when all of nodes run up, though it was fixed before. It is possible to start a small heap for small computation, and it can be expanded for larger computation.

  ![speedup-ratio](pic/flexibily_expandable.png)

  * To set the initial size to 2^*n*, use the execution option `-Xms n` (default `n` is 12, so the size is 4096):
  * To set the multiple increment to 2^*n*, use the option `-Xmt n` (default `n` is 3, so the inserted heap is 8 times of the run up heap)

  To use the fixed sized ring buffer, comment out the following definition in `src/inpla.y`:

  ```
  #define EXPANDABLE_HEAP    // Expandable heaps for agents and names
  ```



### v0.7.3 (released on 20 February 2022)

|              | Haskell  |   SML    | Python | Inpla1 | Inpla1_r | Inpla7 | Inpla7_r |
| ------------ | :------: | :------: | :----: | :----: | :------: | :----: | :------: |
| ack(3,11)    |   2.31   | **0.41** |   -    |  4.75  |   3.47   |  1.49  |   0.73   |
| fib 38       |   1.60   | **0.26** |  8.49  |  2.39  |   2.89   |  0.48  |   0.51   |
| bsort 40000  |  34.81   |  11.17   | 76.72  | 15.56  |  17.16   |  3.99  | **2.81** |
| isort 40000  | **0.02** |   2.97   | 36.63  |  7.66  |   8.38   |  2.01  |   1.38   |
| qsort 800000 | **0.15** |   1.16   | 97.30  |  2.32  |   1.82   |  0.56  |   0.36   |
| msort 800000 |   0.46   |   1.00   | 98.27  |  1.23  |   1.37   |  0.42  | **0.33** |

#### Polished:

* **Bytecode optimisation inspired by Tail Recursive Optimisation**:  As a result, this optimisation brings about faster computation up to about twice in comparison with no reuse-annotated computation.

  * When an interaction rule has a connection whose both sides agents have the same IDs to the active pair, computation of the connection can be realised by applying the same bytecode sequence of the rule to the connection after replacing ports of the active pair into agents ports of the connection. Moreover, when the connection is placed at the tail of a connection sequence, we can restart the same bytecode sequence after replacing these ports. For instance, take the following rule for Fibonacci number:

    ```
    fib(ret) >< (int n)
    | n == 0 => ret~0
    | n == 1 => ret~1
    | _ => Add(ret, cnt2)~cnt1, fib(cnt1)~(n-1), fib(cnt2)~(n-2);
    ```
    This rule has a connection `fib(cnt2)~(n-2)` at the tail of the third connection sequence. The connection is computable by using the same bytecode sequence of `fib(ret)><(int n)` with replacing these ports `ret`,  `n` into `cnt2`, `n-2`, respectively. So, the computation of the third connection sequence is realised by bytecode sequences of the other connections and the port replacing, and a loop operation to start execution from the top of the rule sequence.

  * This is also possible not only for agents like `(int n)`, but also other constructor agents such as `Cons(x,xs)`, `S(x)`. The following is a part of rules for insertion sort:

    ```
    isort(ret) >< x:xs => insert(ret, x)~cnt, isort(cnt)~xs;
    ```
    When the `xs` connects to an `Cons(y,ys)` agent, then the computation is also realised by the loop operation because the `isort(cnt)~xs` can be regarded as `isort(cnt)~y:ys`, whose agents have the same IDs of the active pair. So, by introducing a conditional branch whether the `xs` connects to a `Cons` agent or not, this rule computation is also realised by the loop operation.
  
  * In this version, this optimisation will be triggered when such the connection is placed at the tail of a sequence of connections.



### v0.7.2-1 (released on 12 February 2022)

#### Bug Fix:
* **Bytecode generation**: A bytecode sequence for `EQI src fixint dest` was generated as `EQI src int dest`, so it was fixed.
* **Bytecode optimisation**:  Blocks for scopes of Copy Propagation optimisation were not specified for each guard expression. It was fixed and works well.




### v0.7.2 (released on 9 February 2022)

#### Polished:
* **Bytecodes for global names**: To obtain a global name whose name is `sym` on a `dest` register, the following bytecode is executed: `MKGNAME dest sym` where the type of `sym` is `char*`.  Every symbol for agents and global names is assigned to the unique ID number managed by `IdTable`, so by introducing the ID number `id` for the `sym`, the bytecode is changed into `MKGNAME id dest`.
* **Separation of source codes of NameTable**: The `NameTable` is used to lookup ID numbers for symbol chars in compilation and interpreter execution. By changing the bytecode of `MKGNAME`, there becomes no need to be used in virtual machine execution directly, so the source codes for the `NameTable` is separated from `src/inpla.y`. This contributes quite a little speed-up at most 1%.



### v0.7.1 (released on 4 February 2022)
|              | Haskell  |   SML    | Python | Inpla1 | Inpla1_r | Inpla7 | Inpla7_r |
| ------------ | :------: | :------: | :----: | :----: | :------: | :----: | :------: |
| ack(3,11)    |   2.31   | **0.41** |   -    |  4.78  |   3.55   |  1.51  |   0.74   |
| fib 38       |   1.60   | **0.26** |  8.49  |  3.10  |   2.95   |  0.60  |   0.50   |
| bsort 40000  |  34.81   |  11.17   | 76.72  | 24.85  |  18.22   |  7.39  | **2.92** |
| isort 40000  | **0.02** |   2.97   | 36.63  | 11.85  |   8.71   |  3.65  |   1.41   |
| qsort 800000 | **0.15** |   1.16   | 97.30  |  3.54  |   1.88   |  0.83  |   0.34   |
| msort 800000 |   0.46   |   1.00   | 98.27  |  2.26  |   1.32   |  0.60  | **0.33** |

#### Polished:

* **Bytecodes**: Bytecodes of virtual machines are expressed by three address codes ordered as `op dest src1 src2`. The order is changed to the ordinary one `op src1 src2 dest`. 

* **Bytecode optimisation**: The following is introduced:

  - A sequence `OP_EQI_RO reg` `OP_JMPEQ0_R0 pc` is optimised into a code `JMPNEQ0 reg pc`.
  - By introducing a bytecode `OP_INC src dest`, a code `OP_ADDI src $1 dest` and a code`OP_ADDI $1 src dest` are optimised into `OP_INC src dest`. 
  - By introducing a bytecode `OP_DEC src dest`, a code `OP_SUBI src $1 dest` is optimised into `OP_DEC src dest`.

* **Intermediate code for blocks**: To show scope of blocks, an intermediate code `OP_BEGIN_BLOCK` is introduced. Copy Propagation for `OP_LOAD` and `OP_LOADI` is performed until the next `OP_BEGIN_BLOCK` occurs.

  

### v0.7.0 (released on 30 January 2022)
|              | Haskell  |   SML    | Python | Inpla1 | Inpla1_r | Inpla7 | Inpla7_r |
| ------------ | :------: | :------: | :----: | :----: | :------: | :----: | :------: |
| ack(3,11)    |   2.31   | **0.41** |   -    |  5.22  |   3.86   |  1.52  |   0.81   |
| fib 38       |   1.60   | **0.26** |  8.49  |  3.52  |   3.31   |  0.62  |   0.55   |
| bsort 40000  |  34.81   |  11.17   | 76.72  | 25.76  |  18.21   |  7.36  | **2.87** |
| isort 40000  | **0.02** |   2.97   | 36.63  | 11.97  |   8.62   |  3.64  |   1.44   |
| qsort 800000 | **0.15** |   1.16   | 97.30  |  3.55  |   1.87   |  0.82  |   0.35   |
| msort 800000 |   0.46   |   1.00   | 98.27  |  2.29  |   1.34   |  0.60  | **0.33** |

#### New Features:

* **Logical operators on integers**: Not `!` (`not`), And `&&` (`and`)  and Or `||` (`or`) are available.  Only `0` is regarded as False and these operators return `1` for Truth, `0` for False.

* **Bytecode optimisations**: Bytecodes are optimised by Copy propagation, Dead code elimination methods. In addition, Register0 is used to store comparison results, and conditional branches are performed according to the value of Register0. To prevent those optimisation, comment out the following definition `OPTIMISE_IMCODE` in `src/inpla.y`:

  ```
  #define OPTIMISE_IMCODE    // Optimise the intermediate codes
  ```

  

### v0.6.2 (released on 20 January 2022)
|              | Haskell  |   SML    | Python | Inpla1 | Inpla1_r | Inpla7 | Inpla7_r |
| ------------ | :------: | :------: | :----: | :----: | :------: | :----: | :------: |
| ack(3,11)    |   2.31   | **0.41** |   -    |  5.46  |   4.16   |  1.56  |   0.86   |
| fib 38       |   1.60   | **0.26** |  8.49  |  3.93  |   3.68   |  0.69  |   0.62   |
| bsort 40000  |  34.81   |  11.17   | 76.72  | 25.75  |  19.06   |  7.32  | **3.14** |
| isort 40000  | **0.02** |   2.97   | 36.63  | 12.38  |   9.25   |  3.64  |   1.53   |
| qsort 800000 | **0.15** |   1.16   | 97.30  |  3.83  |   1.91   |  0.77  |   0.35   |
| msort 800000 |   0.46   |   1.00   | 98.27  |  2.39  |   1.39   |  0.69  | **0.41** |

#### New Features:

* **Retaining the big ring buffer**:  The new expandable buffer for agents and names require extra costs sometimes, so the old one, that is the big ring buffer, is embedded into programs sources. Comment out the following definition `EXPANDABLE_HEAP` in `src/inpla.y` when the old one is needed:

  ```
  #define EXPANDABLE_HEAP    // Expandable heaps for agents and names
  ```

  


### v0.6.1 (released on 12 January 2022)
#### New Features:
* **Introduced automatically expandable equation stacks**: Stacks for equations are automatically expanded when the stacks overflow. The unit size is 256, so each stack size in virtual machines starts from 256, and these will be twice (256), triple (768) and so on. The unit size is specified by the execution option `-e`. For instance, Inpla invoked with `-e 1024` assigns a 1024-size equation stack for each thread. As for the global equation stack, it is also automatically expandable, but the initial size is specified as `(the number of threads) * 8` in the `main` function as follows, so change it to improve the execution performance if it is needed:

  ```
  GlobalEQStack_Init(MaxThreadsNum*8);
  ```

  


### v0.6.0 (released on 9 January 2022)

|              | Haskell  |   SML    | Python | Inpla1 | Inpla1_r | Inpla7 | Inpla7_r |
| ------------ | :------: | :------: | :----: | :----: | :------: | :----: | :------: |
| ack(3,11)    |   2.31   | **0.41** |   -    |  5.54  |   4.57   |  1.58  |   0.92   |
| fib 38       |   1.60   | **0.26** |  8.49  |  3.96  |   3.83   |  0.67  |   0.62   |
| bsort 40000  |  34.81   |  11.17   | 76.72  | 26.31  |  21.07   |  7.39  | **3.41** |
| isort 40000  | **0.02** |   2.97   | 36.63  | 12.59  |  10.03   |  3.65  |   1.63   |
| qsort 800000 | **0.15** |   1.16   | 97.30  |  3.79  |   2.04   |  0.77  |   0.37   |
| msort 800000 |   0.46   |   1.00   | 98.27  |  2.50  |   1.45   |  0.64  | **0.39** |

#### New Features:

* **Introduced new data structure for ring buffers for agents and names**: The ring buffers are automatically expanded when all elements of these are used up. Each size starts from 2^18 (=262144), and it will be twice, triple and so on automatically. To adjust the unit size, change the following definition in `src/inpla.y`:

  ```
  #define HOOP_SIZE (1 << 18)
  ```

* **Deleted the execution option `-c` that specifies the size of these ring buffers**: This execution option is deleted because these buffers are expanded as needed.



### v0.5.6 (released on 6 January 2022)
|              | Haskell  |   SML    | Python | Inpla1 | Inpla1_r | Inpla7 | Inpla7_r |
| ------------ | :------: | :------: | :----: | :----: | :------: | :----: | :------: |
| ack(3,11)    |   2.31   | **0.41** |   -    |  4.89  |   4.45   |  0.97  |   0.90   |
| fib 38       |   1.60   | **0.26** |  8.49  |  3.74  |   3.70   |  0.57  |   0.56   |
| bsort 40000  |  34.81   |  11.17   | 76.72  | 25.74  |  19.82   |  6.39  | **3.07** |
| isort 40000  | **0.02** |   2.97   | 36.63  | 12.41  |   9.37   |  3.04  |   1.49   |
| qsort 800000 | **0.15** |   1.16   | 97.30  |  2.02  |   1.63   |  0.75  |   0.40   |
| msort 800000 |   0.46   |   1.00   | 98.27  |  1.29  |   1.28   |  0.65  | **0.43** |

#### Bug Fix:

* The index of the ring buffer for agents had not been correctly initialised. It was fixed the same as the way of the ring buffer for  names.



### Logo of Inpla (released on 27 December 2021)
* A logo is released as an idea:

  ![inpla-logo](pic/inpla-logo.png)





### v0.5.5 (released on 19 December 2021)
#### Bug Fix (minor):
* The name `x` in a connection `x~s` should be substituted if the `x` occurs on a term in other connections, but it should be done if the `x` is specified by `int` modification. But every name had been a target of the substitution, so it was fixed.



### v0.5.4 (released on 18 November 2021)
#### Bug Fix (minor):
* When there is a connection `x~s` in nets or rules, the other occurrence of the name `x` will be replaced with the `s`, as one of optimisations. It had been done only when the other is just a name, that is, not a subterm, so it was fixed now.



### v0.5.3 (released on 14 November 2021)
#### New Features (for constants):
* Constants are also specified by an execution option switch `-d` in the format *NAME*=*i*. For instance, when Inpla is invoked with `-d ELEM=1000`, then the `ELEM` is replaced with `1000` during the execution.

* Constants are defined as immutable, so these values cannot be changed. When a file specified by the `-f` option has constant names specified by the `-d` options, these names are bound to the values given by the `-d` options.



### v0.5.2 (released on 10 November 2021)
#### Bug Fix (minor):
* `Free` command did not work for integer numbers, due to the change by v0.5.1, and it was fixed.



### v0.5.1 (released on 2 November 2021)
#### Bug Fix:
* Terms in which the same name occurs twice, such as `A(x,x)`, can be freed safely by the `free` command.



### v0.5.0 (released on 28 October 2021)
#### New Features:
* **Abbreviation notation**: An abbreviation notation `<<` is introduced. The following description:

  ```
  a,b,...,z << Agent(aa,bb,...,yy,zz)
  ```

  is rewritten internally as follows:

  ```
  Agent(a,b,...,z,aa,bb,...,yy) ~ zz
  ```

  For instance, `r << Add(1,2)` is rewritten internally as `Add(r,1)~2`. It is handy to denote ports that take computation results. As a special case we prepare a built-in abbreviation for the built-in agent `Append(a,b)` because the order of those arguments `a`, `b` is different from the abbreviation rewriting rule:

  ```
  ret << Append(a,b)  --- rewritten as ---> Append(ret,b)~a
  ```

* **Merger agent that merges two lists into one**: Merger agent is implemented, such that it has two principal ports for the two lists, and whose interactions are performed as soon as one of the principal ports is ready for the interaction, that is to say, connected to a list. So, the merged result is decided non-deterministically, especially in multi-threaded execution.
  
  ![merger](pic/merger.png)
  
  We overload `<<` in order to use the Merger agent naturally as follows:

  ```
  ret << Merger(alist, blist)
  ```

* **Built-in rules for arithmetic operations between two agents**: These are implemented, and these operations are managed agents `Sub`, `Mul`, `Div`, `Mod`:

  ```
  >>> r1 << Add(3,5), r2 << Sub(r1,2);
  >>> ifce;      // put all interface (living names) and connected nets.
  r2
  
  Connections:
  r2 ->6
  
  >>>
  ```


### v0.4.2 (released on 16 October 2021)
|              | Haskell  |   SML    | Python | Inpla1 | Inpla1_r | Inpla7 | Inpla7_r |
| ------------ | :------: | :------: | :----: | :----: | :------: | :----: | :------: |
| ack(3,11)    |   2.31   | **0.41** |   -    |  4.76  |   4.36   |  0.98  |   0.88   |
| fib 38       |   1.60   | **0.26** |  8.49  |  3.59  |   3.56   |  0.56  |   0.54   |
| bsort 40000  |  34.81   |  11.17   | 76.72  | 22.85  |  18.40   |  5.53  | **2.94** |
| isort 40000  | **0.02** |   2.97   | 36.63  | 10.59  |   8.74   |  2.59  |   1.43   |
| qsort 800000 | **0.15** |   1.16   | 97.30  |  1.85  |   1.55   |  0.76  |   0.41   |
| msort 800000 | **0.46** |   1.00   | 98.27  |  1.18  |   1.34   |  0.65  |   0.49   |

#### Improved:

* Line edit was improved to support multi-line paste, according to the following suggestion: https://github.com/antirez/linenoise/issues/43
* History in Line edit becomes available.

#### Bug Fix:
* Long length lists are printed out as abbreviation of 14-length lists.



### v0.4.1 (released on 24 September 2021)
#### Improved:
* Line edit is improved so that history can be handled by linenoise:
  https://github.com/antirez/linenoise

* The priority of rules are changed so that user defined rules can be taken before built-in rules.

#### Bug Fix:
* Constants, which cannot be deleted, had been deleted when they are referred to. It was fixed to be kept.



### v0.4.0 (released on 17 September 2021)
#### New Features: 
* Nested guards are supported. As shown in below, nested guards are supported now:

  ```
  A(r)><B(int a, int b)
  | a==1 =>
         | b==0 => r~10
         | _    =>
                 | a+b>10 => r~20
  	       | _      => r~2000
  | _ => r~100;
  ```

* Strings that have brackets, such as `inc(x)`, are recognised as agents even if these starts from a not capital letter.


* Built-in rules that match each element for the same built-in agents are implemented. For instance, the following rules are realised as built-in:

  ```
  a:b >< x:y => a~x, b~y;
  [] >< [] =>;
  (a,b) >< (x,y) => a~x, b~y; 
  ```



### v0.3.2 (released on 3 August 2021)
#### New Features: 
* WHNF strategy is supported with -w option. Weak Head Normal Form strategy is available when the Inpla is invoked with -w option. The following is an execution log:

  ```
  $ ./inpla -w
  Inpla 0.32 (WHNF) : Interaction nets as a programming language [3 August 2021]
  >>> use "sample/processnet1.in";
  (2 interactions, 0.00 sec)
  >>> ifce;     # show interfaces
  r 
  >>> r;        # show the connected net from the `r'
  [1,<a1>...
  >>> h:t ~ r;  # decompose it as h:t
  (3 interactions, 0.00 sec)
  >>> ifce;
  h t 
  >>> h;
  1
  >>> t;
  [2,<b1>...
  >>> 
  ```

  

### v0.3.1 (released on 7 May 2021)
#### New Features: 
* New notation for the built-in `Cons` agent, `h:t`. The built-in Cons agent is also written as `h:t`, besides `[h|t]`. For instance, a reverse list operation is written as follows:

  ```
  Rev(ret, acc) >< [] => ret ~ acc;
  Rev(ret, acc) >< h:t => Rev(ret, h:acc) ~ t;
  
  Rev(ret,[]) ~ [1,3,5,8];
  ret; // -> [8,5,3,1]
  ```

* The built-in agent for integer numbers is introduced. Integer numbers are recognised as agents. In addition:

  - expressions on attributes are written as agents.
  - `Add(ret, m)><(int n)` is implemented as a built-in rule.

  For instance, Fibonacci number is obtained as follows:

  ```
  Fib(ret) >< (int n)
  | n == 0 => ret~0
  | n == 1 => ret~1
  | _ => Add(ret,cnt2)~cnt1, Fib(cnt1)~(n-1), Fib(cnt2)~(n-2);
  
  Fib(r)~38;
  r; // it should be 39088169.
  ```

  As another example, the greatest common divisor is obtained as follows:

  ```
  Gcd(ret, int a) >< (int b)
  | b==0 => ret~a
  | _ => Gcd(ret, b) ~ (a%b);
  
  Gcd(r, 14) ~ 21;
  r; // it should be 7
  ```

* Append for two lists is implemented as built-in as follows:

  ```
  Append(r,[1,2,3])~[7,8,9];
  r; // it should be [7,8,9,1,2,3]
  ```

  
