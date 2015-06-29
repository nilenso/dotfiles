# Grab the current version of ruby in use (via RVM): [ruby-1.8.7]
if which rbenv &> /dev/null; then
  CAMO_CURRENT_RUBY_="%{$fg[white]%}%{$fg[magenta]%}\$(rbenv version | sed -e 's/ (set.*$//')%{$fg[white]%}%{$reset_color%}"
else
  CAMO_CURRENT_RUBY_="unknown ruby"
fi

# Grab the current filepath, use shortcuts: ~/Desktop
# Append the current git branch, if in a git repository
CAMO_CURRENT_LOCA_="%{$fg_bold[red]%}%~\$(git_prompt_info)%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[white]%} %{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"

# Do nothing if the branch is clean (no changes).
ZSH_THEME_GIT_PROMPT_CLEAN="%{$reset_color%}"

# Add a yellow ✗ if the branch is dirty
ZSH_THEME_GIT_PROMPT_DIRTY="%{$reset_color%} %{$fg[yellow]%}✗"

# Put it all together!
PROMPT="$CAMO_CURRENT_RUBY_ $CAMO_CURRENT_LOCA_ Ϙ "

