
const express = require('express')
const router = express.Router()
const WashingController = require('../controllers/washing/WashingController')

router.use('/washing', WashingController)


module.exports = router
