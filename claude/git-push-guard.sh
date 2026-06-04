#!/usr/bin/env bash
# PreToolUse guard: hard-block `git push` to main/master.
# Reads the hook JSON on stdin and emits a deny decision when the push
# would land on a protected branch. Fails open (exit 0) on any parse hiccup
# so ordinary pushes are never disrupted.

protected_re='^(main|master)$'

deny() {
  jq -n --arg r "$1" \
    '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:"deny",permissionDecisionReason:$r}}'
  exit 0
}

cmd=$(jq -r '.tool_input.command // ""')

# Drop everything through the `git push` token; keep the args that follow.
args=${cmd#*git push}

# First non-flag arg is the remote; the rest are refspecs.
remote=""
refspecs=()
set -- $args
while [ "$#" -gt 0 ]; do
  case "$1" in
    -*) ;; # ignore flags (e.g. -u, --force, --delete)
    *)
      if [ -z "$remote" ]; then remote="$1"; else refspecs+=("$1"); fi
      ;;
  esac
  shift
done

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
