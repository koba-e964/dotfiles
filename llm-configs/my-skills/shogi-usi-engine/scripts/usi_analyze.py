#!/usr/bin/env python3
"""Run a USI shogi engine against one SFEN position."""

from __future__ import annotations

import argparse
import json
import subprocess
import sys
import time
from pathlib import Path


def send(proc: subprocess.Popen[str], line: str, transcript: list[dict[str, str]]) -> None:
    transcript.append({"direction": ">", "line": line})
    assert proc.stdin is not None
    proc.stdin.write(line + "\n")
    proc.stdin.flush()


def read_until(
    proc: subprocess.Popen[str],
    tokens: tuple[str, ...],
    transcript: list[dict[str, str]],
    timeout: float,
) -> str:
    assert proc.stdout is not None
    deadline = time.monotonic() + timeout
    while True:
        if time.monotonic() > deadline:
            raise TimeoutError(f"timed out waiting for one of: {', '.join(tokens)}")
        line = proc.stdout.readline()
        if line == "":
            raise RuntimeError("engine exited before expected response")
        line = line.rstrip("\r\n")
        transcript.append({"direction": "<", "line": line})
        if any(line == token or line.startswith(token + " ") for token in tokens):
            return line


def parse_setoption(option: str) -> str:
    if option.startswith("setoption "):
        return option
    if "=" in option:
        name, value = option.split("=", 1)
        return f"setoption name {name} value {value}"
    return f"setoption name {option}"


def main() -> int:
    parser = argparse.ArgumentParser(description="Analyze one SFEN position with a USI engine.")
    parser.add_argument("--engine", required=True, type=Path, help="path to the USI engine executable")
    parser.add_argument("--cwd", type=Path, help="working directory for the engine; defaults to dirname(engine)")
    parser.add_argument("--sfen", required=True, help="SFEN position to analyze")
    parser.add_argument("--moves", nargs="*", default=[], help="USI moves to append after the SFEN root position")
    parser.add_argument("--go", default="go byoyomi 1000", help="USI go command to send")
    parser.add_argument("--multipv", type=int, help="send setoption name MultiPV value N before isready")
    parser.add_argument(
        "--setoption",
        action="append",
        default=[],
        help="option to send before isready; use 'Name=Value' or a full 'setoption ...' line",
    )
    parser.add_argument("--timeout", type=float, default=30.0, help="timeout in seconds for each wait")
    parser.add_argument("--json", action="store_true", help="emit JSON instead of plain transcript")
    args = parser.parse_args()

    engine = args.engine.expanduser().resolve()
    cwd = args.cwd.expanduser().resolve() if args.cwd else engine.parent
    transcript: list[dict[str, str]] = []

    proc = subprocess.Popen(
        [str(engine)],
        cwd=str(cwd),
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
        bufsize=1,
    )

    final_line = ""
    try:
        send(proc, "usi", transcript)
        read_until(proc, ("usiok",), transcript, args.timeout)

        if args.multipv is not None:
            send(proc, f"setoption name MultiPV value {args.multipv}", transcript)

        for option in args.setoption:
            send(proc, parse_setoption(option), transcript)

        send(proc, "isready", transcript)
        read_until(proc, ("readyok",), transcript, args.timeout)

        send(proc, "usinewgame", transcript)
        position = f"position sfen {args.sfen}"
        if args.moves:
            position += " moves " + " ".join(args.moves)
        send(proc, position, transcript)
        send(proc, args.go, transcript)

        expected = ("checkmate",) if args.go.startswith("go mate") else ("bestmove",)
        final_line = read_until(proc, expected, transcript, args.timeout)
        send(proc, "quit", transcript)
    finally:
        try:
            proc.wait(timeout=2)
        except subprocess.TimeoutExpired:
            proc.kill()
            proc.wait(timeout=2)

    if args.json:
        json.dump({"final": final_line, "transcript": transcript}, sys.stdout, ensure_ascii=False, indent=2)
        sys.stdout.write("\n")
    else:
        for event in transcript:
            print(f"{event['direction']} {event['line']}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
