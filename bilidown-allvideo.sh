#!/bin/bash
lux=/usr/local/bin/lux

#up主的uid
biliUpUid="501435184"
biliUpName="菁夕何汐"
#RSS 地址
rssURL="http://127.0.0.1:1200/bilibili/user/video-all/$biliUpUid"
#cookies及所依赖文件的目录
ckDanmakuPath="/root/biliDownAllVideo/cookies/"
#视频下载目录
videoDownPath="/root/biliDownAllVideo/videoDown/"

banben="0.01"
## 字体颜色
Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[信息]${Font_color_suffix}"
Error="${Red_font_prefix}[错误]${Font_color_suffix}"
Tip="${Green_font_prefix}[注意]${Font_color_suffix}"


#抓取rss更新
#rssContent=$(wget $rssURL -q -O -)
#对rssContent进行初次正则处理。获取所有投稿bv链接的正则表达式:(?<=<link>)https://www.bilibili.com/.*?(?=</link>)
#reRssContent=$(egrep '<link>https://www.bilibili.com/video/.*?' $rssContent)
#对rssContent进行二次正则处理,获得下载链接并写入文件。
#biliLinks=$(egrep -o '[h]ttps://www.bilibili.com/.*\w{10}' $reRssContent >> $ckDanmakuPath/biliLinks.txt)


wgetRssUrl(){
	# 抓取rss更新
	wget -P ./temp $rssURL
	
	# 正则处理,获取所有投稿bv链接的正则表达式:(?<=<link>)https://www.bilibili.com/.*?(?=</link>)
	egrep '<link>https://www.bilibili.com/video/.*?' temp/$biliUpUid > temp/$biliUpUid.txt
	# 进行二次正则处理,获得下载链接写入文件。
	egrep -o '[h]ttps://www.bilibili.com/.*\w{10}' temp/$biliUpUid.txt > temp/$biliUpUid-videoLinks.txt
	rm temp/$biliUpUid.txt
	
	# 正则处理,获取所有封面链接
	egrep -o 'http://i[0-9]\.hdslb\.com\/bfs\/archive\/[a-zA-Z0-9]*\.jpg' temp/$biliUpUid > temp/$biliUpUid-fengmian.txt
	
	# 获取全部视频标题
	egrep -o '<title>\s*<!\[CDATA\[(.*?)\]\]>\s*</title>' temp/$biliUpUid > temp/$biliUpUid-title1.txt
	sed '1d;s/^.\{16\}//;s/.\{11\}$//' temp/$biliUpUid-title1.txt > temp/$biliUpUid-title.txt
	rm temp/$biliUpUid-title1.txt
	
	# 合并上面生成的文件,并加""号
	sed 's/^/"/;s/$/"/' temp/$biliUpUid-videoLinks.txt > temp/$biliUpUid-heBing1.txt
	sed 's/^/"/;s/$/"/' temp/$biliUpUid-fengmian.txt > temp/$biliUpUid-heBing2.txt
	sed 's/^/"/;s/$/"/' temp/$biliUpUid-title.txt > temp/$biliUpUid-heBing3.txt
	paste temp/$biliUpUid-heBing1.txt temp/$biliUpUid-heBing2.txt  temp/$biliUpUid-heBing3.txt > temp/$biliUpUid-heBing4.txt
	
	# 生成运行命令
	# 合并每一行前面加上/root/biliDownAllVideo/bilidown-allvideo.sh 命令:sed 's/^/\/root\/biliDownAllVideo\/bilidown-allvideo.sh /'
	sed 's/^/\/root\/biliDownAllVideo\/down-allvideo.sh /' temp/$biliUpUid-heBing4.txt > run/$biliUpUid-all-down.sh
	sed -i '1i\#!/bin/bash' run/$biliUpUid-all-down.sh
	
	# 删除多余的临时文件
	rm temp/$biliUpUid*
	chmod +x run/$biliUpUid-all-down.sh
	echo run/$biliUpUid-all-down.sh 脚本应该已经生成,手动运行: bash ./run/$biliUpUid-all-down.sh
}

downAllVideo(){

	# 下载封面
	wget -P "$videoDownPath$biliUpName/$3" $2
	fengmianName=$2 | awk -F/ '{print $NF}' | awk -F. '{print $1}' 
	mv "$videoDownPath$biliUpName/$3/$fengmianName.jpg"  "$videoDownPath$biliUpName/$3/poster.jpg"
	
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

}

upRclone(){
	#上传至OneDrive 百度云 自行修改 rclone 不会用可以看:http://hechuan.me/rclone
	/usr/bin/rclone copy "$videoDownPath" od-bilidown-pypypy:/bilidown-6
	#/usr/local/bin/BaiduPCS-Go upload "$videoLocation$name" /

}

cookiesOk(){
	#Cookies可用性检查
    stat=$($lux -i -c "$ckDanmakuPath"cookies.txt https://www.bilibili.com/video/BV1fK4y1t7hj)
    substat=${stat#*Quality:}
    data=${substat%%#*}
    quality=${data%%Size*}
    if [[ $quality =~ "1080P" ]]; then
		echo "
		————————————
		Cookies 文件可用!
		————————————"
	else echo "
		————————————
        Cookies 文件失效!
		————————————"
    fi

}

echo && echo -e " 哔哩哔哩up主所有视频投稿下载脚本 ${Red_font_prefix}[v${banben}]${Font_color_suffix}
  -- | http://hechuan.me --
  
 ${Green_font_prefix} 0.${Font_color_suffix} 生成运行命令
————————————
 ${Green_font_prefix} 1.${Font_color_suffix} 下载所有视频,封面,弹幕 不要选这个,写的狗屁不通
 ${Green_font_prefix} 2.${Font_color_suffix} 上传 rclone
 ${Green_font_prefix} 3.${Font_color_suffix} 检查 cookies 可用性
————————————" && echo

read -e -p " 请输入数字 [0-4]:" num
case "$num" in
	0)
	wgetRssUrl
	;;
	1)
	downAllVideo
	;;
	2)
	upRclone
	;;
	3)
	cookiesOk
	;;
	*)
	echo "请输入正确数字 [0-4]"
	;;
esac