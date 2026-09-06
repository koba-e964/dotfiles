{
    enable = true;
    ignores = [
        ".DS_Store"
        "**/.claude/settings.local.json"
        ".ideas*.md"
        ".hidden*"
        ".unreviewed-changes.md"
    ];
    settings = {
        user = {
            name = "koba-e964";
            email = "3303362+koba-e964@users.noreply.github.com";
            signingkey = "7644C3550BFD7D42";
        };
        push = {
            autoSetupRemote = true;
        };
        core = {
            editor = "vi";
            pager = "delta";
        };
        init = {
            defaultBranch = "main";
        };
        interactive = {
            diffFilter = "delta --color-only";
        };
        delta = {
            navigate = true;
            "line-numbers" = true;
            "side-by-side" = false;
            "word-diff-regex" = ".";
            "wrap-max-lines" = "unlimited";
            "max-line-length" = 0;
        };
        filter = {
            lfs = {
                required = true;
                clean = "git-lfs clean -- %f";
                smudge = "git-lfs smudge -- %f";
                process = "git-lfs filter-process";
            };
        };
    };
    includes = [
        {
            # Put machine-local overrides in ~/.gitconfig.local
            path = "~/.gitconfig.local";
        }
    ];
}
