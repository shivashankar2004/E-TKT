
const data = {};


function createKey(location1, location2) {
    return `${location1}_${location2}`;
}

function setAmount(location1, location2, amount) {
    const key = createKey(location1, location2);
    data[key] = amount;
}

function getAmount(location1, location2) {
    const key = createKey(location1, location2);
    return data[key];
}


setAmount("peel", "nava", 5);
setAmount("psg", "gandhi", 13);


module.exports={loc:data}
; // { NewYork_LosAngeles: 500, SanFrancisco_Seattle: 300 }
