#!/usr/bin/env python3
"""Convert a KIF position diagram to one SFEN line.

This handles KIF files that contain a displayed position, not only full game
records from the initial position.
"""

from __future__ import annotations

import argparse
import re
from pathlib import Path


PIECE_TO_SFEN = {
    "歩": "P",
    "香": "L",
    "桂": "N",
    "銀": "S",
    "金": "G",
    "角": "B",
    "飛": "R",
    "玉": "K",
    "王": "K",
    "と": "+P",
    "杏": "+L",
    "圭": "+N",
    "全": "+S",
    "馬": "+B",
    "龍": "+R",
    "竜": "+R",
}

HAND_ORDER = ["R", "B", "G", "S", "N", "L", "P", "r", "b", "g", "s", "n", "l", "p"]
HAND_PIECES = ["飛", "角", "金", "銀", "桂", "香", "歩"]
KANJI_NUMERALS = {
    "一": 1,
    "二": 2,
    "三": 3,
    "四": 4,
    "五": 5,
    "六": 6,
    "七": 7,
    "八": 8,
    "九": 9,
    "十": 10,
}


def parse_count(text: str) -> int:
    if not text:
        return 1
    if text.isdecimal():
        return int(text)
    if text == "十":
        return 10
    if text.startswith("十"):
        return 10 + KANJI_NUMERALS[text[1:]]
    if "十" in text:
        left, right = text.split("十", 1)
        return KANJI_NUMERALS[left] * 10 + (KANJI_NUMERALS[right] if right else 0)
    total = 0
    for char in text:
        total = total * 10 + KANJI_NUMERALS[char]
    return total


def parse_hand(line: str, *, black: bool) -> dict[str, int]:
    _, hand_text = line.split("：", 1)
    hand_text = hand_text.strip()
    if not hand_text or hand_text == "なし":
        return {}

    counts: dict[str, int] = {}
    for piece, count_text in re.findall(r"([飛角金銀桂香歩])([一二三四五六七八九十0-9]*)", hand_text):
        code = PIECE_TO_SFEN[piece]
        if not black:
            code = code.lower()
        counts[code] = counts.get(code, 0) + parse_count(count_text)
    return counts


def parse_board(lines: list[str]) -> str:
    rows: list[str] = []
    for line in lines:
        if not line.startswith("|"):
            continue
        content = line.split("|", 2)[1]
        cells = [content[index : index + 2] for index in range(0, len(content), 2)]
        if len(cells) != 9:
            raise ValueError(f"expected 9 cells, got {len(cells)} in line: {line!r}")

        row = ""
        empty_count = 0
        for cell in cells:
            owner = cell[0]
            piece = cell[1]
            if piece == "・":
                empty_count += 1
                continue
            if empty_count:
                row += str(empty_count)
                empty_count = 0
            code = PIECE_TO_SFEN[piece]
            if owner == "v":
                code = code.lower()
            row += code
        if empty_count:
            row += str(empty_count)
        rows.append(row)

    if len(rows) != 9:
        raise ValueError(f"expected 9 board rows, got {len(rows)}")
    return "/".join(rows)


def parse_side_to_move(text: str) -> str:
    if re.search(r"^先手番$", text, flags=re.MULTILINE):
        return "b"
    if re.search(r"^後手番$", text, flags=re.MULTILINE):
        return "w"
    raise ValueError("could not find side to move line")


def parse_move_number(text: str) -> int:
    match = re.search(r"^手数＝(\d+)", text, flags=re.MULTILINE)
    if match:
        return int(match.group(1)) + 1
    return 1


def format_hands(counts: dict[str, int]) -> str:
    result = ""
    for piece in HAND_ORDER:
        count = counts.get(piece, 0)
        if count == 1:
            result += piece
        elif count > 1:
            result += f"{count}{piece}"
    return result or "-"


def convert(text: str) -> str:
    lines = text.splitlines()
    board = parse_board(lines)
    side_to_move = parse_side_to_move(text)
    move_number = parse_move_number(text)

    hand_counts: dict[str, int] = {}
    for line in lines:
        if line.startswith("先手の持駒："):
            hand_counts.update(parse_hand(line, black=True))
        elif line.startswith("後手の持駒："):
            hand_counts.update(parse_hand(line, black=False))

    return f"{board} {side_to_move} {format_hands(hand_counts)} {move_number}"


def main() -> None:
    parser = argparse.ArgumentParser(description="Convert a KIF position diagram to SFEN.")
    parser.add_argument("input", type=Path, help="KIF file containing a position diagram")
    parser.add_argument("-o", "--output", type=Path, help="write SFEN to this file")
    args = parser.parse_args()

    sfen = convert(args.input.read_text(encoding="utf-8"))
    if args.output:
        args.output.write_text(sfen + "\n", encoding="utf-8")
    else:
        print(sfen)


if __name__ == "__main__":
    main()
