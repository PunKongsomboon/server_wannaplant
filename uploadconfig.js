const multer = require('multer');
const option = multer.diskStorage({
    destination: function (req, file, callback) {
        callback(null, "public/upload/");
    },
    filename: function (req, file, callback) {
        callback(null , Date.now() + "_" + file.originalname);
    }
});

const upload = multer({ storage: option }).array("fileupload");
module.exports = upload;