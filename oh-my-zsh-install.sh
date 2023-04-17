#!/bin/bash

if ! which git > /dev/null 2>&1; then
    echo -e "\ngit is not found.\nexit with code 1.\n"
    exit 1
elif ! which curl > /dev/null 2>&1; then
    echo -e "\ncurl is not found.\nexit with code 1.\n"
    exit 1
elif ! which zsh > /dev/null 2>&1; then
    echo -e "\nzsh is not found.\nexit with code 1.\n"
    exit 1
fi

curl -k -sSL https://gitee.com/mirrors/oh-my-zsh/raw/master/tools/install.sh | sed "s/\$REMOTE/https:\/\/gitee.com\/mirrors\/oh-my-zsh.git/g" | sed "/.*exec zsh.*/d" > $HOME/.temp

cat <<EOF >> $HOME/.temp

git clone https://github.com/spaceship-prompt/spaceship-prompt.git "\$ZSH/custom/themes/spaceship-prompt" --depth=1
ln -s "\$ZSH/custom/themes/spaceship-prompt/spaceship.zsh-theme" "\$ZSH/custom/themes/spaceship.zsh-theme"
echo -e "\n"

git clone https://github.com/zsh-users/zsh-autosuggestions.git \${ZSH:-~/.oh-my-zsh}/custom/plugins/zsh-autosuggestions
echo -e "\n"

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \${ZSH:-~/.oh-my-zsh}/custom/plugins/zsh-syntax-highlighting
echo -e "\n"

git clone https://github.com/conda-incubator/conda-zsh-completion.git \${ZSH:-~/.oh-my-zsh}/custom/plugins/conda-zsh-completion
EOF

sh $HOME/.temp
rm -rf $HOME/.temp

sed -i "s/ZSH_THEME=\".*/ZSH_THEME=\"spaceship\"/g" $HOME/.zshrc
sed -i "s/plugins=(git)/plugins=(git sudo zsh-autosuggestions zsh-syntax-highlighting conda-zsh-completion pip ufw docker docker-compose extract command-not-found)/g" $HOME/.zshrc

cat <<EOF >> $HOME/.zshrc

# 关闭 git 显示
SPACESHIP_GIT_SHOW=false
# 关闭 node 显示
SPACESHIP_NODE_SHOW=false
# 关闭 maven 显示
SPACESHIP_MAVEN_SHOW=false
# 关闭 package 显示
SPACESHIP_PACKAGE_SHOW=false

zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes
EOF

exec zsh -l
