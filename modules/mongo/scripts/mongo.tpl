#cloud-config
repo_update: true
repo_upgrade: all
packages:
  - python2
  - python3-pip
  - wget
  - gnupg

runcmd:
  - wget https://bootstrap.pypa.io/pip/2.7/get-pip.py
  - sudo python2 get-pip.py

bootcmd:
  - test -z "$(blkid ${actual_dev_name})" && mkfs -t xfs -L ${fs_label} ${actual_dev_name}
  - mkdir -p ${mount_path}
  - sudo mount ${actual_dev_name} ${mount_path} 
  - sudo yum -y install python-pip
 
mounts:
  - [ "${xfs_dev}", "${mount_path}", "xfs", "defaults,nofail", "0", "2" ]
