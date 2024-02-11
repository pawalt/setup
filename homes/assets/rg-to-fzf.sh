#!/usr/bin/env bash

# this is not safe for concurrent invocations, but i'll cross that bridge when i get there
rm -f /tmp/rg-fzf-{r,f}

RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
INITIAL_QUERY="${*:-}"
# haha bind magic
# https://github.com/junegunn/fzf/blob/a4f6c8f9907c4234343c2efe8a1f4b6903568ddb/ADVANCED.md#switching-between-ripgrep-mode-and-fzf-mode-using-a-single-key-binding
: | fzf --ansi --disabled --query "$INITIAL_QUERY" \
    --bind "start:reload:$RG_PREFIX {q}" \
    --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
    --bind 'tab:transform:[[ ! $FZF_PROMPT =~ ripgrep ]] &&
      echo "rebind(change)+change-prompt(1. ripgrep> )+disable-search+transform-query:echo \{q} > /tmp/rg-fzf-f; cat /tmp/rg-fzf-r" ||
      echo "unbind(change)+change-prompt(2. fzf> )+enable-search+transform-query:echo \{q} > /tmp/rg-fzf-r; cat /tmp/rg-fzf-f"' \
    --color "hl:-1:underline,hl+:-1:underline:reverse" \
    --prompt '1. ripgrep> ' \
    --delimiter : \
    --header 'TAB: Switch between ripgrep/fzf' \
    --preview 'bat --theme=ansi --color=always {1} --highlight-line {2}' \
    --preview-window 'border-bottom,+{2}+3/3,~3' \
    --bind 'enter:become(code -g {1}:{2})'
