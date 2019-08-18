function Get-SpecialFolderTable() {
  $m = @{}
  [Environment+SpecialFolder]::GetNames([Environment+SpecialFolder]) | %{
    $m[$_] = [Environment]::GetFolderPath($_)
  }
  $m
}
