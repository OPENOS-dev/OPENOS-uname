# openos-uname — OPENOS 增强版 uname (ASCII logo + 系统信息)
project('openos-uname', 'bash')

# 安装为 openos-uname
install_data('openos-uname.sh',
  install_dir: get_option('bindir'),
  rename: 'openos-uname')

# 可选: 若需替换系统 uname (PATH 前置), 加装为 uname
# install_data('openos-uname.sh',
#   install_dir: get_option('bindir'),
#   rename: 'uname')
