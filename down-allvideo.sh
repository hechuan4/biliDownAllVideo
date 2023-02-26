#!/bin/bash
lux=/usr/local/bin/lux

#up主的uid
biliUpUid="501435184"
biliUpName="菁夕何汐"
#cookies及所依赖文件的目录
ckDanmakuPath="/root/biliDownAllVideo/cookies/"
#视频下载目录
videoDownPath="/root/biliDownAllVideo/videoDown/"

# 下载封面
wget -P "$videoDownPath$biliUpName/$3" $2
# 重命名封面
#...

# 下载视频
lux -C -c "$ckDanmakuPath"/cookies.txt -o "$videoDownPath$biliUpName/$3" $1
	# 弹幕转化
	for file in "$videoDownPath$biliUpName/$3"/*; do
		if [ "${file##*.}" = "xml" ]; then
			"${ckDanmakuPath}"DanmakuFactory -o "${file%%.cmt.xml*}".ass -i "$file"
			#删除源文件
			#rm "$file"
		fi
	done