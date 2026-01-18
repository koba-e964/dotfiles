When nix is reinstalled, the following errors happen.
We must handle this to make ./install.sh succeeds on the first try.

```
---- oh no! --------------------------------------------------------------------
I back up shell profile/rc scripts before I add Nix to them.
I need to back up /etc/zsh/zshrc to /etc/zsh/zshrc.backup-before-nix,
but the latter already exists.

Here's how to clean up the old backup file:

1. Back up (copy) /etc/zsh/zshrc and /etc/zsh/zshrc.backup-before-nix
   to another location, just in case.

2. Ensure /etc/zsh/zshrc.backup-before-nix does not have anything
   Nix-related in it. If it does, something is probably quite
   wrong. Please open an issue or get in touch immediately.

3. Once you confirm /etc/zsh/zshrc is backed up and
   /etc/zsh/zshrc.backup-before-nix doesn't mention Nix, run:
   mv /etc/zsh/zshrc.backup-before-nix /etc/zsh/zshrc

We'd love to help if you need it.

You can open an issue at
https://github.com/NixOS/nix/issues/new?labels=installer&template=installer.md

Or get in touch with the community: https://nixos.org/community
```
