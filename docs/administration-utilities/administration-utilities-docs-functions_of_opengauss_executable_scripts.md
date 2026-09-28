# openGauss可运行脚本功能说明

以下是openGauss常用可执行脚本，仅供openGauss接口使用。

**表 1**  脚本功能说明

脚本明成 功能说明 UpgradeUtility.py 升级工具。
KerberosUtility.py 安装/卸载kerberos认证方式。
Uninstall.py 卸载数据库数据库实例。
LocalCheck.py 本地节点检查。
Install.py 安装数据库节点实例。
CheckUninstall.py 检查节点是否已卸载。
PreInstallUtility.py 前置工具。
CleanInstance.py 删除数据库实例。
CleanOsUser.py 删除节点Osuser。
Resetreplconninfo.py 是用于重置本地 Replconninfo。
LocalPerformanceCheck.py 检查SSD信息。
CheckUpgrade.py 升级之前检查节点环境变量。
InitInstance.py 初始化数据库。
Backup.py 备份二进制文件和参数文件。
ConfigInstance.py 配置数据库实例。
CheckConfig.py 检查节点配置信息。
ConfigHba.py 配置pghba.cong文件等。
ExecuteSql.py 执行数据库sql命令。
LocalCheckOS.py 检查本地OS信息。
UnPreinstallUtility.py 清除前置过程中的配置。
CheckPreinstall.py 检查节点是否已进行前置。
CheckInstall.py 检查节点安装信息。
GaussStat.py 统计数据库中的节点信息。
CheckPythonVersion.py 检查python版本。
expect.sh 自动输入交互密码。
CheckSshAgent.py 负责保护ssh互信中的ssh-agent进程，互信进程保护工具。
LocalCollect.py 收集本地的文件信息及参数信息。
killall killall是系统不存在killall命令时供om使用的自研工具，其替代部分系统killall功能。
transfer.py 用于将C函数lib文件传输到所有节点或备用节点。
Restore.py 恢复二进制文件和参数文件。
StartInstance.py 用于启动数据库。
StopInstance.py 用于停止数据库。
py_pstree.py 用于杀死进程。
install.sh 单节点安装脚本。
one_master_one_slave.sh 一主一备一键安装脚本。
sshexkey_encrypt_tool.sh 负责用ssh-keygen命令生成秘钥文件（经过密码短语加密）的脚本，互信工具专用。
dms_contrl.sh 资源池化提供给CM使用，用于启停gaussdb（不建议外界单独调用）。
dss_contrl.sh 资源池化提供给CM使用，用于启停dssserver进程（不建议外界单独调用）。
ssh-agent.sh 负责拉起ssh-agent进程的shell脚本，互信模块专用。
