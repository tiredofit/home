{
  appimageTools,
  fetchurl,
  lib,
  makeDesktopItem,
}:


appimageTools.wrapType2 rec {
  pname = "chatbox-ai";
  version = "1.9.2";

  src = fetchurl {
    url = "https://download.chatboxai.app/releases/Chatbox-${version}-x86_64.AppImage";
    hash = "sha256-SDiad6IbIVMMMvKkI1QaymF4PN+nu07EeAynuiVaMrg=";
  };

  desktopItems = [
    (makeDesktopItem {
      name = "chatbox-ai";
      exec = "chatbox-ai";
      terminal = false;
      desktopName = "Chatbox AI";
      comment = "User-friendly Desktop Client App for AI Models/LLMs (GPT, Claude, Gemini, Ollama...)";
      categories = [ "Network" ];
    })
  ];
}
