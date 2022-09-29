const express = require('express')
const router = express.Router()
const DashbordController = require('../controllers/dashbord/DashbordController')

router.use('/dashbord', DashbordController)


module.exports = router
