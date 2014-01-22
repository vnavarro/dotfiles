#!/bin/sh

cutstring="DO NOT EDIT BELOW THIS LINE"

if [ ! -e "$HOME/.oh-my-zsh" ]; then
git clone https://github.com/vnavarro/oh-my-zsh "$HOME/.oh-my-zsh"
fi

for name in *; do
target="$HOME/.$name"
  if [ -e "$target" ]; then
if [ ! -L "$target" ]; then
cutline=`grep -n -m1 "$cutstring" "$target" | sed "s/:.*//"`
      if [ -n "$cutline" ]; then
cutline=$((cutline-1))
        echo "Updating $target"
        head -n $cutline "$target" > update_tmp
        startline=`sed '1!G;h;$!d' "$name" | grep -n -m1 "$cutstring" | sed "s/:.*//"`
        if [ -n "$startline" ]; then
tail -n $startline "$name" >> update_tmp
        else
cat "$name" >> update_tmp
        fi
mv update_tmp "$target"
      else
echo "WARNING: $target exists but is not a symlink."
      fi
fi
else
if [ "$name" != 'install.sh' ] && [ "$name" != 'README.md' ]; then
echo "Creating $target"
      if [ -n "$(grep "$cutstring" "$name")" ]; then
cp "$PWD/$name" "$target"
      else
ln -s "$PWD/$name" "$target"
      fi
fi
fi
done

if [ ! -e "$HOME/.vim/bundle/vundle" ]; then
mkdir -p "$HOME/.vim/bundle"
  git clone http://github.com/gmarik/vundle "$HOME/.vim/bundle/vundle"
fi

vim +BundleInstall +qa! && echo "Done! :)"