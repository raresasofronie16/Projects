function incarcaPersoane() {
    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function () {
      if (this.readyState == 4 && this.status == 200) {
        afiseazaTabel(this);
      }
    };
    xhttp.open("GET", "resurse/persoane.xml", true);
    xhttp.send();
  }
  
  function afiseazaTabel(xml) {
    var xmlDoc = xml.responseXML;
    var table = "<table border='1'>";

    table += "<tr>";
    table += "<th>Nume</th>";
    table += "<th>Prenume</th>";
    table += "<th>Vârsta</th>";
    table += "<th>Strada</th>";
    table += "<th>Număr</th>";
    table += "<th>Localitate</th>";
    table += "<th>Județ</th>";
    table += "<th>Țară</th>";
    table += "<th>Număr de telefon</th>";
    table += "<th>Ocupație</th>";
    table += "<th>Email</th>";

    var x = xmlDoc.getElementsByTagName("persoana");


    for (var i = 0; i < x.length; i++) {
      table += "<tr>";
      table +=
        "<td>" +
        x[i].getElementsByTagName("nume")[0].childNodes[0].nodeValue +
        "</td>";
      table +=
        "<td>" +
        x[i].getElementsByTagName("prenume")[0].childNodes[0].nodeValue +
        "</td>";
      table +=
        "<td>" +
        x[i].getElementsByTagName("varsta")[0].childNodes[0].nodeValue +
        "</td>";
        table +=
        "<td>" +
        x[i].getElementsByTagName("strada")[0].childNodes[0].nodeValue +
        "</td>";
        table +=
        "<td>" +
        x[i].getElementsByTagName("numar")[0].childNodes[0].nodeValue +
        "</td>";
        table +=
        "<td>" +
        x[i].getElementsByTagName("localitate")[0].childNodes[0].nodeValue +
        "</td>";
        table +=
        "<td>" +
        x[i].getElementsByTagName("judet")[0].childNodes[0].nodeValue +
        "</td>";
        table +=
        "<td>" +
        x[i].getElementsByTagName("tara")[0].childNodes[0].nodeValue +
        "</td>";
        table +=
        "<td>" +
        x[i].getElementsByTagName("numar_de_telefon")[0].childNodes[0].nodeValue +
        "</td>";
        table +=
        "<td>" +
        x[i].getElementsByTagName("ocupatie")[0].childNodes[0].nodeValue +
        "</td>";
        table +=
        "<td>" +
        x[i].getElementsByTagName("email")[0].childNodes[0].nodeValue +
        "</td>";
    }
    table += "</table>";
    document.getElementById("continut").innerHTML = table;
  }
  