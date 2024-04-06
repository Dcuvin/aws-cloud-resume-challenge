// javascript code for site counter
const counter = document.getElementById("site-counter");

async function siteCounter() {
    let response = await fetch("https://ftpygoafeusb5t4qjt7uyybwya0wfryr.lambda-url.us-east-1.on.aws/");
    let data = await response.json();
    counter.innerHTML = `Views: ${data}`;
    
}
siteCounter();