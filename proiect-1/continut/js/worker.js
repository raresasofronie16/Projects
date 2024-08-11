self.onmessage = function(event) {
    console.log("Web Worker a fost notificat!");

    postMessage("Web Worker a primit notificare!");
};

