
const express = require('express')
const router = express.Router()
const WithdrawController = require('../controllers/withdraw/WithdrawController')

router.use('/withdraw', WithdrawController)


module.exports = router
