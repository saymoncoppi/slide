# test for xfscripts
<html>
  <script>
    var xmlHttp = new XMLHttpRequest();
    xmlHttp.onreadystatechange = function() {
      if (xmlHttp.readyState == 4 && xmlHttp.status == 200) {
        const elemento = document.getElementById("counter");
        elemento.innerHTML = xmlHttp.responseText;
      }
    }
    xmlHttp.open("GET", "https://raw.githubusercontent.com/rauldipeas/radix-website/master/website/download-counter/download-counter.log", false);
    xmlHttp.send(null);
  </script>
</html>
