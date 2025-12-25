"""
Mac 用のユーザ辞書の plist ファイルを生成する。
"""
from typing import TypedDict

import tomllib

class Entry(TypedDict):
    """
    辞書の一つの項目
    """
    phrase: str
    shortcut: str

def emit_as_plist(entries: list[Entry], outfilename: str) -> None:
    """
    entries を plist 形式で outfilename に出力する。
    """
    with open(outfilename, 'w', encoding='utf-8') as outfile:
        print('<?xml version="1.0" encoding="UTF-8"?>', file=outfile)
        print(
            '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" ' +
                '"http://www.apple.com/DTDs/PropertyList-1.0.dtd">',
            file=outfile,
        )
        print('<plist version="1.0">', file=outfile)
        print('<array>', file=outfile)
        for entry in entries:
            print('\t<dict>', file=outfile)
            print('\t\t<key>phrase</key>', file=outfile)
            print(f'\t\t<string>{entry["phrase"]}</string>', file=outfile)
            print('\t\t<key>shortcut</key>', file=outfile)
            print(f'\t\t<string>{entry["shortcut"]}</string>', file=outfile)
            print('\t</dict>', file=outfile)
        print('</array>', file=outfile)
        print('</plist>', file=outfile)

def main() -> None:
    """main"""
    entries: list[Entry] = []
    with open('linguistics.toml', 'rb') as fp:
        dat = tomllib.load(fp)
        for item in dat['words']:
            entry: Entry = {
                'phrase': item['phrase'],
                'shortcut': item['shortcut'],
            }
            entries.append(entry)
    emit_as_plist(entries, 'user-dictionary.plist')

if __name__ == '__main__':
    main()
