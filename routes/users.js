const express = require('express');
const router = express.Router();
const User = require('../model/user')

router.get('/', function(req, res, next) {
  User.find({})
      .then(r => res.status(200).json({ data: r }))
      .catch(e => res.status(500).json({ message: e.message }))
});

router.post('/add', (req, res, next) => {
  const { username, password, fullName, age } = req.body;

  User.create({ username, password, fullName, age })
      .then(r => res.status(200).json({ data: r }))
      .catch(e => res.status(500).json({ message: e.message }))
})

module.exports = router;
