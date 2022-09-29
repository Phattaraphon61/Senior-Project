// import moment from 'moment';
// import constants from '../configs/constants'
const moment = require('moment')
const constants = require('../configs/constants')

const Decorator = (item) => {

  if (!item)
    return {}

  return {
    id: item._id,
    name: item.name,
    email: item.email,
    // createdAt: moment(user.createdAt).format(constants.DATETIME_FORMAT),
    // updatedAt: moment(user.updatedAt).format(constants.DATETIME_FORMAT),
  }
}

module.exports = { Decorator }
