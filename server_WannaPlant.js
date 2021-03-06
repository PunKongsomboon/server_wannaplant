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
                                                                        const sql = "UPDATE user SET role = 2 WHERE user.user_id = ?";
                                                                        con.query(sql, [parseInt(iduser[0]['user_id'])], function (err, result) {
                                                                            if (err) {
                                                                                console.log(err);
                                                                                res.status(500).send("DATABASE ERROR");
                                                                            } else {
                                                                                res.send();
                                                                            }
                                                                        })

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
    const sql = "SELECT * FROM user WHERE user.username = ?";
    con.query(sql, [username], function (err, result) {
        if (err) {
            console.log(err);
            res.status(500).send("DATABASE ERROR");
        } else {

            if (result.length > 1) {
                res.status(404).send("Username wrong");
            } else if (result.length == 0) {
                res.status(404).send("No account");
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

app.post('/resetpass', function (req, res) {
    const { username, new_pass, check_role } = req.body;
    if (check_role == "guest") {
        const sql = "UPDATE user SET user.password = ? WHERE user.username = ?";
        bcrypt.hash(new_pass, 10, function (err, hash) {
            if (err) {
                console.log(err);
                res.status(500).send("HASH PASSWORD ERROR");
            } else {
                con.query(sql, [hash, username], function (err, result) {
                    if (err) {
                        console.log(err);
                        res.status(500).send("DATABASE ERROR");
                    } else {
                        if (result.affectedRows != 1) {
                            console.log(err);
                            res.status(500).send("UPDATE ERROR");
                        } else {
                            res.send();
                        }

                    }
                });
            }
        })

    } else {
        res.status(404).send("Not allowed to access server");
    }

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
        const sql = "SELECT picture.pic_name , user.user_id , user.province , user.name, lands.land_id , lands.land_area , lands.land_unit , lands.land_description , plants.plants_name , plants.plants_price , activities.rating , COUNT(activities.planter) AS planted FROM picture JOIN lands ON picture.land_id = lands.land_id JOIN plants ON plants.land_id = lands.land_id JOIN user ON user.user_id = lands.user_id LEFT OUTER JOIN activities ON activities.planter = user.user_id WHERE lands.land_id = ? GROUP BY plants.plants_name";
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

app.post('/countplanted', function (req, res) {
    const { land_id, check_role } = req.body;
    if (check_role == "user") {
        const sql = "SELECT COUNT(activities.land_id) AS planted FROM activities WHERE activities.land_id = ?";
        con.query(sql, [land_id], function (err, result) {
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
    const { user_id, check_role } = req.body;
    if (check_role == "user") {
        const sql = "SELECT picture.pic_name FROM picture JOIN lands ON lands.land_id = picture.land_id JOIN user ON user.user_id = lands.user_id WHERE user.user_id = ?";
        con.query(sql, [parseInt(user_id)], function (err, result) {
            if (err) {
                console.log(err);
                console.log("DATABASE ERROR");
            } else {
                res.send(result);
            }
        })
    } else {
        res.status(404).send("Not allowed to access server");
    }

})

app.post('/datafavland', function (req, res) {
    const { user_id, land_id, check_role } = req.body;
    if (check_role == "user") {
        const sql = "SELECT favorites.land_id FROM favorites WHERE favorites.user_id = ?";
        con.query(sql, [user_id], function (err, result) {
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

app.post('/addfavland', function (req, res) {
    const { user_id, land_id, check_role } = req.body;
    if (check_role == "user") {
        const sql = "INSERT INTO favorites (user_id, land_id) VALUES (?,?)";
        con.query(sql, [user_id, land_id], function (err, result) {
            if (err) {
                console.log(err);
                res.status(500).send("DATABASE ERROR");
            } else {
                if (result.affectedRows != 1) {
                    res.status(500).send("INSERT ERROR");
                } else {
                    res.send();
                }
            }
        })
    } else {
        res.status(404).send("Not allowed to access server");
    }


})

app.post('/defavland', function (req, res) {
    const { user_id, land_id, check_role } = req.body;
    if (check_role == "user") {
        const sql = "DELETE FROM favorites WHERE favorites.user_id = ? AND favorites.land_id = ?";
        con.query(sql, [user_id, land_id], function (err, result) {
            if (err) {
                console.log(err);
                res.status(500).send("DATABASE ERROR");
            } else {
                if (result.affectedRows != 1) {
                    res.status(500).send("DELETE ERROR");
                } else {
                    res.send();
                }
            }
        })
    } else {
        res.status(404).send("Not allowed to access server");
    }
})

app.post('/favbtn', function (req, res) {
    const { user_id, land_id, check_role } = req.body;
    if (check_role == "user") {
        const sql = "SELECT * FROM favorites WHERE favorites.user_id = ? AND favorites.land_id = ?";
        con.query(sql, [user_id, land_id], function (err, result) {
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

app.post('/datafavorite', function (req, res) {
    const { user_id, land_id, check_role } = req.body;
    if (check_role == "user") {
        const sql = "SELECT picture.pic_name , lands.land_id , lands.land_area , lands.land_unit , lands.user_id , plants.plants_name , user.province , activities.rating FROM picture JOIN lands ON lands.land_id = picture.land_id JOIN plants ON plants.land_id = lands.land_id JOIN favorites ON favorites.land_id = lands.land_id JOIN user ON user.user_id = favorites.user_id LEFT OUTER JOIN activities ON lands.land_id = activities.land_id WHERE favorites.user_id = ? GROUP BY plants.plants_id";
        con.query(sql, [user_id, land_id], function (err, result) {
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

app.post('/addactivity', function (req, res) {
    const { dataincart, check_role } = req.body;
    let datacart = JSON.parse(dataincart);
    // console.log(datacart);
    var time = new Date();
    var date = time.getDate() + '/' + (time.getMonth() + 1) + '/' + time.getFullYear();
    // console.log(date);
    if (check_role == "user") {
        const sql = "INSERT INTO activities(tracking, status , rating, datetime, plants_name, total_price, customer, planter, land_id) VALUES (?,?,?,?,?,?,?,?,?)";
        for (let i = 0; i < datacart.length; i++) {
            con.query(sql, [0, 1, 0, String(date), datacart[i]['plants_name'], datacart[i]['total_money'], datacart[i]['customer_id'], datacart[i]['planter_id'], datacart[i]['land_id']], function (err, result) {
                if (err) {
                    console.log(err);
                    res.status(500).send("DATABASE ERROR");
                } else {
                    if (result.affectedRows != 1) {
                        res.status(500).send("INSERT ERROR");
                    } else {
                        if (i + 1 == datacart.length) {
                            res.send();
                        }

                    }

                }
            })
        }


        // res.send();
    } else {
        res.status(404).send("Not allowed to access server");
    }
})

app.post('/tracking', function (req, res) {
    const { user_id, check_role } = req.body;
    if (check_role == "user") {
        const sql = "SELECT * FROM activities WHERE activities.status != 0 AND activities.tracking < 6 ";
        con.query(sql, [user_id, user_id], function (err, result) {
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

app.post('/getnameuser', function (req, res) {
    const { user_id, check_role } = req.body;
    if (check_role == "user") {
        const sql = "SELECT user.name FROM user WHERE user.user_id = ?";
        con.query(sql, [user_id], function (err, result) {
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

app.post('/updatetracking', function (req, res) {
    const { activity_id, tracking, datetime, check_role } = req.body
    if (check_role == "user") {
        var time = new Date();
        var date = time.getDate() + '/' + (time.getMonth() + 1) + '/' + time.getFullYear();
        if (tracking == 1) {
            const sql = "UPDATE activities SET tracking = ? , date_confirm = ? WHERE activities.activity_id = ?";
            con.query(sql, [tracking, String(date), activity_id], function (err, result) {
                if (err) {
                    console.log(err);
                    res.status(500).send("DATABASE ERROR");
                } else {
                    if (result.affectedRows != 1) {
                        console.log(err);
                        res.status(500).send("UPDATE ERROR");
                    } else {
                        res.send();
                    }
                }
            })
        } else if (tracking == 2) {
            const sql = "UPDATE activities SET tracking = ? , date_prepare = ? WHERE activities.activity_id = ?";
            con.query(sql, [tracking, String(date), activity_id], function (err, result) {
                if (err) {
                    console.log(err);
                    res.status(500).send("DATABASE ERROR");
                } else {
                    if (result.affectedRows != 1) {
                        console.log(err);
                        res.status(500).send("UPDATE ERROR");
                    } else {
                        res.send();
                    }
                }
            })
        } else if (tracking == 3) {
            const sql = "UPDATE activities SET tracking = ? , date_planting = ? WHERE activities.activity_id = ?";
            con.query(sql, [tracking, String(date), activity_id], function (err, result) {
                if (err) {
                    console.log(err);
                    res.status(500).send("DATABASE ERROR");
                } else {
                    if (result.affectedRows != 1) {
                        console.log(err);
                        res.status(500).send("UPDATE ERROR");
                    } else {
                        res.send();
                    }
                }
            })
        } else if (tracking == 4) {
            const sql = "UPDATE activities SET tracking = ? , date_harvest = ? WHERE activities.activity_id = ?";
            con.query(sql, [tracking, String(date), activity_id], function (err, result) {
                if (err) {
                    console.log(err);
                    res.status(500).send("DATABASE ERROR");
                } else {
                    if (result.affectedRows != 1) {
                        console.log(err);
                        res.status(500).send("UPDATE ERROR");
                    } else {
                        res.send();
                    }
                }
            })
        } else if (tracking == 5) {
            const sql = "UPDATE activities SET tracking = ? , date_delivery = ? WHERE activities.activity_id = ?";
            con.query(sql, [tracking, String(date), activity_id], function (err, result) {
                if (err) {
                    console.log(err);
                    res.status(500).send("DATABASE ERROR");
                } else {
                    if (result.affectedRows != 1) {
                        console.log(err);
                        res.status(500).send("UPDATE ERROR");
                    } else {
                        res.send();
                    }
                }
            })
        } else if (tracking == 6) {
            const sql = "UPDATE activities SET tracking = ? , status = 0 , date_success = ? WHERE activities.activity_id = ?";
            con.query(sql, [tracking, String(date), activity_id], function (err, result) {
                if (err) {
                    console.log(err);
                    res.status(500).send("DATABASE ERROR");
                } else {
                    if (result.affectedRows != 1) {
                        console.log(err);
                        res.status(500).send("UPDATE ERROR");
                    } else {
                        res.send();
                    }
                }
            })
        } else {
            res.status(404).send("tracking number wrong");
        }

    } else {
        res.status(404).send("Not allowed to access server");
    }
})

app.post('/cancelordertracking', function (req, res) {
    const { activity_id, check_role } = req.body;
    if (check_role == "user") {
        const sql = "UPDATE activities SET status = ? WHERE activities.activity_id = ?";
        con.query(sql, [0, activity_id], function (err, result) {
            if (err) {
                console.log(err);
                res.status(500).send("DATABASE ERROR");
            } else {
                if (result.affectedRows != 1) {
                    console.log(err);
                    res.status(500).send("UPDATE ERROR");
                } else {
                    res.send();
                }
            }
        });
    } else {
        res.status(404).send("Not allowed to access server");
    }

})

app.post('/updaterating', function (req, res) {
    const { activity_id, rating, check_role } = req.body;
    if (check_role == "user") {
        const sql = "UPDATE activities SET rating = ? WHERE activities.activity_id = ?";
        con.query(sql, [rating, activity_id], function (err, result) {
            if (err) {
                console.log(err);
                res.status(500).send("DATABASE ERROR");
            } else {
                console.log();
                if (result.affectedRows != 1) {
                    console.log(err);
                    res.status(500).send("UPDATE ERROR");
                } else {
                    res.send();
                }

            }
        });
    } else {
        res.status(404).send("Not allowed to access server");
    }

})


app.post('/getdataactivity', function (req, res) {
    const { user_id, check_role } = req.body;
    if (check_role == "user") {
        const sql = "SELECT picture.pic_name , activities.activity_id , activities.plants_name, activities.total_price , activities.customer , activities.planter , activities.status , activities.tracking , activities.rating , activities.datetime , activities.date_confirm , activities.date_prepare , activities.date_planting , activities.date_harvest , activities.date_delivery , activities.date_success , activities.land_id FROM activities JOIN lands ON lands.land_id = activities.land_id JOIN picture ON lands.land_id = picture.land_id WHERE activities.customer = ? OR activities.planter = ? AND activities.status = 0 GROUP BY activities.activity_id";
        con.query(sql, [user_id, user_id], function (err, result) {
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

app.post('/getaddressdetailact', function (req, res) {
    const { user_id, check_role } = req.body;
    if (check_role == "user") {
        const sql = "SELECT user.address , lands.land_area , lands.land_unit FROM user LEFT OUTER JOIN lands ON lands.user_id = user.user_id WHERE user.user_id = ?";
        con.query(sql, [user_id], function (err, result) {
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

app.post('/saveeditacc', function (req, res) {
    const { user_id, name, phonenumber, address, promptpay, check_role } = req.body;
    if (check_role == "user") {
        const sql = "UPDATE user SET user.name = ?, user.phonenumber = ?, user.address = ?, user.promptpay = ? WHERE user.user_id = ?";
        con.query(sql, [name, phonenumber, address, promptpay, user_id], function (err, result) {
            if (err) {
                console.log(err);
                res.status(500).send("DATABASE ERROR");
            } else {
                if (result.affectedRows != 1) {
                    console.log(err);
                    res.status(500).send("UPDATE ERROR");
                } else {
                    res.send();
                }

            }
        })
    } else {
        res.status(404).send("Not allowed to access server");
    }
})


app.post('/countratingandplanted', function (req, res) {
    const { user_id, check_role } = req.body;
    if (check_role == "user") {
        const sql = "SELECT SUM(activities.rating) / COUNT(activities.planter) AS rating , COUNT(activities.planter) AS planted FROM activities WHERE activities.planter = ?";
        con.query(sql, [user_id], function (err, result) {
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


app.listen(3000, function () {
    console.log('Server starts at port 3000');
})