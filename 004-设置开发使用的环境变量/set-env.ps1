# 设置作用域：用户
$EnvScope = "User";
# set Java Env : javahome path
if($env:JAVA_HOME -ne "C:\Program Files\Java\jdk1.8.0_191"){
    [environment]::SetEnvironmentvariable("JAVA_HOME", "C:\Program Files\Java\jdk1.8.0_191", $EnvScope)
    $path = [environment]::GetEnvironmentvariable("Path", $EnvScope)
    [environment]::SetEnvironmentvariable("Path", $path + "%JAVA_HOME%\bin", $EnvScope)
}

# set Tomcat
#[environment]::SetEnvironmentvariable("CATALINA_HOME", "D:\software\apache-tomcat-7.0.91\", $EnvScope)
$path = [environment]::GetEnvironmentvariable("Path", $EnvScope)
[environment]::SetEnvironmentvariable("Path", $path + ";D:\software\apache-tomcat-7.0.91\lib;D:\software\apache-tomcat-7.0.91\bin", $EnvScope)

# set Maven
#[environment]::SetEnvironmentvariable("MAVEN_HOME", "D:\software\apache-maven-3.6.0\", $EnvScope)
$path = [environment]::GetEnvironmentvariable("Path", $EnvScope)
[environment]::SetEnvironmentvariable("Path", $path + ";D:\software\apache-maven-3.6.0\bin", $EnvScope)

# set Nginx Env
$path = [environment]::GetEnvironmentvariable("Path", $EnvScope)
[environment]::SetEnvironmentvariable("Path", $path + ";D:\software\nginx-1.14.0\", $EnvScope)