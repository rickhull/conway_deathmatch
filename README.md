Introduction
===

[Conway's Game of Life](http://en.wikipedia.org/wiki/Conway%27s_Game_of_Life)
is a small, simple set of rules for
[cellular automata](http://en.wikipedia.org/wiki/Cellular_automaton).
Operating like a simulation, there is a starting state where certain points on
a 2 dimensional board are populated, and the rules of the game determine the
next state, generating interesting, unpredictable, and ultimately lifelike
patterns over time.

This project was inspired by http://gameoflifetotalwar.com/ (hereafter CGOLTW).
You should check it out.  It updates the classic set of rules, which support
only a single population, for multiple populations which are able to compete
for space and population.

This project exists not to compete with CGOLTW but as a supplementary
project for exploration and learning.  My initial motivation was to make a
"proving ground" for searching for simple shapes and patterns with high birth
rates for determining successful CGOLTW strategies. 

Caveats
---

As currently implemented, this project uses fixed boundaries, and boundary
behavior is not standardized to my knowledge.  For this project, out of bounds
are treated as always-dead and unable-to-be-populated.

The rules for multiplayer are not standardized.  I read about the CGOLTW
approach, and this project's approach is similar but different.  In CGOLTW,
there are always 3 populations, and one population (civilians) is special, in
that civilians are born where there is birthright contention.  Birthright
contention happens when a new cell must be generated, but none of the
neighboring parents have a unique plurality.  For this project, birthright
contention is resolved with a random selection (TODO).

Install
===

    gem install conway_deathmatch

Demo
===

    # defaults to 70x40 board and an acorn shape
    conway_deathmatch
    
    # multiplayer
    conway_deathmatch --one="acorn 30 30" --two="die_hard 20 10"

Available Shapes
===

[Definitions](https://github.com/rickhull/conway_deathmatch/blob/master/lib/conway_deathmatch/data/shapes.yaml)

* acorn
* beacon
* beehive
* blinker
* block
* block_engine_count (block engine, minimal point count)
* block_engine_space (block engine, minimal footprint)
* block_engine_stripe (block engine, 1 point tall)
* boat
* die_hard
* glider
* loaf
* lwss (lightweight spaceship)
* rpent (R-pentomino)
* swastika
* toad

Implementation
===

Just one file, aside from shape loading.  [Have a look-see](https://github.com/rickhull/conway_deathmatch/blob/master/lib/conway_deathmatch.rb)

This implementation focuses on simplicity and ease of understanding.  Currently
there are no performance optimizations.  I would like to use this project
to demonstrate the process of optimization, ideally adding optimization on
an optional, parallel, or otherwise non-permanent basis -- i.e. maintain the
simple, naive implementation for reference and correctness.
