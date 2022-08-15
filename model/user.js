const mongoose = require('mongoose')

const userSchema = mongoose.Schema(
    {
      username: {
        type: String
      },
      password: {
        type: String
      },
      fullName: {
        type: String
      },
      age: {
        type: Number
      }
    }
)

const User = mongoose.model('user', userSchema);
module.exports = User;
