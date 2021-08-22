OIFS=$IFS; IFS=\|

case $(echo $(basename $ZIPFILE) | tr '[:upper:]' '[:lower:]') in
	*clearG1*) microG=true; clearG1=true; clearG2=false; clearG3=false;;
	*clearG2*) microG=true; clearG1=false; clearG2=true; clearG3=false;;
	*clearG3*) microG=true; clearG1=false; clearG2=false; clearG3=true;;
	*nmicroG*) microG=false; clearG1=false; clearG2=false; clearG3=false;;
esac
case $(echo $(basename $ZIPFILE) | tr '[:upper:]' '[:lower:]') in
	*nk*) NK=true;;
esac
IFS=$OIFS


		if
		 [ -z $microG ] || [ -z $clearG1 ] || [ -z $clearG2 ] || [ -z $clearG3 ]; then
			echo " _________   ________       ______       _________   ________       ______      ";
			echo "/________/\ /_______/\     /_____/\     /________/\ /_______/\     /_____/\     ";
			echo "\__.::.__\/ \::: _  \ \    \:::_ \ \    \__.::.__\/ \::: _  \ \    \:::_ \ \    ";
			echo "   \::\ \    \::(_)  \ \    \:\ \ \ \      \::\ \    \::(_)  \ \    \:\ \ \ \   ";
			echo "    \::\ \    \:: __  \ \    \:\ \ \ \      \::\ \    \:: __  \ \    \:\ \ \ \  ";
			echo "     \::\ \    \:.\ \  \ \    \:\_\ \ \      \::\ \    \:.\ \  \ \    \:\_\ \ \ ";
			echo "      \__\/     \__\/\__\/     \_____\/       \__\/     \__\/\__\/     \_____\/ ";
			echo "                                                                                ";
			ui_print "- 准备好配置zram选项了吗 ?"
			ui_print "   Ready to configure your zram options?"
			ui_print "- 按下音量加=是，按下音量减=否,和退出"
			ui_print "   Press  Vol+ = Yes , Press Vol- = No, and exit "
			if $VKSEL; then
				ui_print " "
				ui_print " "
				ui_print " "
				ui_print "- 是否需要开启2G大小的zram？"
#				ui_print "   Pick among 1, 2 or 3" 
				ui_print "   Do I need to turn on a 2GB zram?" 
				ui_print " "
#				ui_print "   Vol+ = Icon Pack-1, Vol- = Show next"
				ui_print "- 按下音量加=是，按下音量减=显示下一个选项"
				ui_print "   Vol+ = Yes, Vol- = Show the next option"
				microG=true
				if $VKSEL; then
					clearG1=true
					clearG2=false
					clearG3=false					
				else
				    ui_print " "
				    ui_print " "
					ui_print "- 选择开启4G大小的zram或者直接关闭zram"
					ui_print "   Choose to turn on the 4G zRAM or turn it off" 
					ui_print "   Vol+ = Yes, custom, Vol- = Close the zram"
					if $VKSEL; then
						clearG1=false
						clearG2=true
						clearG3=false	
					else
						clearG1=false
						clearG2=false
						clearG3=true	
					fi
				fi
			else
				microG=false
				ui_print "- 安装被取消，模块已卸载" 
				ui_print "  Installation cancelled, module uninstalled" 
				exit 1
			fi
		else
			ui_print "- 模块出错，意外退出" 
	     	ui_print "  The microG has been installed successfully" 
		fi
	

#ui_print "- Follow github：taoaoooo/qq群：273145623"
#ui_print "  Follow Github: taoaoooo/QQ group: 273145623"

mkdir -p $TMPDIR/system/vendor/bin

if $microG; then
	ui_print ">"
	if $clearG1; then
		ui_print "-  挂载根目录..."
		mount -o rw,remount / || echo "error code:80 lines"
		ui_print "-  Copy the file to be operated..."
		cp -f /system/vendor/bin/init.qcom.post_boot.sh $TMPDIR/system/vendor/bin || echo "error code:84 lines"
		vim -e $TMPDIR/system/vendor/bin/init.qcom.post_boot.sh<<-!
		:1,%s/echo\(.*\)\/sys\/block\/zram0\/disksize/echo 2147483648 \> \/sys\/block\/zram0\/disksize/g
		:wq
		!
		ui_print "-  恢复根目录只读..."
		mount -o ro,remount /
#		卸载gsf
	elif $clearG2; then
		ui_print "-  挂载根目录..."
		mount -o rw,remount / || echo "error code:80 lines"
		ui_print "-  Copy the file to be operated..."
		cp -f /system/vendor/bin/init.qcom.post_boot.sh $TMPDIR/system/vendor/bin || echo "error code:84 lines"
		vim -e $TMPDIR/system/vendor/bin/init.qcom.post_boot.sh<<-!
		:1,%s/echo\(.*\)\/sys\/block\/zram0\/disksize/echo 4294967296 \> \/sys\/block\/zram0\/disksize/g
		:wq
		!
		ui_print "-  恢复根目录只读..."
		mount -o ro,remount /
	elif $clearG3; then
		ui_print "-  挂载根目录..."
		mount -o rw,remount / || echo "error code:80 lines"
		ui_print "-  Copy the file to be operated..."
		cp -f /system/vendor/bin/init.qcom.post_boot.sh $TMPDIR/system/vendor/bin || echo "error code:84 lines"
		vim -e $TMPDIR/system/vendor/bin/init.qcom.post_boot.sh<<-!
		:1,%s/echo\(.*\)\/sys\/block\/zram0\/disksize/echo 0 \> \/sys\/block\/zram0\/disksize/g
		:wq
		!
		ui_print "-  恢复根目录只读..."
		ui_print "-  Zram已关闭，如果你后续需要开启请重新运行此安装程序"
		ui_print "   Zram has been turned off, please re-run this setup if you need to turn it on later"
		ui_print "-  或者你也可以在/data/adb/modules/Zram_tao/system/vendor/bin下修改sh"
		ui_print "   Alternatively, you can modify sh under /data/adb/modules/Zram_tao/system/vendor/bin"
		ui_print "-  找到”echo 0 > /sys/block/zram0/disksize“修改0的值大小，比如4294967296是4G，保存后重启生效"
		ui_print "   Find ”echo 0 > /sys/block/zram0/disksize“ modify zero value size, such as 4294967296 is 4 g, save after restart to take effect"
		mount -o ro,remount /
	fi
fi




ui_print " "
ui_print " "
ui_print "- Done  -"
