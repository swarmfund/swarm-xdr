// Copyright 2015 Stellar Development Foundation and contributors. Licensed
// under the Apache License, Version 2.0. See the COPYING file at the root
// of this distribution or at http://www.apache.org/licenses/LICENSE-2.0

%#include "xdr/Stellar-ledger-entries.h"

namespace stellar
{

/* Creates, updates or deletes an offer

Threshold: med

Result: ManageOfferResult

*/
struct ManageOfferOp
{
    BalanceID baseBalance; // balance for base asset
	BalanceID quoteBalance; // balance for quote asset
	bool isBuy;
    int64 amount; // if set to 0, delete the offer
    int64 price;  // price of base asset in terms of quote

    int64 fee;

    // 0=create a new offer, otherwise edit an existing offer
    uint64 offerID;
	uint64 orderBookID;
	// reserved for future use
    union switch (LedgerVersion v)
    {
    case EMPTY_VERSION:
        void;
    }
    ext;
};

/******* ManageOffer Result ********/

enum ManageOfferResultCode
{
    // codes considered as "success" for the operation
    SUCCESS = 0,

    // codes considered as "failure" for the operation
    MALFORMED = -1,
    PAIR_NOT_TRADED = -2,
    BALANCE_NOT_FOUND = -3, // base or quote asset balance doesn't exist
    UNDERFUNDED = -4, // has not enough asset that's supposed to be sold
    CROSS_SELF = -5, // the account creating this offer would immediately cross itself
	OFFER_OVERFLOW = -6, // fee or quote amount overflows UINT64_MAX
	ASSET_PAIR_NOT_TRADABLE = -7, // it's not allowed to trade this asset pair
	PHYSICAL_PRICE_RESTRICTION = -8, // offer price violates physical price restriction
	CURRENT_PRICE_RESTRICTION = -9,
    OFFER_NOT_FOUND = -10, // offer doesn't exist
    INVALID_PERCENT_FEE = -11,
	INSUFFICIENT_PRICE = -12,
	ORDER_BOOK_DOES_NOT_EXIST = -13, // specified order book does not exist
	SALE_IS_NOT_STARTED_YET = -14, // sale is not started yet
	SALE_ALREADY_ENDED = -15, // sale has already ended
	ORDER_EXCEEDS_HARD_CAP = -16, // currentcap + order will exceed hard cap
	CANNOT_PARTICIPATE_OWN_SALE = -17, // it's not allowed to participate in own sale
	ASSET_MISMATCHED = -18, // sale assets does not match assets for specified balances
	PRICE_MISMATCHED = -19, // price does not match sale price
	INVALID_PRICE = -20, // price must be positive
	OFFER_UPDATE_IS_NOT_ALLOWED = -21, // update of the offer is not allowed
	INVALID_AMOUNT = -22, // amount must be positive 
	SALE_IS_NOT_ACTIVE = -23,
	REQUIRES_KYC = -24 // source must have KYC in order to participate
};

enum ManageOfferEffect
{
    CREATED = 0,
    UPDATED = 1,
    DELETED = 2
};

/* This result is used when offers are taken during an operation */
struct ClaimOfferAtom
{
    // emitted to identify the offer
    AccountID bAccountID; // Account that owns the offer
    uint64 offerID;
	int64 baseAmount;
	int64 quoteAmount;
	int64 bFeePaid;
	int64 aFeePaid;
	BalanceID baseBalance;
	BalanceID quoteBalance;

	int64 currentPrice;

	union switch (LedgerVersion v)
    {
    case EMPTY_VERSION:
        void;
    }
    ext;
};

struct OfferTotalAmount {
    int64 baseAmount;
	int64 quoteAmount;

	union switch (LedgerVersion v)
    {
    case EMPTY_VERSION:
        void;
    }
    ext;
};

struct ManageOfferSuccessResult
{
    // offers that got claimed while creating this offer
    ClaimOfferAtom offersClaimed<>;
	AssetCode baseAsset;
	AssetCode quoteAsset;

    union switch (ManageOfferEffect effect)
    {
    case CREATED:
    case UPDATED:
        OfferEntry offer;
    case DELETED:
        OfferTotalAmount totalAmount;
    default:
        void;
    }
    offer;

	union switch (LedgerVersion v)
    {
    case EMPTY_VERSION:
        void;
    }
    ext;
};

union ManageOfferResult switch (ManageOfferResultCode code)
{
case SUCCESS:
    ManageOfferSuccessResult success;
case PHYSICAL_PRICE_RESTRICTION:
	struct {
		int64 physicalPrice;
		union switch (LedgerVersion v)
		{
		case EMPTY_VERSION:
			void;
		}
		ext;
	} physicalPriceRestriction;
case CURRENT_PRICE_RESTRICTION:
	struct {
		int64 currentPrice;
		union switch (LedgerVersion v)
		{
		case EMPTY_VERSION:
			void;
		}
		ext;
	} currentPriceRestriction;

default:
    void;
};

}
