# USI Protocol Notes

Source: https://shogidokoro2.stars.ne.jp/usi.html

These notes capture the protocol facts needed for engine automation so the source page does not need to be opened for routine work.

## General Rules

- USI means Universal Shogi Interface.
- GUI and engine communicate by line-oriented text commands over standard input/output.
- Commands and protocol tokens use ASCII letters, digits, and spaces.
- Separate command names and arguments with spaces.
- Every line sent by either side must end with newline.
- Engines must be able to receive commands even while thinking.

## Standard Startup Sequence

GUI to engine:

```text
usi
```

Engine responds with zero or more identification/option lines, then `usiok`:

```text
id name <program name>
id author <program author>
option name <optionname> type <optiontype> ...
usiok
```

Before starting analysis or a game:

```text
setoption name <id> value <x>
isready
```

Engine responds:

```text
readyok
```

Then send:

```text
usinewgame
```

When finished:

```text
quit
```

## Position Command

Use `position` to set the position to analyze.

Initial position with moves:

```text
position startpos moves 7g7f 3c3d
```

Arbitrary SFEN position:

```text
position sfen <board> <side-to-move> <hands> <move-number>
```

Arbitrary SFEN plus moves:

```text
position sfen <sfen> moves <move1> ... <moveN>
```

Send `position` before every `go`.

Use `moves` to advance the root position before analysis. This is the standard way to ask the engine to evaluate a candidate continuation without manually constructing a new SFEN.

## SFEN Essentials

- Board rows are written from rank 1 to rank 9, and within each rank from file 9 to file 1.
- Pieces are `K R B G S N L P` for black and lowercase for white.
- Promoted pieces are prefixed by `+`, such as `+P` or `+r`.
- Consecutive empty squares are compressed as digits.
- Ranks are joined with `/`.
- Side to move is `b` for black/sente and `w` for white/gote.
- Hands use piece letters, with count before the piece for counts of 2 or more. No hands is `-`.
- SFEN includes a move number. For arbitrary positions, `1` is commonly acceptable.

## USI Move Notation

- Board squares use file number `1` through `9` and rank letter `a` through `i`.
- Rank `a` is rank 1, `b` is rank 2, ..., `i` is rank 9.
- A normal move is `<from><to>`, such as `7g7f`.
- Promotion appends `+`, such as `8h2b+`.
- A drop is `<piece>*<to>`, such as `G*5b`.

## Go Commands

Start ordinary search:

```text
go
```

Common time forms:

```text
go btime <ms> wtime <ms> byoyomi <ms>
go btime <ms> wtime <ms> binc <ms> winc <ms>
go byoyomi <ms>
```

Infinite search:

```text
go infinite
stop
```

For `go infinite`, the engine should not return `bestmove` until `stop`.

Mate search:

```text
go mate <milliseconds>
go mate infinite
```

Mate search returns `checkmate ...`, not `bestmove`.

Pondering:

```text
go ponder
ponderhit
stop
```

For `go ponder`, the engine should wait for `ponderhit` or `stop` before returning `bestmove`.

## Engine Output

Best move:

```text
bestmove <move>
bestmove <move> ponder <reply>
bestmove resign
bestmove win
```

Thinking information:

```text
info depth <n> score cp <centipawns> pv <move1> ...
info depth <n> score mate <n> pv <move1> ...
info multipv <n> score cp <centipawns> pv <move1> ...
```

Important `info` fields:

- `depth`: search depth.
- `seldepth`: selective depth.
- `time`: elapsed milliseconds.
- `nodes`: searched node count.
- `nps`: nodes per second.
- `hashfull`: hash usage per mille.
- `score cp <x>`: centipawn score from the engine side, pawn = 100.
- `score mate <n>`: mate score. Positive means the engine is mating; negative means the engine is getting mated.
- `lowerbound` / `upperbound`: score is a bound, not an exact score.
- `multipv <n>`: principal variation rank.
- `pv`: principal variation. Treat it as the main line.
- `string`: arbitrary engine text; do not parse it as a PV.

For candidate comparison, set the engine's MultiPV option before `isready` when supported:

```text
setoption name MultiPV value 5
```

Then collect the newest `info ... multipv 1 ...`, `multipv 2`, etc. lines from the same search. Use the first move of each PV as the candidate move.

Mate-solving output:

```text
checkmate <move1> ... <moveN>
checkmate notimplemented
checkmate timeout
checkmate nomate
```

## Option Commands

Engines declare options during `usi`:

```text
option name <optionname> type <optiontype> ...
```

Set options before `isready`:

```text
setoption name USI_Hash value 1024
setoption name USI_Ponder value false
```

Common option types:

- `check`: boolean `true` or `false`.
- `spin`: integer with optional `min` and `max`.
- `combo`: one value from declared `var` options.
- `button`: action trigger.
- `string`: string.
- `filename`: file path.

Common reserved options include `USI_Hash` and `USI_Ponder`.
