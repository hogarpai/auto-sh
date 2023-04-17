#! /bin/bash
# author: wangyingbo
# date: 2021-11-26 13:00

# zshrc文件路径
file_zshrc=~/.zshrc;

echo -e "\n"

files=$(ls ~/.oh-my-zsh 2> /dev/null | wc -l) # 判断目录下是否存在已知后缀名文件
if [ $files -ne 0 ] ; then 
	echo -e "\033[32;40m congratulations, the terminal has oh-my-zsh! \033[0m"
else
	echo -e "\033[31;40m warning: no oh-my-zsh，please install oh-my-zsh first!!! \033[0m"
	exit 1
fi

echo -e "\n"
echo -e "\033[33;40m will begin install oh-my-zsh plugins，please wait a minute \033[0m"
echo -e "\n"

# z is exist:方法不可用
isExistZ() {
	para=0
	file=`command -v _z | grep "_z"`
	echo $file
	if [[ $file =~ "_z" ]] ; then
		para=1
	else
		echo ""
	fi
	return $para
}

# isExistZ
# resZ=`echo $?`
# echo $resZ
# if [[ $resZ -eq 1 ]]; then
# 	echo -e "\033[32;40m have installed the plugin z \033[0m"
# else
# 	echo -e "\033[33;40m will begin install plugin z \033[0m"
# fi


newPlugins=""
# 安装 plugin z
if [[ -d ~/.oh-my-zsh/custom/plugins/z ]]; then
	echo -e "\033[32;40m have installed the plugin z \033[0m"
	echo -e "\n"
else	
	echo -e "\033[33;40m will begin install plugin z \033[0m"
	echo -e "\n"
	git clone https://github.com/rupa/z.git $ZSH_CUSTOM/plugins/z
	newPlugins+=" z"
	echo -e "\033[32;40m have installed the plugin z \033[0m"
fi
if [[ ! -d ~/.oh-my-zsh/custom/plugins/z ]]; then
	echo -e "\033[31;40m error:install plugin zerror! \033[0m"
	exit 1
fi

# 安装 plugin zsh-autosuggestions
if [[ -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]]; then
	echo -e "\033[32;40m have installed the plugin zsh-autosuggestions \033[0m"
	echo -e "\n"
else	
	echo -e "\033[33;40m will begin install plugin zsh-autosuggestions \033[0m"
	echo -e "\n"
	git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
	newPlugins+=" zsh-autosuggestions"
	echo -e "\033[32;40m have installed the plugin zsh-autosuggestions \033[0m"
fi
if [[ ! -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]]; then
	echo -e "\033[31;40m error:install plugin zsh-autosuggestionserror! \033[0m"
	exit 1
fi

# 安装 zsh-syntax-highlighting
if [[ -d ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]]; then
	echo -e "\033[32;40m have installed the plugin zsh-syntax-highlighting \033[0m"
	echo -e "\n"
else	
	echo -e "\033[33;40m will begin install plugin zsh-syntax-highlighting \033[0m"
	echo -e "\n"
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
	newPlugins+=" zsh-syntax-highlighting"
	echo -e "\033[32;40m have installed the plugin zsh-syntax-highlighting \033[0m"
fi
if [[ ! -d ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]]; then
	echo -e "\033[31;40m error:install plugin zsh-syntax-highlightingerror! \033[0m"
	exit 1
fi

# 匹配以plugin开头，以)结尾的字符串
plugins=`grep "^plugin.*)$" $file_zshrc`
echo "current plugins: $plugins"
echo -e "\n"

# newPlugins+=" z"
# newPlugins+=" zsh-autosuggestions"
# newPlugins+=" zsh-syntax-highlighting"
echo "new plugins：$newPlugins"
echo -e "\n"

# 获取已有的plugin的长度
oriLength=${#plugins}
# echo "原来plugins字符串长度是：$oriLength"
# echo -e "\n"
replaceIndex=$oriLength-1

# 合并为新的plugins
replacePlugins=${plugins:0:$replaceIndex}$newPlugins${plugins:$replaceIndex}
echo "merged plugins：$replacePlugins"
echo -e "\n"

# 将某个文件中的字符串替换为新字符串 mac环境和linux环境 sed -i 使用不同
# Mac使用：https://www.cnblogs.com/chunzhulovefeiyue/p/6561497.html
# Linux使用：https://www.cnblogs.com/A121/p/10621152.html

# eg:把文件中的jack替换成tom，并给源文件添加.backup后缀并备份；添加/g是全部替换，默认每行只替换一次。
# sed -i ".backup" 's/jack/tom/g' $file_zshrc

sed -i ".backup" "s/$plugins/$replacePlugins/" $file_zshrc

totalPlugins=`grep "^plugin.*)$" $file_zshrc`
echo "total end plugin: $totalPlugins"
echo -e "\n"

# 更新 .zshrc 文件
source $file_zshrc

# 输出脚本执行用时
echo -e "\n"
echo -e "\033[32;40m this shell script execution duration(脚本执行时长): ${SECONDS}s  \033[0m"
