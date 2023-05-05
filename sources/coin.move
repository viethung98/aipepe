// Copyright (c) Mysten Labs, Inc.
// SPDX-License-Identifier: Apache-2.0

module aipepe::aipepe {
    use std::option;
    use sui::coin::{Self, Coin, TreasuryCap};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use sui::url;


    /// Name of the coin. By convention, this type has the same name as its parent module
    /// and has no fields. The full type of the coin defined by this module will be `COIN<MANAGED>`.
    struct AIPEPE has drop {}

    // For when empty vector is supplied into join function.
    const ENoCoins: u64 = 0;
    const MINT_AMOUNT: u64 = 100000000000000000;

    /// Register the managed currency to acquire its `TreasuryCap`. Because
    /// this is a module initializer, it ensures the currency only gets
    /// registered once.
    fun init(witness: AIPEPE, ctx: &mut TxContext) {
        // Get a treasury cap for the coin and give it to the transaction sender
        let owner = tx_context::sender(ctx);
        let (treasury_cap, metadata) = coin::create_currency<AIPEPE>(witness, 9, b"AIPEPE", b"AI PEPE", b"",  option::some(url::new_unsafe_from_bytes(b"https://sui-pepe.xyz/_next/static/media/logo.6e0d8f53.png")), ctx);
        transfer::public_freeze_object(metadata);
        mint(&mut treasury_cap, MINT_AMOUNT, owner, ctx);
        transfer::public_freeze_object(treasury_cap);
    }

    /// Manager can mint new coins
    fun mint(
        treasury_cap: &mut TreasuryCap<AIPEPE>, amount: u64, recipient: address, ctx: &mut TxContext
    ) {
        coin::mint_and_transfer(treasury_cap, amount, recipient, ctx)
    }

    /// Manager can burn coins
    public entry fun burn(treasury_cap: &mut TreasuryCap<AIPEPE>, coin: Coin<AIPEPE>) {
        coin::burn(treasury_cap, coin);
    }

    // public entry fun transfer<T>(coins: vector<coin::Coin<AIPEPE>>, amount: u64, recipient: address, ctx: &mut TxContext) {
    //     assert!(vector::length(&coins) > 0, ENoCoins);
    //     let coin = vector::pop_back(&mut coins);
    //     pay::join_vec(&mut coin, coins);
    //     pay::split_and_transfer<AIPEPE>(&mut coin, amount, recipient, ctx);
    //     transfer::public_transfer(coin, tx_context::sender(ctx))
    // }

    // #[test_only]
    // /// Wrapper of module initializer for testing
    // public fun test_init(ctx: &mut TxContext) {
    //     init(AIPEPE {}, ctx)
    // }
}