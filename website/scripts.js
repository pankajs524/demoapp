const app = document.getElementById('mainDemo')

const container = document.createElement('div')
app.appendChild(container)

var request = new XMLHttpRequest()
request.open('GET', 'https://api.open-meteo.com/v1/forecast?latitude=38.8943&longitude=-77.4311&hourly=temperature_2m&timezone=America%2FNew_York&forecast_days=1', true)
request.onload = function () {
  // Begin accessing JSON data here
  var data = JSON.parse(this.response)
  if (request.status >= 200 && request.status < 400) {
    const p = document.createElement('p')
    p.textContent = `Latitude : ${data.latitude}`
    app.appendChild(p)
    const p1 = document.createElement('p')
    p1.textContent = `Longitude : ${data.longitude}`
    app.appendChild(p1)
    const p2 = document.createElement('p')
    p2.textContent = `Timezone : ${data.timezone}`
    app.appendChild(p2)
    var hourly = Object.keys(data).hourly
    //const p3 = document.createElement('p')
   //p3.textContent = `Timezone : ${data.hourly}`
   //app.appendChild(p3)
   addTable(data);
  }
  else {
    const errorMessage = document.createElement('div')
    errorMessage.textContent = `Gah, it's not working!`
    app.appendChild(errorMessage)
  }
}


function addTable(data) {
    var myTableDiv = document.getElementById("mainDemo");
  
    var table = document.createElement('TABLE');
    table.border = '1';
  
    var tableBody = document.createElement('TBODY');
    table.appendChild(tableBody);
    var tr = document.createElement('TR');
    tableBody.appendChild(tr);
    var td = document.createElement('TD');
    td.width = '200';
    td.appendChild(document.createTextNode("Time"));
    tr.appendChild(td);
    var td = document.createElement('TD');
    td.width = '200';
    td.appendChild(document.createTextNode("Temperature"));
    tr.appendChild(td);
    for (var j in Array.from(Array(24))) {
      var tr = document.createElement('TR');
      tableBody.appendChild(tr);
  
      for (i in data.hourly)  {
        var td = document.createElement('TD');
        td.width = '200';
        var x = data.hourly[i][j]
        td.appendChild(document.createTextNode(x));
        tr.appendChild(td);
      }
    }
    myTableDiv.appendChild(table);
  }
  
request.send()