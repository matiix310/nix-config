{
  nixgl,
  ...
}:
{
  config = {
    nixGL.packages = nixgl.packages;
    nixGL.defaultWrapper = "mesa";
    nixGL.installScripts = [ "mesa" ];
  };
}
