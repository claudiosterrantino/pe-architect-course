const { Client } = require('pg');
require('dotenv').config();

module.exports.Client = async () => {

    console.log('  DB_USER: ' + process.env.DB_USER);
    console.log('DB_SERVER: ' + process.env.DB_SERVER);

    const client = new Client({
        user: process.env.DB_USER,
        host: process.env.DB_SERVER,
        database: "urls",
        password: process.env.DB_PASSWORD,
        port: 5432, // default port for PostgreSQL
    });
    await client.connect();
    return client;
};
