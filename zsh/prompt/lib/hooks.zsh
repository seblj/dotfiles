# ------------------------------------------------------------------------------
# HOOKS
# Zsh hooks for advanced actions
# custom hooks for sections
# ------------------------------------------------------------------------------

# TODO: Let sections register their own hooks via `spaceship::register_hook`

spaceship_preexec_hook() {
  # Start measuring exec_time, must be the first preexec action
  spaceship_exec_time_preexec_hook

  # Abort all unfinished async jobs from the previous prompt
  async_flush_jobs spaceship
}

spaceship_precmd_hook() {
  # Retrieve exit code of last command to use in exit_code
  # Must be captured before any other command in prompt is executed
  # Must be the very first line in all entry prompt functions, or the value
  # will be overridden by a different command execution - do not move this line!
  RETVAL=$?

  # Stop measuring exec_time, must be the first precmd action
  spaceship_exec_time_precmd_hook

  # Register async worker
  if [[ -z "$SPACESHIP_ASYNC_INITIALIZED" ]]; then
    async_start_worker spaceship -u -n
    async_register_callback spaceship spaceship_async_callback
    async_worker_eval spaceship 'setopt extendedglob'
    typeset -g SPACESHIP_ASYNC_INITIALIZED=1
  fi

  # Abort all unfinished async jobs from the previous prompt
  async_flush_jobs spaceship

  # Cleanup results from previous prompt, or they will flash for short amount of time
  unset SPACESHIP_ASYNC_RESULTS
  declare -gA SPACESHIP_ASYNC_RESULTS

  # Should it add a new line before the prompt?
  [[ $UID == 0 ]] && SPACESHIP_PROMPT_NEED_NEWLINE=true
  [[ $SPACESHIP_PROMPT_ADD_NEWLINE == true && $SPACESHIP_PROMPT_NEED_NEWLINE == true ]] && echo -n "$NEWLINE"
  SPACESHIP_PROMPT_NEED_NEWLINE=true

  # Switch async worker to the current directory and set environment variables
  async_worker_eval spaceship "cd '$PWD'"
  async_worker_eval spaceship "export PATH='$PATH'"

  # Draw initial prompt (no async jobs started yet)
  PROMPT=$(spaceship::compose_prompt $SPACESHIP_PROMPT_ORDER)
  RPROMPT=$(spaceship::compose_prompt $SPACESHIP_RPROMPT_ORDER)

  # Load all async sections
  spaceship::async_load_prompt $SPACESHIP_PROMPT_ORDER
  spaceship::async_load_prompt $SPACESHIP_RPROMPT_ORDER
}
