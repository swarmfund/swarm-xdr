%#include "xdr/Stellar-ledger-entries.h"

namespace stellar
{

/* PaymentV2

    Send an amount in specified asset to a destination account.

    Threshold: med

    Result: PaymentResult
*/

struct FeeDataV2 {
    uint64 paymentFee;
    uint64 fixedFee;
	// reserved for future use
    union switch (LedgerVersion v)
    {
    case EMPTY_VERSION:
        void;
    }
    ext;
};

struct PaymentFeeDataV2 {
    FeeDataV2 sourceFee;
    FeeDataV2 destinationFee;
    bool sourcePaysForDest; // if true - source account pays fee, else destination

    // Cross asset fees
    AssetCode feeAsset;

    union switch (LedgerVersion v)
    {
    case EMPTY_VERSION:
        void;
    }
    ext;
};

enum PaymentDestinationType {
    ACCOUNT = 0,
    BALANCE = 1
};

struct PaymentOpV2
{
    BalanceID sourceBalanceID;

    union switch (PaymentDestinationType type) {
        case ACCOUNT:
            AccountID accountID;
        case BALANCE:
            BalanceID balanceID;
    } destination;

    uint64 amount;

    PaymentFeeDataV2 feeData;

    string256 subject;
    string64 reference;

    // reserved for future use
    union switch (LedgerVersion v)
    {
    case EMPTY_VERSION:
        void;
    }
    ext;
};

enum PaymentV2ResultCode
{
    // codes considered as "success" for the operation
    SUCCESS = 0, // payment successfully completed

    // codes considered as "failure" for the operation
    MALFORMED = -1,       // bad input
    UNDERFUNDED = -2,     // not enough funds in source account
    LINE_FULL = -3,       // destination would go above their limit
	FEE_MISMATCHED = -4,   // fee is not equal to expected fee
	DESTINATION_BALANCE_NOT_FOUND = -5,
    BALANCE_ACCOUNT_MISMATCHED = -6,
    BALANCE_ASSETS_MISMATCHED = -7,
	SRC_BALANCE_NOT_FOUND = -8, // source balance not found
    REFERENCE_DUPLICATION = -9,
    STATS_OVERFLOW = -10,
    LIMITS_EXCEEDED = -11,
    NOT_ALLOWED_BY_ASSET_POLICY = -12
};

struct PaymentV2Response {
    AccountID destination;
    uint64 paymentID;
    AssetCode asset;
    // reserved for future use
    union switch (LedgerVersion v)
    {
    case EMPTY_VERSION:
        void;
    }
    ext;
};

union PaymentV2Result switch (PaymentV2ResultCode code)
{
case SUCCESS:
    PaymentV2Response paymentV2Response;
default:
    void;
};

}