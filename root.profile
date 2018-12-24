# ~/.profile: executed by Bourne-compatible login shells.

if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi

  # See https://github.com/ericoc/zeromon for more information
  if [ -f ~/.zeromon ]; then
    . ~/.zeromon
  fi
fi

mesg n || true
