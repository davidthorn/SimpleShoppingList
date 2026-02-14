//
//  SampleData.swift
//  SimpleShoppingList
//
//  Created by David Thorn on 14.02.2026.
//

import Foundation

public enum SampleData {
    public static let defaultLists: [ShoppingList] = {
        let groceriesListID = UUID()
        let produceListID = UUID()
        let householdListID = UUID()
        let babyListID = UUID()
        let partyListID = UUID()

        let groceries = ShoppingList(
            id: groceriesListID,
            name: "Weekly Groceries",
            items: [
                ShoppingItem(listID: groceriesListID, name: "Bread", price: 2.50, isCollected: true),
                ShoppingItem(listID: groceriesListID, name: "Milk", price: 1.95),
                ShoppingItem(listID: groceriesListID, name: "Eggs", price: 3.20),
                ShoppingItem(listID: groceriesListID, name: "Cheddar Cheese", price: 4.70),
                ShoppingItem(listID: groceriesListID, name: "Greek Yogurt", price: 5.10),
                ShoppingItem(listID: groceriesListID, name: "Pasta", price: 2.30),
                ShoppingItem(listID: groceriesListID, name: "Tomato Sauce", price: 2.80),
                ShoppingItem(listID: groceriesListID, name: "Chicken Breast", price: 9.90),
                ShoppingItem(listID: groceriesListID, name: "Rice", price: 4.25),
                ShoppingItem(listID: groceriesListID, name: "Coffee Beans", price: 11.50, isCollected: true)
            ]
        )

        let produce = ShoppingList(
            id: produceListID,
            name: "Fresh Produce",
            items: [
                ShoppingItem(listID: produceListID, name: "Bananas", price: 1.80),
                ShoppingItem(listID: produceListID, name: "Apples", price: 3.40),
                ShoppingItem(listID: produceListID, name: "Spinach", price: 2.60, isCollected: true),
                ShoppingItem(listID: produceListID, name: "Avocados", price: 5.00),
                ShoppingItem(listID: produceListID, name: "Blueberries", price: 4.95),
                ShoppingItem(listID: produceListID, name: "Carrots", price: 2.20),
                ShoppingItem(listID: produceListID, name: "Cucumbers", price: 2.10),
                ShoppingItem(listID: produceListID, name: "Sweet Potatoes", price: 3.70),
                ShoppingItem(listID: produceListID, name: "Onions", price: 2.45),
                ShoppingItem(listID: produceListID, name: "Lemons", price: 2.00, isCollected: true)
            ]
        )

        let household = ShoppingList(
            id: householdListID,
            name: "Home Supplies",
            items: [
                ShoppingItem(listID: householdListID, name: "Dish Soap", price: 4.10, isCollected: true),
                ShoppingItem(listID: householdListID, name: "Paper Towels", price: 6.40),
                ShoppingItem(listID: householdListID, name: "Laundry Detergent", price: 12.50),
                ShoppingItem(listID: householdListID, name: "Toilet Paper", price: 9.80),
                ShoppingItem(listID: householdListID, name: "Surface Cleaner", price: 5.25),
                ShoppingItem(listID: householdListID, name: "Trash Bags", price: 8.30),
                ShoppingItem(listID: householdListID, name: "Hand Soap", price: 3.90),
                ShoppingItem(listID: householdListID, name: "Sponges", price: 2.70),
                ShoppingItem(listID: householdListID, name: "Light Bulbs", price: 7.60),
                ShoppingItem(listID: householdListID, name: "Batteries", price: 6.95)
            ]
        )

        let baby = ShoppingList(
            id: babyListID,
            name: "Baby Essentials",
            items: [
                ShoppingItem(listID: babyListID, name: "Diapers", price: 18.90),
                ShoppingItem(listID: babyListID, name: "Baby Wipes", price: 7.20, isCollected: true),
                ShoppingItem(listID: babyListID, name: "Formula", price: 24.50),
                ShoppingItem(listID: babyListID, name: "Baby Lotion", price: 6.70),
                ShoppingItem(listID: babyListID, name: "Baby Shampoo", price: 5.95),
                ShoppingItem(listID: babyListID, name: "Teething Gel", price: 4.80),
                ShoppingItem(listID: babyListID, name: "Cotton Pads", price: 3.40),
                ShoppingItem(listID: babyListID, name: "Snack Puffs", price: 3.10),
                ShoppingItem(listID: babyListID, name: "Sippy Cups", price: 9.40),
                ShoppingItem(listID: babyListID, name: "Bib Set", price: 8.15)
            ]
        )

        let party = ShoppingList(
            id: partyListID,
            name: "Party Night",
            items: [
                ShoppingItem(listID: partyListID, name: "Sparkling Water", price: 4.60),
                ShoppingItem(listID: partyListID, name: "Juice Mix", price: 3.25),
                ShoppingItem(listID: partyListID, name: "Cheese Platter", price: 10.80),
                ShoppingItem(listID: partyListID, name: "Crackers", price: 3.40),
                ShoppingItem(listID: partyListID, name: "Olives", price: 4.20),
                ShoppingItem(listID: partyListID, name: "Cupcakes", price: 9.70, isCollected: true),
                ShoppingItem(listID: partyListID, name: "Balloons", price: 5.30),
                ShoppingItem(listID: partyListID, name: "Candles", price: 2.90),
                ShoppingItem(listID: partyListID, name: "Napkins", price: 2.60),
                ShoppingItem(listID: partyListID, name: "Ice Cubes", price: 1.50)
            ]
        )

        return [groceries, produce, household, baby, party]
    }()
}
