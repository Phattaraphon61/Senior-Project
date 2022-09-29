const dotenv = require('dotenv')

const { argv } = require('yargs')

dotenv.config({
  path: argv.env || '.env',
})

module.exports = {
  JWT_SECRET: 'secret',
  APP_NAME: process.env.APP_NAME,
  PORT: process.env.PORT || 5000,
  MQTT:process.env.MQTT_URL,
  LINETOKEN:process.env.LINETOKEN,
  SCBKEY:process.env.SCBKEY,
  SCBKEYSECRET:process.env.SCBKEYSECRET,
  SCBPPI:process.env.SCBPPI,

  

  ERROR: {
    NO_AUTH_CODE: 401,
  },

  DATETIME_FORMAT: 'DD-MM-yyyy HH:mm:ss',

}


