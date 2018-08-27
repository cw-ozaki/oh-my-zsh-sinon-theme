function git_remote_diff() {
  diff=(`git diff --name-status remotes/origin/$(current_branch) 2> /dev/null | cat | wc -l`)
  if [ ${diff} = 0 ]; then
    print -D ""
  else
    print -D "$fg[red] ●$reset_color"
  fi
}

function git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_PREFIX$(current_branch)$ZSH_THEME_GIT_PROMPT_SUFFIX$(git_remote_diff)"
}

function get_pwd() {
  print -D $PWD
}
function get_kubernetes_prompt() {
  local context=$(kubectl config current-context)
  local ns=$(kubectl config view -o "jsonpath={.contexts[?(@.name==\"$context\")].context.namespace}")
  print -D "$fg[cyan]($context/${ns:-kube-system})$reset_color"
}

function put_spacing() {
  local git=$(git_prompt_info)
  if [ ${#git} != 0 ]; then
    ((git=${#git} - 10))
  else
    git=0
  fi

  local termwidth
    (( termwidth = ${COLUMNS} - ${#HOST} - ${#$(get_pwd)} - ${git} - ${#$(get_kubernetes_prompt)} + 13 ))

  local spacing=""
  for i in {1..$termwidth}; do
    spacing="${spacing} " 
  done
  echo $spacing
}

function precmd() {
  if kubectl get all >/dev/null 2>&1; then
    print -rP '$fg[cyan]%m: $fg[yellow]$(get_pwd) $(get_kubernetes_prompt) $(git_prompt_info)'
  else
    print -rP '$fg[cyan]%m: $fg[yellow]$(get_pwd) $(git_prompt_info)'
  fi
}

PROMPT='%{$reset_color%}$ '
#RPROMPT='$(get_kubernetes_context)'

ZSH_THEME_GIT_PROMPT_PREFIX="[git:"
ZSH_THEME_GIT_PROMPT_SUFFIX="]$reset_color"
ZSH_THEME_GIT_PROMPT_DIRTY="$fg[red]+"
ZSH_THEME_GIT_PROMPT_CLEAN="$fg[green]"
