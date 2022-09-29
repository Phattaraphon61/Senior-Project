const express = require('express')
const router = express.Router()
const ScbController = require('../controllers/scb/ScbController')

router.use('/scb', ScbController)


module.exports = router
