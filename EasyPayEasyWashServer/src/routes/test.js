// import express from 'express'
const express = require('express')

const router = express.Router()

// import UserController from '../controllers/users/UserController'
const TestController = require('../controllers/test/TestController')

router.use('/test', TestController)


module.exports = router
