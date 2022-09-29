const WashingModel = require('../../models/WashingModel')
const line = require('@line/bot-sdk');
import constants from '../../configs/constants'
const client = new line.Client({
    channelAccessToken: constants.LINETOKEN
});

const linenoti = async (item) => {
    const message = {
        type: 'text',
        text: 'ซักสำเร็จแล้วกรุณาไปรับเสื้อผ้าของท่านด้วย'
    };
  let  washingModel = await WashingModel.findOneAndUpdate({ washingid: item },
        {
            $set: { noti: [] },
        });
    washingModel.noti.map((tt) => {
        console.log(tt.lineid)
        client.pushMessage(tt.lineid, message)
            .then((res) => {
                console.log(res)
            })
            .catch((err) => {
                console.log(err)
            });
    })
}

module.exports = { linenoti }