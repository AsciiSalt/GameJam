# GameJam
Description: A utility plugin that helps keep track of time.

Example of express server code to communicate with plugin.
```js
const express = require('express');

const app = express();
// https://www.epochconverter.com/
const startTime = 0 // 1623883500
const concludeDate = 0 // 1624229040
const theme = "---" // zombies
const start = "---" // (new Date(startTime*1000)).toUTCString()
const end = "---" // (new Date(concludeDate*1000)).toUTCString()
const prize = "---" // 10,000 robux
const objective = `Theme: <font color="rgb(135, 187, 235)">${theme}</font>\n`
                  + `Start Date: <font color="rgb(226, 119, 119)">${start}</font> \n`
                  + `End Date: <font color="rgb(226, 119, 119)">${end}</font> \n`
                  + `Prize: <font color="rgb(226, 200, 119)">${prize}</font>\n\n`
                  + `Check discord for more information.`

app.get('/', (request, response) => {
  response.status(200).send(`<a href="https://discord.gg/DhArKjf9wZ" target="#">discord</a>`)
})

app.post('/startDate', (request, response) => {
  response.status(200).send(`${startTime}`)
})

app.post('/concludeDate', (request, response) => {
  response.status(200).send(`${concludeDate}`)
})

app.post('/objective', (request, response) => {
  response.status(200).send(objective);
})

app.listen(3000, () => {
  console.log('server started');
});
```