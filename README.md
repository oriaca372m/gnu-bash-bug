# GNU bash 5.1.4(1) がマルチバイト文字を持つファイルにリダイレクトすると挙動がおかしくる?

## バグの内容と再現方法
`run.sh` は `test.sh` を10回実行し`mirror.txt` のSHA256を表示するスクリプトです。

`test.sh` についてはファイルを参照してほしいのですが、事実上 `original.txt` をコピーしてSHA256が `7be2ff03bd546feac5c0ec4172389d44c1edfd210d1cfd2216105a2daf0ae4e8` になるファイル `mirror.txt` を作成するスクリプトです。

### 実行結果 (一例)
``` sh
$ ./run.sh
7be2ff03bd546feac5c0ec4172389d44c1edfd210d1cfd2216105a2daf0ae4e8  mirror.txt
2484d2ae23a92ef47c69354ebb5cde864106a699c8e399feb58ce193149c35bc  mirror.txt
7be2ff03bd546feac5c0ec4172389d44c1edfd210d1cfd2216105a2daf0ae4e8  mirror.txt
7be2ff03bd546feac5c0ec4172389d44c1edfd210d1cfd2216105a2daf0ae4e8  mirror.txt
7be2ff03bd546feac5c0ec4172389d44c1edfd210d1cfd2216105a2daf0ae4e8  mirror.txt
711b5041843aa9612d5fb861b966f79e33f4903ed72be53d1a961334588cb69f  mirror.txt
4d18fbe945982944b8b2f568b01cfd9b2d6e667520168fd6671059d6a4bdd3d8  mirror.txt
7be2ff03bd546feac5c0ec4172389d44c1edfd210d1cfd2216105a2daf0ae4e8  mirror.txt
2484d2ae23a92ef47c69354ebb5cde864106a699c8e399feb58ce193149c35bc  mirror.txt
25e366ede3eda54d72af30458d6c163e8485e3ee9e6cb9a261b603638aa3b5b1  mirror.txt
```

このように違うSHA256を持つファイルが作成されることがあります。(全て同じSH256を持つファイルが作成されることもあります。何回か試してみてください。)

また `run.sh` は引数にシェルの名前を与えると他のシェルで `test.sh` を実行することもできます。

### 実行結果
``` sh
$ ./run.sh zsh
7be2ff03bd546feac5c0ec4172389d44c1edfd210d1cfd2216105a2daf0ae4e8  mirror.txt
7be2ff03bd546feac5c0ec4172389d44c1edfd210d1cfd2216105a2daf0ae4e8  mirror.txt
7be2ff03bd546feac5c0ec4172389d44c1edfd210d1cfd2216105a2daf0ae4e8  mirror.txt
7be2ff03bd546feac5c0ec4172389d44c1edfd210d1cfd2216105a2daf0ae4e8  mirror.txt
7be2ff03bd546feac5c0ec4172389d44c1edfd210d1cfd2216105a2daf0ae4e8  mirror.txt
7be2ff03bd546feac5c0ec4172389d44c1edfd210d1cfd2216105a2daf0ae4e8  mirror.txt
7be2ff03bd546feac5c0ec4172389d44c1edfd210d1cfd2216105a2daf0ae4e8  mirror.txt
7be2ff03bd546feac5c0ec4172389d44c1edfd210d1cfd2216105a2daf0ae4e8  mirror.txt
7be2ff03bd546feac5c0ec4172389d44c1edfd210d1cfd2216105a2daf0ae4e8  mirror.txt
7be2ff03bd546feac5c0ec4172389d44c1edfd210d1cfd2216105a2daf0ae4e8  mirror.txt
```

`zsh` と `dash` では違うSHA256を持つファイルが作成されることはありませんでした。

## 再現する環境

### 1
Arch Linux

``` sh
# 通常の linux カーネル
$ uname -a
Linux pc03arch 5.11.11-arch1-1 #1 SMP PREEMPT Tue, 30 Mar 2021 14:10:17 +0000 x86_64 GNU/Linux

$ bash --version
GNU bash, バージョン 5.1.4(1)-release (x86_64-pc-linux-gnu)
Copyright (C) 2020 Free Software Foundation, Inc.
ライセンス GPLv3+: GNU GPL バージョン 3 またはそれ以降 <http://gnu.org/licenses/gpl.html>

This is free software; you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

$ pacman -Qi bash
名前                   : bash
バージョン             : 5.1.004-1
説明                   : The GNU Bourne Again shell
アーキテクチャ         : x86_64
URL                    : https://www.gnu.org/software/bash/bash.html
ライセンス             : GPL
グループ               : なし
提供                   : sh
依存パッケージ         : readline  libreadline.so=8-64  glibc  ncurses
提案パッケージ         : bash-completion: for tab completion
必要パッケージ         : arch-install-scripts  autoconf  automake  base  bison  bzip2  ca-certificates-utils  db  diffutils  dkms  e2fsprogs  fakeroot  fftw  findutils  flex  freetype2  fzf  gawk  gdbm  gettext  gmp  gpm  gradle  gtest  gzip  hdf5  icu  ijs  iptables  java-runtime-common  js78  keyutils  lib32-libltdl  libdca  libgpg-error  libksba  libmbim  libnet  libpaper  libpcap  libpng  libreoffice-fresh  libteam  libtool  libusb-compat  lsb-release  lvm2  m4  man-db  mbedtls  miniupnpc  mkinitcpio  mtools  npth  nspr  nss  p7zip-natspec  pacman  pcre  pcre2  pkgconf  sane  smartmontools  source-highlight  steam  systemd  texinfo  tor  unzip-natspec  vde2  vte-common  which  xdg-user-dirs  xdg-utils  xfsprogs  xz
任意パッケージ         : hdparm  portmidi  vim-runtime
衝突パッケージ         : なし
置換パッケージ         : なし
インストール容量       : 8.19 MiB
パッケージ作成者       : Giancarlo Razzolini <grazzolini@archlinux.org>
ビルド日時             : 2020年12月21日 03時44分21秒
インストール日時       : 2020年12月25日 12時41分43秒
インストール方法       : 明示的にインストール
インストールスクリプト : No
検証方法               : 署名

# LANG=C だと再現しない
$ echo $LANG
ja_JP.utf8
```

### 2
Arch Linuxでカーネル以外は1と同じ
``` sh
# linux-zen カーネル
$ uname -a
Linux pc03arch 5.11.11-zen1-1-zen #1 ZEN SMP PREEMPT Tue, 30 Mar 2021 14:10:21 +0000 x86_64 GNU/Linux
```

## 再現しない環境

- 再現する1の環境のdocker上のubuntu 21.04
- 再現する2の環境のdocker上のubuntu 21.04
