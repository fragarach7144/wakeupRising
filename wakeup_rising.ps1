####################################################################################################
# 設定
####################################################################################################
$AppPath = 'C:\Program Files (x86)\steam\steam.exe'; #Steamのパス
$Options = '-applaunch 641080'; #Steamアプリ起動オプション
#$HACOTPath = 'C:\example\HaveACupOfTea\HaveACupOfTea.exe';  #HaveACupOfTeaのパス
$Interval = 10; #起動監視間隔（秒）
$MaxCount = 100; #最大監視回数
$ActiveCount = 6; #起動成功とみなす監視回数
# 設定ここまで

Add-Type -AssemblyName microsoft.VisualBasic
Add-Type -AssemblyName System.Windows.Forms

function Wakeup-Rising {
    param
    (
        [string]$ProcessName = "trialsrising",
        [string]$WindowName = "Trials Rising",
        [string]$AppPath = "",
        [string]$Options = "",
        [string]$HACOTPath = "",
        [int]$Interval = 10,
        [int]$MaxCount = 100,
        [int]$ActiveCount = 6
    )
    
    if (!$AppPath) {
        Write-Host "AppPath empty.";
        break;
    }

    $isActive = $false;
    $cnt = 0;
    $active_cnt = 0;

    while ($true) {
        $cnt++;
        if ($MaxCount -lt $cnt) {
            if ($isActive) {
                # 成功確認が完了する前に最大監視回数に達した場合
                Write-Host "Success Wakeup?";
            }
            else {
                # 起動失敗
                Write-Host "failure $MaxCount";
            }
            break;
        }

        # 監視対象のプロセスを取得
        $process = Get-Process -Name $ProcessName -ErrorAction SilentlyContinue;

        #  監視対象のプロセスを監視して実行されていないときはプロセスを立ち上げる
        if (!$process) {
            $isActive = $false;
            Write-Host "Start $ProcessName ($cnt)";
            Start-Process -FilePath $AppPath -ArgumentList $Options;
        }
        else {
            if (!$isActive) {
                # プロセスをアクティブにしてウィンドウを全面に出すために ctrl キーを出力
                # アプリが起動中だと指定したIDのプロセスが見つからないエラーが出るのでエラーハンドリングしておく
                try{
                    [Microsoft.VisualBasic.Interaction]::AppActivate($Process.Id);
                    [System.Windows.Forms.SendKeys]::SendWait("^");
                    Write-Host "activate $WindowName";
                    $isActive = $true;
                    $active_cnt = 0;
                    # HaveACupOfTea を起動する
                    if ($HACOTPath) {
                        # 拡張子なしファイル名
                        $HACOTName = [System.IO.Path]::GetFileNameWithoutExtension($HACOTPath);
                        # 起動確認
                        $HACOT_process = Get-Process -Name $HACOTName -ErrorAction SilentlyContinue;
                        
                        if (!$HACOT_process) {
                            # 作業ディレクトリを実行ファイルのディレクトリにして起動
                            $HACOTDir = Split-Path $HACOTPath -Parent;
                            Start-Process -FilePath $HACOTPath -WorkingDirectory $HACOTDir;
                            Write-Host "Start $HACOTName";
                        } else {
                            # 起動済み
                            Write-Host "Started $HACOTName";
                        }
                    }
                }
                catch {
                    Write-Host "app initialize now...";
                }
            }
            else {
                $active_cnt++;
                if ($ActiveCount -lt $active_cnt) {
                    # 起動完了
                    Write-Host "Success Wakeup.";
                    break;
                } else {
                    Write-Host "... $active_cnt";
                    # プロセスをアクティブにしてctrl キーを送りホームに移動させる
                    try {
                        [Microsoft.VisualBasic.Interaction]::AppActivate($Process.Id);
                        [System.Windows.Forms.SendKeys]::SendWait("^");
                    } catch {
                        # 落ちててキーを送れなかった
                        Write-Host "Missing $WindowName";
                    }
                }
            }
        }
   
        # Interval で指定した間隔で監視を行う
        Start-Sleep -Second $Interval
    }
}

# 実行
Wakeup-Rising `
  -AppPath $AppPath `
  -Options $Options `
  -HACOTPath $HACOTPath `
  -Interval $Interval `
  -MaxCount $MaxCount `
  -ActiveCount $ActiveCount

