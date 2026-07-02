#!/usr/bin/env bash
# PreToolUse guard: hard-block `git push` to main/master, and hard-block any
# force-push (--force / --force-with-lease / --force-if-includes / -f / +refspec).
# Reads the hook JSON on stdin and emits a deny decision. Fails open (exit 0)
# on any parse hiccup so ordinary pushes are never disrupted.

protected_re='^(main|master)$'

deny() {
  jq -n --arg r "$1" \
    '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:"deny",permissionDecisionReason:$r}}'
  exit 0
}

cmd=$(jq -r '.tool_input.command // ""')

# Self-guard: only act on commands that actually contain a `git push` (so this
# hook can run on every Bash call and still catch compound commands like
# `git reset --hard X && git push --force`).
case "$cmd" in
  *"git push"*) ;;
  *) exit 0 ;;
esac

# Drop everything through the `git push` token; keep the args that follow.
args=${cmd#*git push}

# First non-flag arg is the remote; the rest are refspecs.
remote=""
refspecs=()
force=""
set -- $args
while [ "$#" -gt 0 ]; do
  case "$1" in
    --force|--force-with-lease|--force-with-lease=*|--force-if-includes)
      force=1 ;;
    --*) ;; # other long flags (e.g. --set-upstream, --follow-tags)
    -*f*) force=1 ;; # short-flag bundle containing -f (e.g. -f, -uf)
    -*) ;; # other short flags (e.g. -u, -n)
    +*) force=1 ;; # a leading-+ refspec is a force push
    *)
      if [ -z "$remote" ]; then remote="$1"; else refspecs+=("$1"); fi
      ;;
  esac
  shift
done

if [ -n "$force" ]; then
  deny "Force-push is blocked by policy. Make a follow-up commit instead of rewriting history; if a force-push is truly required, run it yourself."
fi

# Destination branch of a refspec is the part after a colon, else the whole token.
ref_is_protected() {
  local dst=${1#*:}
  dst=${dst#refs/heads/}
  printf '%s' "$dst" | grep -Eq "$protected_re"
}

if [ "${#refspecs[@]}" -gt 0 ]; then
  for rs in "${refspecs[@]}"; do
    if ref_is_protected "$rs"; then
      deny "Refusing to push to a protected branch (main/master). Push from a feature branch and open a PR instead."
    fi
  done
  exit 0
fi

# No explicit refspec: the pushed branch is the current one. Block if HEAD is protected.
cur=$(git symbolic-ref --quiet --short HEAD 2>/dev/null || true)
if printf '%s' "$cur" | grep -Eq "$protected_re"; then
  deny "Current branch is '$cur'. Refusing to push a protected branch (main/master). Switch to a feature branch first."
fi

exit 0
