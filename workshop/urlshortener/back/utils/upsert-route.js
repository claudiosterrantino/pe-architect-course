const { Client } = require('./getClient');

module.exports.upsertRoute = async(route, url) => {
  const client = await Client();
  let upsertCmd = `INSERT INTO routes (route, url) VALUES ('${route}','${url}') ON CONFLICT (route) DO UPDATE SET url = '${url}';`

  console.log("upsertCmd: " + upsertCmd);

  let insertRow = await client.query(upsertCmd);
  await client.end();
};