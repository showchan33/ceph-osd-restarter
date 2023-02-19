# ceph-osd-restarterの概要

CephのOSDを起動しているマシンで空きメモリが少なくなった場合に、OSDのコンテナを自動で再起動してくれるツールです。<br><br>
This tool automatically restarts the Ceph OSD container when free memory runs low on a machine running OSD.

# 背景

CephをRaspberry Pi等、低スペックのマシンで動かしている場合にOSDがメモリをすぐに占有してしまい、マシン自体がフリーズしてが使えなくなってしまう課題がありました。そこで利用可能メモリが少なくなった場合に、本ツールによりOSDのプロセスを再起動してメモリの空き領域を増やせるようにしました。

# 必要条件

* OSはLinuxのみ対応
* CephのOSDはDockerコンテナで起動していることが前提
    * 例えば[Cephadm](https://docs.ceph.com/en/latest/cephadm/install/)を使ってインストールした場合の構成を想定しています

# 使い方(Usage)

```
$ ./ceph-osd-restarter.sh [実行間隔(秒)] [利用可能メモリの閾値(KB)]
```

### 引数の説明
* 実行間隔(秒)
   * デフォルトは15秒
   * 利用可能なメモリをチェックする間隔
* 利用可能メモリの閾値(KB)
   * デフォルトは250000KB (250MB)
   * 利用可能なメモリがこの値より小さくなった場合に、OSDコンテナが再起動される
* 引数が指定されない場合はデフォルトの値が適用


# Systemdのserviceとして利用する方法

以下の手順でサービス化することも可能です

```
$ sudo cp ceph-osd-restarter.service /etc/systemd/system/
$ sudo cp ceph-osd-restarter.sh /usr/local/bin/
$ sudo systemctl start ceph-osd-restarter.service
$ sudo systemctl enable ceph-osd-restarter.service
```

# License
"ceph-osd-restarter" is under [GPL license](https://www.gnu.org/licenses/licenses.en.html).
 
