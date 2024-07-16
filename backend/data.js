class MultiKeyHashMap {
    constructor() {
        this.data = {};
    }

    // Helper function to create a composite key
    createKey(location1, location2) {
        return `${location1}_${location2}`;
    }


    setAmount(location1, location2, amount) {
        const key = this.createKey(location1, location2);
        this.data[key] = amount;
    }

    getAmount(location1, location2) {
        const key = this.createKey(location1, location2);
        return this.data[key];
    }
}

const travelCosts = new MultiKeyHashMap();
travelCosts.setAmount("hopes", "singanallur", 10);
travelCosts.setAmount("gandhipuram", "peelamedu", 20);

module.exports=travelCosts

