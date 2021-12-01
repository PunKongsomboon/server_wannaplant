const express = require('express');
require('dotenv').config();
const bcrypt = require('bcrypt');
const mysql = require('mysql');
const config = require('./dbconfig.js');
const upload = require('./uploadconfig.js');
const fs = require('fs');
const con = require('./dbconfig.js');
const path = require('path');

const app = express();

app.use(express.static(path.join(__dirname, "public/upload/")))
app.use(express.json());
app.use(express.urlencoded({ extended: true }));


app.get('/', function (req, res) {
    const sql = "SELECT * "
    res.send('test');
})

app.post('/register', function (req, res) {
    const { name, username, password, phonenumber, address, province, protmptpay, identify, role, check_role } = req.body;
    if (check_role == "guest") {
        bcrypt.hash(password, 10, function (err, hash) {
            if (err) {
                console.log(err);
                res.status(500).send("hash error");
            } else {
                const sql = "INSERT INTO user (name , username , password , phonenumber , address , province , promptpay , identify , role) VALUES (?,?,?,?,?,?,?,?,?)";
                con.query(sql, [name, username, hash, phonenumber, address, province, protmptpay, parseInt(identify), parseInt(role)], function (err, result) {
                    if (err) {
                        console.log(err);
                        res.status(500).send("Database error");
                    } else {
                        if (result.affectedRows != 1) {
                            console.log("INSERT ERROR");
                            res.status(500).send("INSERT ERROR");
                        } else {
                            const sql = "SELECT * FROM user LEFT OUTER JOIN activities ON activities.customer = user.user_id WHERE user.username = ?"
                            con.query(sql, [username], function (err, result) {
                                if (err) {
                                    console.log(err);
                                    res.status(500).send("DATABASE ERROR");
                                } else {
                                    if (result.length != 1) {
                                        res.status(500).send("QUERY ERROR");
                                    } else {
                                        res.send(result);
                                    }

                                }

                            })
                        }
                    }
                })

            }
        });

    } else {
        res.status(404).send("Not allowed to access server");
    }

})

app.post('/registerland', function (req, res) {

    upload(req, res, function (err) {
        if (err) {
            console.log(err);
            res.status(500).send("Upload error");
        } else {
            const filename = req.files;
            const { size, val, descrip, user_id, entries, check_role } = req.body;


            if (check_role == "guest") {
                let iduser = JSON.parse(user_id);
                const sql = "INSERT INTO lands (land_area, land_unit, land_description, user_id) VALUES (?,?,?,?)";
                con.query(sql, [parseInt(size), val, descrip, parseInt(iduser[0]['user_id'])], function (err, result) {
                    if (err) {
                        console.log(err);
                        res.status(500).send("DATABASE ERROR");
                    } else {
                        if (result.affectedRows != 1) {
                            console.log("INSERT ERROR")
                            res.status(500).send("INSERT ERROR");
                        } else {
                            const sql = "SELECT lands.land_id FROM lands WHERE lands.user_id = ?";
                            con.query(sql, [parseInt(iduser[0]['user_id'])], function (err, result) {
                                if (err) {
                                    console.log(err);
                                    res.status(500).send("DATABASE ERROR");
                                } else {
                                    const sql = "INSERT INTO plants (plants_name, plants_price, land_id) VALUES (?,?,?)";
                                    let plantArray = JSON.parse(entries);
                                    let idland = result[0]['land_id'];
                                    for (let i = 0; i < plantArray.length; i++) {
                                        con.query(sql, [plantArray[i]['plantname'], parseInt(plantArray[i]['price']), parseInt(result[0]['land_id'])], function (err, result) {
                                            if (err) {
                                                console.log("err");
                                                console.log(err);
                                                i = plantArray.length;
                                                res.status(500).send("DATABASE ERROR");
                                            } else {
                                                if (i + 1 == plantArray.length) {
                                                    for (let n = 0; n < filename.length; n++) {
                                                        const sql = "INSERT INTO picture (pic_name, land_id) VALUES (?,?)";
                                                        con.query(sql, [filename[n].filename, parseInt(idland)], function (err, result) {
                                                            if (err) {
                                                                console.log(err);
                                                                res.status(500).send("DATABASE ERROR");
                                                            } else {

                                                                if (err) {
                                                                    console.log(err);
                                                                    n = filename.length;
                                                                    res.status(500).send("INSERT ERROR");
                                                                } else {

                                                                    if (n + 1 == filename.length) {
                                                                        res.send();
                                                                    }
                                                                }
                                                            }
                                                        })
                                                    }


                                                }
                                            }
                                        })
                                    }





                                }
                            })

                        }
                    }
                })


            } else {
                res.status(404).send("Not allowed to access server");
            }


        }
    })

})


app.post('/login', function (req, res) {
    const { username, password } = req.body;
    const sql = "SELECT * FROM user LEFT OUTER JOIN activities ON activities.customer = user.user_id WHERE user.username = ?";
    con.query(sql, [username], function (err, result) {
        if (err) {
            console.log(err);
            res.status(500).send("DATABASE ERROR");
        } else {

            if (result.length != 1) {
                res.status(400).send("Username wrong");
            } else {
                bcrypt.compare(password, result[0].password, function (err, resp) {
                    if (err) {
                        console.log(err);
                        res.status(500).send("Compare error");
                    } else if (resp) {
                        res.send(result);
                    } else {
                        res.status(401).send("Password wrong");
                    }
                })
            }
        }
    })

})

app.post('/allland', function (req, res) {
    const { user_check } = req.body;
    if (user_check == "user") {
        const sql = "SELECT picture.pic_name , lands.land_id , lands.land_area , lands.land_unit , plants.plants_name , user.user_id , user.identify , user.role , user.address, user.province , activities.rating FROM picture JOIN lands ON picture.land_id = lands.land_id JOIN plants ON plants.land_id = lands.land_id JOIN user ON lands.user_id = user.user_id LEFT OUTER JOIN activities ON user.user_id = activities.planter GROUP BY plants.plants_id";
        con.query(sql, function (err, result) {
            if (err) {
                console.log(err);
                res.status(500).send("DATABASE ERROR");
            } else {
                res.send(result);
            }
        })
    } else {
        res.status(404).send("Not allowed to access server");
    }

})

app.post('/infoland', function (req, res) {
    const { idland, user_check } = req.body;
    if (user_check == "user") {
        const sql = "SELECT picture.pic_name , user.user_id , user.province , user.name , lands.land_area , lands.land_unit , lands.land_description , plants.plants_name , plants.plants_price , activities.rating , COUNT(activities.planter) AS planted FROM picture JOIN lands ON picture.land_id = lands.land_id JOIN plants ON plants.land_id = lands.land_id JOIN user ON user.user_id = lands.user_id LEFT OUTER JOIN activities ON activities.planter = user.user_id WHERE lands.land_id = ? GROUP BY plants.plants_name";
        con.query(sql, [parseInt(idland)], function (err, result) {
            if (err) {
                console.log(err);
                res.status(500).send("DATABASE ERROR");
            } else {
                res.send(result);
            }
        });
    } else {
        res.status(404).send("Not allowed to access server");
    }

})

app.post('/infolandpic', function (req, res) {
    const { idland, user_check } = req.body;
    if (user_check == "user") {
        const sql = "SELECT picture.pic_name FROM picture WHERE picture.land_id = ?";
        con.query(sql, [parseInt(idland)], function (err, result) {
            if (err) {
                console.log(err);
                res.status(500).send("DATABASE ERROR");
            } else {
                res.send(result);
            }
        })
    } else {
        res.status(404).send("Not allowed to access server");
    }
})


app.post('/profilepic', function (req, res) {
    const { user_id } = req.body;
    const sql = "SELECT picture.pic_name FROM picture JOIN lands ON lands.land_id = picture.land_id JOIN user ON user.user_id = lands.user_id WHERE user.user_id = ?";
    con.query(sql, [parseInt(user_id)], function (err, result) {
        if (err) {
            console.log(err);
            console.log("DATABASE ERROR");
        } else {
            res.send(result);
        }
    })
})


app.listen(3000, function () {
    console.log('Server starts at port 3000');
})