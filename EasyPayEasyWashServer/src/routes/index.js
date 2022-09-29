const express = require('express')
const router = express.Router()
const test = require('./test')
const scb = require('./scb')
const user = require('./user')
const washing = require('./washing')
const withdraw = require('./withdraw')
const dashbords = require('./dashbord')
router.use(test)
router.use(scb)
router.use(user)
router.use(washing)
router.use(withdraw)
router.use(dashbords)

module.exports = router
