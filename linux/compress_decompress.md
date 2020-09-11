# Linux 常用压缩和解压

- tar格式

  ```bash
  # 解包：
  [＊＊＊＊＊＊＊]$ tar xvf FileName.tar
  # 打包：
  [＊＊＊＊＊＊＊]$ tar cvf FileName.tar DirName
  #（注：tar是打包，不是压缩！）
  ```

- gz格式

  ```bash
  # 解压1：
  [＊＊＊＊＊＊＊]$ gunzip FileName.gz
  # 解压2：
  [＊＊＊＊＊＊＊]$ gzip -d FileName.gz
  # 压 缩：
  [＊＊＊＊＊＊＊]$ gzip FileName
  ```

- tar.gz格式

  ```bash
  # 解压：
  [＊＊＊＊＊＊＊]$ tar zxvf FileName.tar.gz
  # 压缩：
  [＊＊＊＊＊＊＊]$ tar zcvf FileName.tar.gz DirName
  ```

- bz2格式

  ```bash
  # 解压1：
  [＊＊＊＊＊＊＊]$ bzip2 -d FileName.bz2
  # 解压2：
  [＊＊＊＊＊＊＊]$ bunzip2 FileName.bz2
  # 压 缩： 
  [＊＊＊＊＊＊＊]$ bzip2 -z FileName
  ```

- tar.bz2格式

  ```bash
  # 解压：
  [＊＊＊＊＊＊＊]$ tar jxvf FileName.tar.bz2
  # 压缩：
  [＊＊＊＊＊＊＊]$ tar jcvf FileName.tar.bz2 DirName
  ```

- bz格式

  ```bash
  # 解压1：
  [＊＊＊＊＊＊＊]$ bzip2 -d FileName.bz
  # 解压2：
  [＊＊＊＊＊＊＊]$ bunzip2 FileName.bz
  ```

- tar.bz格式

  ```bash
  # 解压：
  [＊＊＊＊＊＊＊]$ tar jxvf FileName.tar.bz
  ```

- Z格式

  ```bash
  # 解压：
  [＊＊＊＊＊＊＊]$ uncompress FileName.Z
  # 压缩：
  [＊＊＊＊＊＊＊]$ compress FileName
  ```

- tar.Z格式

  ```bash
  # 解压：
  [＊＊＊＊＊＊＊]$ tar Zxvf FileName.tar.Z
  # 压缩：
  [＊＊＊＊＊＊＊]$ tar Zcvf FileName.tar.Z DirName
  ```

- tgz格式

  ```bash
  # 解压：
  [＊＊＊＊＊＊＊]$ tar zxvf FileName.tgz
  ```

- tar.tgz格式

  ```bash
  # 解压：
  [＊＊＊＊＊＊＊]$ tar zxvf FileName.tar.tgz
  # 压缩：
  [＊＊＊＊＊＊＊]$ tar zcvf FileName.tar.tgz FileName
  ```

- zip格式

  ```bash
  # 解压：
  [＊＊＊＊＊＊＊]$ unzip FileName.zip
  # 压缩：
  [＊＊＊＊＊＊＊]$ zip FileName.zip DirName
  ```

- lha格式

  ```bash
  # 解压：
  [＊＊＊＊＊＊＊]$ lha -e FileName.lha
  # 压缩：
  [＊＊＊＊＊＊＊]$ lha -a FileName.lha FileName
  ```

- rar格式

  ```bash
  # 解压：
  [＊＊＊＊＊＊＊]$ rar a FileName.rar
  # 压缩：
  [＊＊＊＊＊＊＊]$ rar e FileName.rar
  ```

- unrar 解压到指定文件夹：

  ```bash
  # 解压: 
  [＊＊＊＊＊＊＊]$ unrar x *.rar  /tmp
  # rar请到：http://www.rarsoft.com/download.htm 下载！
  # 解压后请将rar_static拷贝到/usr/bin目录（其他由$PATH环境变量指定的目录也行）：
  [＊＊＊＊＊＊＊]$ cp rar_static /usr/bin/rar
  ```

- tar.xz

  ```bash
  # 解压：
  [＊＊＊＊＊＊＊]$ xz -d linux-3.12.50.tar.xz
  # 压缩：
  [＊＊＊＊＊＊＊]$ xz -z linux-3.12.50.tar

  # 安装 xz
  # 1 下载包
  [＊＊＊＊＊＊＊]$ wget http://tukaani.org/xz/xz-5.2.2.tar.gz
  # 2 解压
  [＊＊＊＊＊＊＊]$ tar -zxf xz-5.2.2.tar.gz
  # 3 编译安装
  [＊＊＊＊＊＊＊]$ ./configure  
  [＊＊＊＊＊＊＊]$ make && make install
  ```
