[![Build Status](https://travis-ci.org/rickhull/conway_deathmatch.svg?branch=master)](https://travis-ci.org/rickhull/conway_deathmatch)
[![Gem Version](https://badge.fury.io/rb/conway_deathmatch.svg)](http://badge.fury.io/rb/conway_deathmatch)
[![Code Climate](https://codeclimate.com/github/rickhull/conway_deathmatch/badges/gpa.svg)](https://codeclimate.com/github/rickhull/conway_deathmatch)
[![Dependency Status](https://gemnasium.com/rickhull/conway_deathmatch.svg)](https://gemnasium.com/rickhull/conway_deathmatch)
[![Security Status](https://hakiri.io/github/rickhull/conway_deathmatch/master.svg)](https://hakiri.io/github/rickhull/conway_deathmatch/master)

Introduction
===

[Conway's Game of Life](http://en.wikipedia.org/wiki/Conway%27s_Game_of_Life)
is a small, simple set of rules for
[cellular automata](http://en.wikipedia.org/wiki/Cellular_automaton).
Operating like a simulation, there is a starting state where certain points on
a 2 dimensional board are populated, and the rules of the game determine the
next state, generating interesting, unpredictable, and ultimately lifelike
patterns over time.

Rules
---
Cells die or stay dead, unless:
* Birth rule: 3 neighboring cells turn dead to alive
* Survival rule: 2 or 3 neighboring cells prevent a live cell from dying

On "Deathmatch"
---
The traditional set of rules tracks a single population, even though it may
form several distinct islands and disjointed groups.  For this project,
*deathmatch* refers to multiple populations with respective identities over
time (e.g. red vs blue).

Deathmatch Rules
---
Choose:
* Defensive: Alive cells never switch sides
  - This is the rule followed by the *Immigration* variant of CGoL, I believe
* Aggressive: Alive cells survive with majority
  - 3 neighbors: clear majority (e.g. 2 red, 1 blue)
  - 2 neighbors: coin flip (e.g. 1 red, 1 blue)
* Friendly: Just count friendlies
  - Enemies don't count, party on! (e.g. 3 red, 2 blue)

Usage
===

Requirements
---

* Ruby 2.0 or newer (`__dir__` is used in the gemspec and for shape loading)


Install
---

    gem install conway_deathmatch

Demo
---

    # defaults to 70x40 board and an acorn shape
    conway_deathmatch

    # deathmatch triggered by several populations
    conway_deathmatch --one "acorn 30 30" --two "diehard 20 10"

Available Shapes
---

A shape is simply a set of points.  Classic shapes are [defined in a yaml file](https://github.com/rickhull/conway_deathmatch/blob/master/lib/conway_deathmatch/shapes/classic.yaml):

* acorn
* beacon
* beehive
* blinker
* block
* block_engine_count (block engine, minimal point count)
* block_engine_space (block engine, minimal footprint)
* block_engine_stripe (block engine, 1 point tall)
* boat
* diehard
* glider
* loaf
* lwss (lightweight spaceship)
* rpent (R-pentomino)
* swastika
* toad

There is [another yaml file](https://github.com/rickhull/conway_deathmatch/blob/master/lib/conway_deathmatch/shapes/discovered.yaml) with shapes discovered via [proving_ground](https://github.com/rickhull/conway_deathmatch/blob/master/bin/proving_ground).


Implementation
===

Just one file, aside from shape loading: [Have a look-see](https://github.com/rickhull/conway_deathmatch/blob/master/lib/conway_deathmatch/board_state.rb)

Boundaries are toroidal, meaning that cells "wrap" at the edges, such that the left edge is adjacent to the right edge, and likewise with top and bottom. Thus, the grid has the topography of a torus (i.e. doughnut).

Inspiration
---
This project was inspired by http://gameoflifetotalwar.com/ (hereafter CGOLTW).
You should check it out.  It updates the classic set of rules, which support
only a single population, for multiple populations which are able to compete
for space and population.

This project exists not to compete with CGOLTW but as a supplementary
project for exploration and learning.  My initial motivation was to make a
"[proving ground](https://github.com/rickhull/conway_deathmatch/blob/master/bin/proving_ground)" for searching for simple shapes and patterns with high birth
rates for determining successful CGOLTW strategies.

Coming into this project, I had significant background knowledge concerning
Conway's Game of Life, but I could not have recited the basic rules in any
form. After being inspired by competing in CGOLTW, I read their [one background
page](http://gameoflifetotalwar.com/how-to-play) and then the
[wikipedia page](http://en.wikipedia.org/wiki/Conway%27s_Game_of_Life).  I
deliberately avoided any knowledge of any other implementations,
considering this project's implementation as of December 5 (2014) to be the
naive, simple approach.
