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

function put_spacing() {
  local git=$(git_prompt_info)
  if [ ${#git} != 0 ]; then
    ((git=${#git} - 10))
  else
    git=0
  fi

  local termwidth
  (( termwidth = ${COLUMNS} - 3 - ${#HOST} - ${#$(get_pwd)} - ${bat} - ${git} ))

  local spacing=""
  for i in {1..$termwidth}; do
    spacing="${spacing} " 
  done
  echo $spacing
}

function precmd() {
  print -rP '$fg[cyan]%m: $fg[yellow]$(get_pwd) $(git_prompt_info)'
}

PROMPT='%{$reset_color%}$ '

ZSH_THEME_GIT_PROMPT_PREFIX="[git:"
ZSH_THEME_GIT_PROMPT_SUFFIX="]$reset_color"
ZSH_THEME_GIT_PROMPT_DIRTY="$fg[red]+"
ZSH_THEME_GIT_PROMPT_CLEAN="$fg[green]"
