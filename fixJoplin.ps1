# 通过进程获取句柄
$process = Get-Process -Name "Joplin"

# 过滤出不为0的
$process.MainWindowHandle | ForEach-Object {
    if ($_ -ne 0) {
        # Write-Host $_
        $joplinWIN = $_
    }
}

# 调用win32 API 最大化窗口,使 Joplin 从另外一个不存在的显示器过来【
$code = @'
[DllImport("user32.dll", EntryPoint = "ShowWindow", CharSet = CharSet.Auto)] public extern static bool ShowWindow(IntPtr hwnd, uint nCmdShow);
'@

$myAPI = Add-Type -MemberDefinition $code  -Name myAPI -PassThru

# ShowWindow 函数，设置指定窗口的显示状态。第一参数为指定窗口的句柄，第二参数即为需要设置的状态
# (部分常用值：0-隐藏，1-正常显示，2-最小化，3-最大化，9-还原)
$myAPI::ShowWindow($joplinWIN, 3)