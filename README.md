## はじめに
Trails Risingがなかなか起動しなくて、毎回起動チャレンジするのが面倒ってことで起動スクリプトを作りました。

あくまでも起動チャレンジするスクリプトで起動しない原因を解消するようなツールではありません。

実行中はプロセスを監視し、``trialsrising.exe``がいなかったら起動を試みます。タイトルから移動時に落ちることがあるので起動後にキーを送りタイトルからの遷移に失敗して落ちた場合、起動監視に戻ります。

## wakeup_risingの使い方
後述の設定方法で設定したのちに``wakeup_rising.bat``を実行することで起動チャレンジを自動で指定回数実行します

## 設定方法
wakeup_rising.ps1をエディタで開いて下記を自身の環境に合わせて編集してください。

```ps1
$AppPath = 'C:\Program Files (x86)\steam\steam.exe'; #Steamのパス
$Options = '-applaunch 641080'; #Steamアプリ起動オプション
#$HACOTPath = 'C:\example\HaveACupOfTea\HaveACupOfTea.exe';  #HaveACupOfTeaのパス
$Interval = 10; #起動監視間隔（秒）
$MaxCount = 100; #最大監視回数
$ActiveCount = 6; #起動成功とみなす監視回数
```
### Trails Risingのパスを指定
デフォルトはSteam版の設定になっています。
Steamのインストール先を変更している場合は``$AppPath``を変更してください。
```ps1
$AppPath = 'C:\Program Files (x86)\steam\steam.exe'; #Steamのパス
$Options = '-applaunch 641080'; #Steamアプリ起動オプション
```

Steam版ではない場合は``$AppPath``にtrialsrising.exeのパスを指定し、``$Options``は空にしてください。
```ps1
$AppPath = 'C:\example\trialsrising.exe'; #Steamのパス
$Options = ''; #Steamアプリ起動オプション
```
### 起動に合わせてHACOTを起動する設定
TrialsRising用操作履歴表示UIアプリ「[HACOT](https://github.com/bt4Rivy/Have-A-Cup-Of-Tea)」を利用している場合、Trails Rising起動後にHACOTを起動する設定ができます。

``$HACOTPath``の先頭の「#」を削除しHACOTのパスを指定します。
```ps1
$HACOTPath = 'C:\example\HaveACupOfTea\HaveACupOfTea.exe';  #HaveACupOfTeaのパス
```

## 監視設定
デフォルトの監視回数で起動しないことが多いようであれば、``$MaxCount``を増やしてください。

タイトル画面の表示までに時間が掛かり、次の画面に遷移しないようであれば、``$ActiveCount``を増やしてください。


```ps1
$Interval = 10; #起動監視間隔（秒）
$MaxCount = 100; #最大監視回数
$ActiveCount = 6; #起動成功とみなす監視回数
```

## 更新履歴
2024/07/24 1.0.0