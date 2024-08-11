    function updateInformations() {
        var dataTimpElement = document.getElementById('data-timp');
        var urlElement = document.getElementById('url');
        var locatieElement = document.getElementById('locație');
        var browserElement = document.getElementById('browser');
        var sistemElement = document.getElementById('sistem');

        var dataCurenta = new Date();
        var adresaURL = window.location.href;
        var locatieCurenta = window.location.pathname;
        var numeBrowser = detecteazaBrowser().nume;
        var versiuneBrowser = detecteazaBrowser().versiune;
        var sistemOperare = detecteazaSistem();

        dataTimpElement.innerHTML = dataCurenta.toLocaleString();
        urlElement.innerHTML = adresaURL;
        locatieElement.innerHTML = locatieCurenta;
        browserElement.innerHTML = numeBrowser + ' ' + versiuneBrowser;
        sistemElement.innerHTML = sistemOperare;
    }

    function detecteazaBrowser() {
        var ua = window.navigator.userAgent;
        var tem;
        var match = ua.match(/(opera|chrome|safari|firefox|msie|trident(?=\/))\/?\s*(\d+)/i) || [];
        if (/trident/i.test(match[1])) {
            tem = /\brv[ :]+(\d+)/g.exec(ua) || [];
            return { nume: 'IE', versiune: (tem[1] || '') };
        }
        if (match[1] === 'Chrome') {
            tem = ua.match(/\b(OPR|Edge?)\/(\d+)/);
            if (tem != null) return { nume: tem[1].replace('OPR', 'Opera'), versiune: tem[2] };
        }
        match = match[2] ? [match[1], match[2]] : [window.navigator.appName, window.navigator.appVersion, '-?'];
        if ((tem = ua.match(/version\/(\d+)/i)) != null) match.splice(1, 1, tem[1]);
        return {
            nume: match[0],
            versiune: match[1]
        };
    }

    function detecteazaSistem() {
        var platform = window.navigator.platform;
        if (platform.toLowerCase().indexOf('win') !== -1) return 'Windows';
        if (platform.toLowerCase().indexOf('mac') !== -1) return 'MacOS';
        if (platform.toLowerCase().indexOf('linux') !== -1) return 'Linux';
        return 'Sistem necunoscut';
    }

    function schimbaContinut(x, jsFisier, jsFunctie) {
        var xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function() {
          if (this.readyState == 4 && this.status == 200) {
            document.getElementById("continut").innerHTML = this.responseText;
            if (jsFisier) {
              var elementScript = document.createElement('script');
              elementScript.onload = function () {
                console.log("Scriptul " + jsFisier + " a fost încărcat.");
                if (jsFunctie) {
                  window[jsFunctie]();
                }
              };
              elementScript.src = jsFisier;
              document.head.appendChild(elementScript);
            } else {
              if (jsFunctie) {
                window[jsFunctie]();
              }
            }
          }
        };
        xhttp.open("GET", x + ".html", true);
        xhttp.send();
    }

    
    function loadLearning(){
        loadCanvas();
        updateInformations();
        loadTable();
    }

function loadCanvas(){
    var culoareConturInput = document.getElementById('culoare-contur');
    var culoareUmplereInput = document.getElementById('culoare-umplere');

    var canvas = document.getElementById('canvas');
    var context = canvas.getContext('2d');

    var startX, startY, endX, endY;

    var culoareContur = culoareConturInput.value;
    var culoareUmplere = culoareUmplereInput.value;

    culoareConturInput.addEventListener('input', function() {
        culoareContur = this.value;
    });

    culoareUmplereInput.addEventListener('input', function() {
        culoareUmplere = this.value;
    });

    function deseneazaDreptunghi(x1, y1, x2, y2) {
        var width = Math.abs(x2 - x1);
        var height = Math.abs(y2 - y1);
        context.beginPath();
        context.strokeStyle = culoareContur;
        context.fillStyle = culoareUmplere;
        context.rect(Math.min(x1, x2), Math.min(y1, y2), width, height);
        context.fill();
        context.stroke();
        context.closePath();
    }

    canvas.addEventListener('mousedown', function(event) {
        startX = event.clientX - canvas.getBoundingClientRect().left;
        startY = event.clientY - canvas.getBoundingClientRect().top;
    });

    canvas.addEventListener('mouseup', function(event) {
        endX = event.clientX - canvas.getBoundingClientRect().left;
        endY = event.clientY - canvas.getBoundingClientRect().top;
        deseneazaDreptunghi(startX, startY, endX, endY);
    });}

    function inserare_linie() {
        var table = document.getElementById("Tabel");
        var pozitie = document.getElementById("pozitie").value;
        var culoare = document.getElementById("culoare").value;

        var row = table.insertRow(pozitie);
        var cellsCount = table.rows[0].cells.length;

        for (var i = 0; i < cellsCount; i++) {
            var cell = row.insertCell(i);
            cell.style.backgroundColor = culoare;
            cell.innerHTML = "Celula nouă";
        }
    }

    function inserare_coloana() {
        var table = document.getElementById("Tabel");
        var pozitie = parseInt(document.getElementById("pozitie").value);
        var culoare = document.getElementById("culoare").value;

        for (var i = 0; i < table.rows.length; i++) {
            var cell = table.rows[i].insertCell(pozitie);
            cell.style.backgroundColor = culoare;
            cell.innerHTML = "Celula nouă";
        }
    }
 function loadTable(){
    document.getElementById('InserareLinie').addEventListener('click', inserare_linie);
    document.getElementById('InserareColoana').addEventListener('click', inserare_coloana);
 }
    

    
    
    


    function moveAudience() {
      var audience = document.querySelectorAll('circle');
      audience.forEach(function(person) {
        var newX = Math.random() * 20 - 10;
        var newY = Math.random() * 20 - 10;
        person.setAttribute('transform', 'translate(' + newX + ' ' + newY + ')');
      });
      setTimeout(moveAudience, 1000); 
    }


