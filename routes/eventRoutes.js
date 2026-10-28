// Mengimpor library Express untuk mengelola routing
const express = require('express');

// Membuat instance router modular dari Express
const router = express.Router();

// Mengimpor controller event yang berisi logika manipulasi data database
const eventController = require('../controllers/eventController');

// GET semua data "event desa"
router.get('/', eventController.getAllEvent)

// GET data "event desa" berdasaarkan id
router.get('/:id', eventController.getEventById)  

// POST data "event desa" baru
router.post('/', eventController.createEvent)

// PUT UPDATE data "event desa"
router.put('/:id', eventController.updateEvent)

// DELETE data "event desa"
router.delete('/:id', eventController.deleteEvent)

// Mengekspor router agar bisa digunakan di server.js
module.exports = router;