Configuration ContainerBuild
{
  param ($MachineName)

  Node $MachineName
  {
    #Install the Container Role
    WindowsFeature ContainerInstall
    {
        Ensure = "Present"
        Name   = "Containers"
    }


  }
} 