Qt.include("QtQuick.LocalStorage");

function getDatabase() {
    return LocalStorage.openDatabaseSync("Settings", "1.0", "StorageDatabase", 100000);
}

function initialize() {
    var db = getDatabase();
    db.transaction(
                function(tx) {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS heros ('+
                                    'heroName TEXT,' +
                                    'rules INTEGER,' +
                                    'availableAp INTEGER,' +
                                    'usedAp INTEGER)' );
                });
}

function addHero(name, rules, availableAp, usedAp) {
    var db = getDatabase();
    var res = 0;
    db.transaction(function(tx) {
        var rs = tx.executeSql('INSERT INTO heros'+
                               ' VALUES (?,?,?,?);', [name, rules, availableAp, usedAp]);
        res = rs.rowsAffected > 0 ? rs.insertId:-2;
    });
    return res;
}

function saveHero(id, name, availableAp, usedAp) {
    var db = getDatabase();
    var res = false;
    db.transaction(function(tx) {
        var rs = tx.executeSql('UPDATE heros SET '+
                                   'heroName = ?,' +
                                   'availableAp = ?,' +
                                   'usedAp = ?'+
                               ' WHERE rowid = ?;', [name, availableAp, usedAp, id]);
        res = rs.rowsAffected > 0 ? true:false;
    });
    return res;
}

function loadHero(id) {
    var db = getDatabase();
    var res="";
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT * FROM heros WHERE rowid=?;', [id]);
        hero.heroName = rs.rows.item(0).heroName;
        hero.rules = rs.rows.item(0).rules;
        hero.availableAp = rs.rows.item(0).availableAp
        hero.usedAp = rs.rows.item(0).usedAp
    });
}

// This function is used to retrieve all heros from the database
function getHeros() {
    var db = getDatabase();
    var res = 0;
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT rowid, heroName, availableAp, usedAp, rules FROM heros');
        res = rs.rows.length
        for (var i = 0; i < rs.rows.length; i++) {
            heroModel.append({"heroName": rs.rows.item(i).heroName, "ap": rs.rows.item(i).availableAp, "usedAp": rs.rows.item(i).usedAp, "rules": rs.rows.item(i).rules, "uid": rs.rows.item(i).rowid})
        }
    });
    return res
}

function deleteHero(index){
    var db = getDatabase();

        db.transaction(function(tx) {
            var rs = tx.executeSql('DELETE FROM heros WHERE rowid=?;', [index]);
        });

}
