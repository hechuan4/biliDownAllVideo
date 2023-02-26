# 下载哔哩哔哩up主的全部视频

**已阅!,写的狗屁不通.**

**现学的,但好像还真能用~~~~**

## 介绍

~~一键~~两键下载bilibili up主的全部投稿视频,封面,弹幕

## 使用

前提安装: lux ffmpeg 等,具体可以看:https://github.com/hechuan4/BiliFavoritesDownloader



修改两个脚本中的:

```shell
biliUpUid="501435184"
biliUpName="菁夕何汐"

以及
#RSS 地址
rssURL="http://127.0.0.1:1200/bilibili/user/video-all/$biliUpUid"

只改http://127.0.0.1:1200就行
```

然后执行: bilidown-allvideo.sh 脚本

`bash bilidown-allvideo.sh`

大概会自动帮你在 `run`目录生成一份 `xxxx-all-down.sh` 的脚本

然后执行`run`目录的 `xxxx-all-down.sh` 的脚本

`bash run/xxxx-all-down.sh  `

大概就开始下载封面,视频和弹幕了.

### cookies

高画质下载需要设置`cookies.txt`，默认存放在`/root/biliDownAllVideo/cookies/`

Chrome 可以安装 [EditThisCookie](https://chrome.google.com/webstore/detail/editthiscookie/fngmhnnpilhplaeedifhccceomclgfbg) 插件，将`导出格式`设置为`Netscape HTTP Cookies File`然后导出粘贴在`cookies.txt`中即可

## 问题

没有通知功能,没有报错功能,

还有弹幕,有的弹幕会转化失败,不知道原因.类似这种的报错:

```shell
WARNING [code rx8]
Incorrect file format, contiune or exit?
NOTE
Could not load file "/root/biliDownAllVideo/打卡.xml" as a xml file.

Press 'Y' or 'y' to continue, any other key to exit.

不会自动跳过,需要手动输入Y.
```

因为没有通知功能,如果想知道有没有全部下载成功可以在命令后面加:`2>&1 | tee -a bilidownlog.log`

比如:`bash run xxxx-all-down.sh 2>&1 | tee -a bilidownlog.log  `