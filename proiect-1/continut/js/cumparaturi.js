class Stocare {
    constructor() {}

    adaugaProdus(produs) {
    }

    obtineToateProdusele() {
    }
}

class StocareLocalStorage extends Stocare {
    constructor() {
        super();
    }

    adaugaProdus(produs) {
        let produse = JSON.parse(localStorage.getItem('produse')) || [];
        produse.push(produs);
        localStorage.setItem('produse', JSON.stringify(produse));
    }

    obtineToateProdusele() {
        return JSON.parse(localStorage.getItem('produse')) || [];
    }
}

class StocareIndexedDB extends Stocare {
    constructor() {
        super();
        this.dbName = 'ListaCumparaturiDB';
        this.storeName = 'produse';
        this.db = null;
        this.initIndexedDB();
    }

    initIndexedDB() {
        const request = indexedDB.open(this.dbName);

        request.onerror = function() {
            console.error('Eroare la deschiderea bazei de date IndexedDB.');
        };

        request.onupgradeneeded = function(event) {
            const db = event.target.result;
            db.createObjectStore('produse', { keyPath: 'id', autoIncrement: true });
        };

        request.onsuccess = function(event) {
            this.db = event.target.result;
            console.log('Conexiune reușită cu baza de date IndexedDB.');
        }.bind(this);
    }

    adaugaProdus(produs) {
        const transaction = this.db.transaction([this.storeName], 'readwrite');
        const objectStore = transaction.objectStore(this.storeName);
        const request = objectStore.add(produs);
        
        request.onerror = function() {
            console.error('Eroare la adăugarea produsului în IndexedDB.');
        };

        request.onsuccess = function() {
            console.log('Produs adăugat în IndexedDB:', produs);
        };
    }

    obtineToateProdusele() {
        return new Promise((resolve, reject) => {
            const transaction = this.db.transaction([this.storeName], 'readonly');
            const objectStore = transaction.objectStore(this.storeName);
            const request = objectStore.getAll();

            request.onerror = function() {
                reject('Eroare la obținerea produselor din IndexedDB.');
            };

            request.onsuccess = function() {
                resolve(request.result);
            };
        });
    }
}
 function loadStore() {
    const localStorageButton = document.getElementById('localStorageButton');
    const indexedDBButton = document.getElementById('indexedDBButton');
    const addButton = document.getElementById('adauga');
    const tbody = document.getElementById('tbodyProduse');

    let stocare;

    localStorageButton.addEventListener('click', function() {
        stocare = new StocareLocalStorage();
        console.log('Stocare selectată: localStorage');
    });

    indexedDBButton.addEventListener('click', function() {
        stocare = new StocareIndexedDB();
        console.log('Stocare selectată: IndexedDB');
    });

    addButton.addEventListener('click', async function() {
        const nume = document.getElementById('nume').value;
        const cantitate = document.getElementById('cantitate').value;
        const produs = { nume, cantitate };

        if (stocare) {
            stocare.adaugaProdus(produs);
            console.log('Produs adăugat:', produs);
            afisareProdus(await stocare.obtineToateProdusele());
        } else {
            console.error('Selectați mai întâi o modalitate de stocare!');
        }
    });

    const afisareProdus = (produse) => {
        tbody.innerHTML = '';
        produse.forEach((produs, index) => {
            const newRow = document.createElement('tr');
            newRow.innerHTML = `
                <td>${index + 1}</td>
                <td>${produs.nume}</td>
                <td>${produs.cantitate}</td>
            `;
            tbody.appendChild(newRow);
        });
    };
};
