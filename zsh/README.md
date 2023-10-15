fishに移動したのでzshは使われなくなります。

```shell
mv  ~/.zshrc  ~/.zshrc.original
ln -s dotfiles/zsh/.zshrc ~/
ln -s dotfiles/zsh/.zshrc.profile.zsh ~/
ln -s dotfiles/zsh/.zshrc.profile.alias.zsh ~/
ln -s dotfiles/zsh/.zshrc.profile.iterm.zsh ~/
```
