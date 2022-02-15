#!/bin/sh


CONF_DIR=/etc/sillyGirl


if [ -z $CODE_DIR ]; then
  CODE_DIR=/sillyGirl
fi


if [  "$ENABLE_GOPROXY" = "true" ]; then
  export GOPROXY=https://goproxy.io,direct 
  echo "启用 goproxy 加速 ${GOPROXY}"
else
  echo "未启用 goproxy 加速"
fi

 echo "正在安装musl和glibc..."
 mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2


if [ "$ENABLE_GITHUBPROXY" = "true" ]; then
   GITHUBPROXY=https://gh.52mss.cf/
   echo "启用 github 加速 ${GITHUBPROXY}"
else
  echo "未启用 github 加速"
fi


if [ ! -f $CODE_DIR/sillyGirl ]; then
  echo "sillyGirl 不存在  添加 sillyGirl"
  cd $CODE_DIR && wget -O sillyGirl ${GITHUBPROXY}https://github.com/cdle/sillyGirl/releases/download/main/sillyGirl_linux_amd64 && chmod 777 sillyGirl
  
else
  echo "sillyGirl 已存在  备份 sillyGirl"
  cd $CODE_DIR && mv sillyGirl sillyGirl.bak
  echo "下载最新 sillyGirl"
  cd $CODE_DIR && wget -O sillyGirl ${GITHUBPROXY}https://github.com/cdle/sillyGirl/releases/download/main/sillyGirl_linux_amd64 && chmod 777 sillyGirl
fi
if [ ! -f $CODE_DIR/sillyGirl ]; then
  echo "远程获取sillyGirl失败，从备份恢复"
  cd $CODE_DIR && cp sillyGirl.bak sillyGirl && chmod 777 sillyGirl
fi


echo "启动"
  ./sillyGirl

echo -e "=================== 启动完毕，如果第一次配置机器人，请手动以前台模式启动 ==================="


crond -f >/dev/null 2>&1
exec "$@"


