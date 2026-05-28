# Dotfiles repo cleanup + upstream PR

**Date:** 2026-05-28
**Repo:** `qz-mac-setup/mac-setup` (fork) ← `ctaymor/mac-setup` (upstream, public)
**Working branch:** `quizlet`

## Context

This is a Quizlet-flavored fork of a personal public dotfiles repo. Over time:
- Several portable improvements have piled up on the `quizlet` branch and never went back upstream.
- A botched merge conflict resolution left `scripts/claude.sh` broken (missing `main()` declaration; upstream still has unresolved conflict markers).
- Dotfiles in `~/` have drifted from `dotfiles/` in the repo — most notably `~/.gitconfig` is a real file (not symlinked) with extra aliases.
- `~/.claude/` contains skills and reference docs that were never tracked anywhere.
- A `.env` file (no secrets, just `SETUP_HOME_DIR=…`) is tracked in git despite being a name that conventionally holds secrets.

## Starting state for the next agent

**Repo:** `/Users/carolinetaymor/workspace/mac-setup`

**Remotes:**
- `ctaymor` → `git@github.com:ctaymor/mac-setup.git` (Caroline's personal public dotfiles; upstream for this fork; owned by `ctaymor@gmail.com`)
- `qz-mac-setup` → `git@github.com:carolinetaymor-qz/mac-setup.git` (Quizlet-flavored fork; owned by `caroline.taymor@quizlet.com`)

**Current branch:** `quizlet` (tracks `qz-mac-setup/quizlet`).

**Other branches in repo (NOT in scope; leave alone):**
`ai-personality`, `beads-metadata`, `claude-config-jan-8`, `claude-lookup-docs`, `claude-organization`, `reference-docs-skill`, `main`. The remote `ctaymor` also has `2023/babka-mastodon`, `stw-2024`, `stw-2024-v2`.

**Working-tree state at start of this spec:**
- Modified, uncommitted: `Brewfile` (adds `tap "atlassian/acli"`, `brew "acli"`, `brew "gastown"`, `brew 'glow'`); `dotfiles/zshrc` (removes a stray `<<<<<<< HEAD` line and a dead `. "$HOME/.local/bin/env"` source line — both clearly correct, just need committing).
- Untracked: `AGENTS.md` (Quizlet-flavored bd/beads agent guide), `TODO.md` (Caroline's scratchpad).
- `.env` is tracked but only contains `SETUP_HOME_DIR=~/workspace/mac-setup` (no secret). Verified across history.

**`~/.claude/` symlink state — important to know before re-running `claude.sh`:**

| Path | Type | Target / status |
|---|---|---|
| `~/.claude/CLAUDE.md` | symlink ✓ | → `dotfiles/claude/CLAUDE.md` |
| `~/.claude/custom-snippets/strict-tdd-guide.md` | symlink ✓ | → `dotfiles/claude/custom-snippets/strict-tdd-guide.md` |
| `~/.claude/skills/refactoring-guide` | symlink ✓ | → `dotfiles/claude/skills/refactoring-guide` |
| `~/.claude/skills/lookup-docs` | symlink ✓ | → `dotfiles/claude/skills/lookup-docs` |
| `~/.claude/skills/concierge` | symlink → quizlet | → `platform-toolbox/.claude/skills/concierge` (leave alone) |
| `~/.claude/skills/create-beads` | symlink → quizlet | → `platform-toolbox/.claude/skills/create-beads` (leave alone) |
| `~/.claude/skills/flagging-tone-risks/` | REAL dir | Caroline's in-progress; leave alone |
| `~/.claude/skills/translating-tone/` | REAL dir | Caroline's in-progress; leave alone |
| `~/.claude/skills/sprint-report/` | REAL dir | Caroline reviews later; leave alone |
| `~/.claude/context/preferences/code` | symlink ✓ | → `dotfiles/claude/context/preferences/code` |
| `~/.claude/context/preferences/workflows` | symlink ✓ | → `dotfiles/claude/context/preferences/workflows` (target is empty except `.gitkeep`) |
| `~/.claude/context/preferences/ai-persona-guidelines` | **DANGLING SYMLINK** | Target was deleted from repo; remove the symlink (B3) |
| `~/.claude/context/reference-docs/argo-cd/` | REAL dir | Caroline's personal docs collection; don't commit |
| `~/.claude/context/reference-docs/gastown/` | REAL dir | Caroline's Quizlet work collection; don't commit (even though gastown brew is OSS) |
| `~/.claude/context/reference-docs/ona/` | REAL dir | Don't commit |
| `~/.claude/settings.json` | REAL file | Not in repo; contains Quizlet workspace paths; leave alone |
| `~/.gitconfig` | REAL file (NOT symlinked) | Drift target — see B7 and Phase 1.5 |
| `~/.bashrc` | symlink **broken** | `→ dotfiles/bashrc` (relative; B4) |
| `~/.ssh/config` | REAL file (NOT symlinked) | 55B vs repo's 75B; B8 |
| `~/.config/nvim` | symlink ✓ | → `dotfiles/nvim` |
| `~/.gitmessage` | does not exist | Hardcoded path in `dotfiles/gitconfig` references it (B5) |

## Decisions made during brainstorming (binding context)

These overrode some default assumptions during the brainstorm — recording them so the next agent doesn't re-litigate:

1. **`gastown` is open source, NOT Quizlet-proprietary.** Despite the name and Caroline using it at Quizlet, the brew itself is shareable upstream. (The *docs* Caroline has collected at `~/.claude/context/reference-docs/gastown/` are her work-tooling collection and should not be committed.)
2. **`acli` (Atlassian CLI) is also open source**, not Quizlet-specific. Upstream OK.
3. **Argo (argocd, kubectl-argo-rollouts, `argoproj/tap`) is common but not universal.** Stay on quizlet branch only.
4. **Brewfile *removals* do NOT go upstream.** Caroline still uses rbenv/heroku/postgresql/yarn/ruby-build/hugo/leiningen/clojure/temurin@21/az/elixir-deps/yt-dlp/libidn on personal projects she may revive. The upstream PR is **additions only**.
5. **The "Frustrated or Overwhelmed Heuristic" in CLAUDE.md does not behave well in Claude Code** (it works in browser-based Claude). Don't include it in upstream PR. Cleanup of similar broken CLAUDE.md content is a **separate future workstream**.
6. **Most other Claude personality content in CLAUDE.md "isn't working" in Claude Code.** Same — out of scope here.
7. **`lookup-docs` skill IS portable.** Upstream the SKILL.md + a `reference-docs/README.md` explaining the per-topic folder convention (Option B from brainstorming). **No fetch script.** Empty scaffolding only — do not commit any docs themselves.
8. **`flagging-tone-risks` and `translating-tone` are in-progress and Caroline-specific (not Quizlet-specific).** Caroline will PR them upstream herself when they're ready. Leave the real directories in `~/.claude/skills/` untouched; do NOT move them into the repo.
9. **`slackmojis.txt` is shareable.** It's just a list of public emoji URLs Caroline likes; she may want them in other Slack workspaces. Upstream OK.
10. **gitconfig handling = two-gitconfigs + publish script** (per AskUserQuestion). NOT a symlink, NOT a single shared gitconfig with branch-per-identity, NOT a `.local` include.
11. **Delivery cadence = phase-by-phase with approval gates** (per AskUserQuestion). Stop at each phase boundary.

## Goals

1. Open a clean upstream PR with the broadly portable changes.
2. Fix the bugs that make the repo "a lie" — the symlink script that doesn't run, the dangling symlinks, the drift.
3. Establish a sustainable split: portable preferences upstream, Quizlet-specific bits on the `quizlet` branch only.
4. Zero credentials in git, ever. (Verified: current `.env` has none.)

## Non-goals

- Cleaning up the "Working with Caroline" / personality content in `dotfiles/claude/CLAUDE.md` that doesn't behave well in Claude Code. **Separate future workstream.**
- Polishing the in-progress `flagging-tone-risks` and `translating-tone` skills. Caroline will PR them upstream when ready.
- Bringing reference docs (argo-cd, gastown, ona) into the repo. Empty scaffolding only; users populate their own.

## Constraints

- **Public upstream.** Nothing Quizlet-proprietary may go in the PR. Per Caroline, `gastown`, `acli`, `glow`, etc. are open source and OK.
- **No work-for-hire leakage.** PLATFORM ticket conventions, gcpl helper, quizlet email, Quizlet workspace paths in settings.json: quizlet-branch only.
- **No credentials, ever.** `.env`-style files, ngrok auth, ssh keys, tokens.
- **No Brewfile removals upstream.** Caroline uses several of the "old" tools (rbenv, heroku, hugo, leiningen, etc.) for personal projects. Only additions go up.

---

## Full categorization

### Bugs (must fix)

| # | Bug | Location | Impact |
|---|---|---|---|
| B1 | `main() {` declaration lost | `scripts/claude.sh` | `bash -n` syntax error; script doesn't run; new skills/preferences/snippets don't symlink |
| B2 | Unresolved conflict markers | `scripts/claude.sh` on `ctaymor/main` | Same |
| B3 | Dangling symlink | `~/.claude/context/preferences/ai-persona-guidelines` | Points to deleted repo dir |
| B4 | Relative symlink | `~/.bashrc` → `dotfiles/bashrc` | Only resolves from `$HOME` |
| B5 | Hardcoded absolute path | `dotfiles/gitconfig` `[commit] template = /Users/carolinetaymor/...` | Breaks for any other user / move; and `~/.gitconfig` isn't even the repo file so template doesn't load |
| B6 | `.env` tracked | repo root | Should be in `.gitignore`; risks future credential leak by precedent |
| B7 | `~/.gitconfig` not synced | `~/.gitconfig` is real file | Drift: extra aliases (`ls`, `pull.rebase=false`, github URL rewrite) live only in `~/` |
| B8 | `~/.ssh/config` drift | 55B vs 75B repo file | Minor |

### Upstream-PR-able (portable preferences)

| Item | Source | Notes |
|---|---|---|
| `Brewfile` additions: `pyenv`, `gh`, `tfenv`, `terraform-ls`, `telnet`, `netcat`, `mtr`, `wget`, `curl`, `kubectl`, `kubectx`, `kustomize`, `k9s`, `zsh-kubectl-prompt`, `gastown`, `acli`, `glow`, `go`, `minikube`, `gcloud-cli` (cask, replacing `google-cloud-sdk`) | `Brewfile` work tree + quizlet commits | Caroline's stack additions. NOT removals — those stay. (`helm` and `minikube` are already in upstream under Azure section; reorganize but don't duplicate. Check each brew against upstream before adding.) |
| `Brewfile` taps: `superbrothers/zsh-kubectl-prompt`, `atlassian/acli` | `Brewfile` | Needed for above |
| `dotfiles/zshrc`: `GOPATH` export + `$GOPATH/bin` on PATH | zshrc | General |
| `dotfiles/zshrc`: `zsh-kubectl-prompt` setup (autoload colors, source kubectl.zsh, RPROMPT) | zshrc | General; pairs with brew |
| `slackmojis.txt` | Repo root | Just public emoji URLs; sharable |
| `scripts/claude.sh` fix: restore `main()`, drop conflict markers | scripts/claude.sh | Bug fix |
| `dotfiles/claude/skills/lookup-docs/SKILL.md` | dotfiles/claude/skills/ | Generic skill; no Quizlet refs |
| `dotfiles/claude/context/reference-docs/README.md` (NEW) | Create | Explains per-topic folder convention for lookup-docs. Sketch: short README that says "Drop reference documentation into a subfolder named after the topic (e.g., `argo-cd/`, `kubernetes/`). The `lookup-docs` skill searches `~/.claude/context/reference-docs/<topic>/` when asked to consult docs on `<topic>`. Don't commit your docs unless you specifically want them shared — this folder is for personal/team reference material populated locally." |
| Removal of empty `ai-persona-guidelines/` dir | dotfiles/claude/context/preferences/ | Content already in CLAUDE.md |

### Quizlet-only (stays on `quizlet` branch)

| Item | Why |
|---|---|
| `dotfiles/gitmessage` template `[PLATFORM-????]` | Quizlet ticket prefix |
| `dotfiles/gitconfig` `[commit] template = …` line | Work convention |
| `dotfiles/zshrc` `gcpl()` function | PLATFORM ticket commit helper |
| `Brewfile` `argocd`, `kubectl-argo-rollouts`, tap `argoproj/tap` | Argo not universal enough per Caroline |
| `Brewfile` *removals* of rbenv/heroku/hugo/leiningen/clojure/temurin/azure/elixir build deps/yt-dlp/etc. | Caroline uses these on personal projects; keep upstream Brewfile unchanged for those |
| `dotfiles/claude/CLAUDE.md` "Frustrated or Overwhelmed Heuristic" section | Doesn't behave in Claude Code; only works in browser Claude |
| `dotfiles/zshrc` ngrok auth source | Personal; references `~/.ngrok/auth` which holds secrets |
| `~/.claude/skills/concierge`, `create-beads` (symlinks to platform-toolbox) | Quizlet-internal |
| `~/.claude/context/reference-docs/gastown`, `ona` | Even though gastown is OSS, the docs Caroline has collected are her work-tooling collection; don't track |
| `~/.claude/settings.json` workspace paths | Quizlet workspace dirs |
| `AGENTS.md`, `TODO.md` (untracked) | Current-state Quizlet notes |

### Caroline-personal (Caroline's call, not part of this PR)

| Item | Disposition |
|---|---|
| `~/.claude/skills/flagging-tone-risks/` | In-progress; Caroline PRs upstream when ready |
| `~/.claude/skills/translating-tone/` | In-progress; Caroline PRs upstream when ready |
| `~/.claude/skills/sprint-report/` | Caroline reviews / decides later |
| `~/.claude/context/reference-docs/argo-cd/` | Personal docs collection; don't commit |

### Deferred to a separate workstream

| Item | Why |
|---|---|
| Cleaning up CLAUDE.md content that doesn't actually behave in Claude Code | Bigger discussion; needs its own audit of what works vs doesn't |

---

## Plan: four phases

### Phase 0 — Safety (no remote pushes; reversible)

1. Confirm `.env` history has no secrets — **done** (single commit, value `SETUP_HOME_DIR=~/workspace/mac-setup`).
2. `grep -ri` the repo for credential-shaped strings (passwords, tokens, AKIA*, sk-*, etc.) — sanity check before any push.
3. Add `.env` to `.gitignore`; `git rm --cached .env`.
4. Verify nothing else in `git ls-files` looks credential-shaped.
5. **Checkpoint with Caroline.**

### Phase 1 — Local repo bug fixes (commits on `quizlet`)

1. Fix `scripts/claude.sh`: restore `main()` declaration. **Specifically:** the line immediately after the closing `}` of `symlink_skills()` and before `    ensure_claude_directory_initialized` should read `main() {`. Verify with `bash -n scripts/claude.sh` → exit 0. (Upstream `ctaymor/main` still has unresolved `<<<<<<<`/`=======`/`>>>>>>>` markers in this file; Phase 2 fixes those too.)
2. Remove dangling symlink `~/.claude/context/preferences/ai-persona-guidelines`.
3. Fix `~/.bashrc` symlink to use absolute path.
4. Fix `dotfiles/gitconfig` hardcoded template path → `~/workspace/mac-setup/dotfiles/gitmessage` is still bad; change to `~` or have publish-gitconfig substitute. (Decision in Phase 1.5.)
5. Establish gitconfig split (Phase 1.5).
6. Resolve `~/.ssh/config` drift — diff and decide which is canonical.
7. Re-run `scripts/claude.sh` to (re)create any missing symlinks.
8. Commit current uncommitted Brewfile changes (`acli`, `gastown`, `glow`) and the zshrc cleanup (remove stray `<<<<<<< HEAD` line and dead `.local/bin/env` source).
9. **Checkpoint with Caroline.**

#### Phase 1.5 — Two-gitconfig publish-script split

**Literal extras currently in `~/.gitconfig` that must be preserved on the quizlet variant:**
```
[alias]
	ls = log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cN]%Creset %ad\" --decorate --date=short
[pull]
	rebase = false
[url "git@github.com:"]
	insteadOf = https://github.com/
```
(Repo `dotfiles/gitconfig` does NOT have these; `~/.gitconfig` does. Caroline wants them kept.)

**Identity emails:**
- `gitconfig-personal` → `ctaymor@gmail.com`
- `gitconfig-quizlet` → `caroline.taymor@quizlet.com`

**Steps:**
1. In `dotfiles/`, create `gitconfig-personal` (current `dotfiles/gitconfig` content with personal email; NO commit-template line because PLATFORM tickets are Quizlet-only) and `gitconfig-quizlet` (with quizlet email + the extras above + the existing `[commit] template = …` line, but with `~` instead of absolute path).
2. Rename `dotfiles/gitmessage` → `dotfiles/gitmessage-quizlet` (since the template is Quizlet-only); the `gitconfig-quizlet` `[commit] template` points at `~/workspace/mac-setup/dotfiles/gitmessage-quizlet`.
3. Delete the original `dotfiles/gitconfig` (now superseded).
4. Update `manual_scripts/publish-gitconfig` to take an arg: `publish-gitconfig personal | quizlet`. Validate arg; copy the right file to `~/.gitconfig`.
5. Update `manual_scripts/save-gitconfig` to take the same arg; save `~/.gitconfig` back to the right repo file.
6. Run `publish-gitconfig quizlet` so `~/.gitconfig` matches the new repo file. Verify with `git config --global user.email` → expect `caroline.taymor@quizlet.com`.
7. Update the project `CLAUDE.md` line that says `` `manual_scripts/publish-gitconfig` - Copy dotfiles/gitconfig to ~/.gitconfig … `` to reflect the new `personal | quizlet` arg. Likewise for `save-gitconfig`.

**Heads-up for upstream PR:** `gitconfig-personal` IS portable. Caroline's personal email is already on the upstream public repo (it's her name in commit history), so including it in the public PR is fine. `gitconfig-quizlet` and `gitmessage-quizlet` stay on the quizlet branch only.

### Phase 2 — Upstream PR

**Author-identity heads-up:** by the end of Phase 1.5, `~/.gitconfig` will have `caroline.taymor@quizlet.com`. Phase 2 commits must be authored as `ctaymor@gmail.com` (this is Caroline's identity on `ctaymor/main`). Either:
- Run `publish-gitconfig personal` for the duration of Phase 2 then `publish-gitconfig quizlet` after, OR
- Use repo-local override: `git config user.email ctaymor@gmail.com` and `git config user.name "Caroline Taymor"` on the `prep-upstream-pr` branch (preferred — avoids accidental wrong-identity commits elsewhere). Verify each commit's author with `git log -1 --format='%an <%ae>'`.

1. Create branch `prep-upstream-pr` off `ctaymor/main`.
2. Hand-port the portable changes (NOT cherry-pick — too many merges/conflicts in history; cleaner to author fresh commits).
3. Commits, in this order:
   - `fix(claude.sh): restore main() and resolve merge conflict markers` + add `symlink_skills`
   - `feat(brewfile): add k8s tooling (kubectl, kubectx, kustomize, helm, k9s, minikube)`
   - `feat(brewfile): add zsh-kubectl-prompt + tap`
   - `feat(brewfile): add network utilities (telnet, netcat, mtr, wget, curl)`
   - `feat(brewfile): add language tooling (go, pyenv, tfenv, terraform-ls, gh)`
   - `feat(brewfile): add gastown, acli, glow`
   - `feat(brewfile): switch google-cloud-sdk cask name to gcloud-cli`
   - `feat(zshrc): export GOPATH and add to PATH`
   - `feat(zshrc): set up zsh-kubectl-prompt RPROMPT`
   - `feat(claude): add lookup-docs skill + reference-docs README convention`
   - `chore(claude): remove obsolete ai-persona-guidelines folder (content lives in CLAUDE.md)`
   - `chore(slackmojis): add slackmojis URL list`
4. Verify no quizlet/PLATFORM/gcpl/argocd/ngrok strings present: `grep -rE "PLATFORM|gcpl|quizlet|ngrok|argocd|argo-rollouts" .`
5. Push branch to `ctaymor` remote; open PR via `gh`.
6. **Checkpoint with Caroline before push and again before opening PR.**

### Phase 3 — Re-sync quizlet branch (after PR merges)

1. `git fetch ctaymor`
2. `git checkout quizlet`
3. `git merge ctaymor/main` — should be mostly trivial since quizlet already has these changes.
4. Resolve any conflicts (likely just Brewfile ordering).
5. Push to `qz-mac-setup/quizlet`.

---

## Open questions / future workstreams

1. **CLAUDE.md content audit.** Which parts of the "Working with Caroline" block actually work in Claude Code vs only in browser Claude? Out of scope here.
2. **Reference docs lifecycle.** Should there be a fetch script for argo-cd-style doc collections (option C from brainstorming)? Skipped for v1.
3. **Sprint-report skill triage.** Read content, decide if portable.
4. **Cleanup of broken/outdated personality files.** Heuristics removed from preferences but the empty workflows folder remains; do we want it gone too?

## Approval gates

Stop and confirm with Caroline before:
- Phase 0 → 1 (after `.env` safety check)
- Phase 1 → 1.5 (after bug fixes; confirm gitconfig split shape)
- Phase 1.5 → 2 (after local cleanup, before starting upstream branch)
- Within Phase 2: before push to ctaymor remote, before opening PR
- Phase 3 only after PR is merged on upstream

## Handoff: next step

This spec is the input for the `superpowers:writing-plans` skill. The next agent should:

1. Read this spec end-to-end.
2. Sanity-check current state with `git status`, `git remote -v`, `bash -n scripts/claude.sh` (will fail until B1 is fixed), `ls -l ~/.bashrc ~/.gitconfig ~/.ssh/config ~/.claude/context/preferences/`.
3. Invoke the `superpowers:writing-plans` skill to convert this spec into a numbered implementation plan with concrete commands per step.
4. Begin Phase 0. Stop at each approval gate.

**Do not:**
- Touch other branches (`ai-personality`, `beads-metadata`, etc.).
- Move or modify the real (non-symlinked) `~/.claude/skills/flagging-tone-risks`, `translating-tone`, `sprint-report` directories.
- Commit any `~/.claude/context/reference-docs/*` content into the repo.
- PR Brewfile *removals* upstream.
- Re-litigate decisions listed under "Decisions made during brainstorming."

**Verify before pushing to `ctaymor` remote:**
```
git diff ctaymor/main..prep-upstream-pr | grep -iE 'PLATFORM|gcpl|quizlet|ngrok|argocd|argo-rollouts|\.taymor@quizlet\.com'
```
Expected: empty output. (Caroline's `ctaymor@gmail.com` showing up is fine.)
