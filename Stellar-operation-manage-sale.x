// Copyright 2015 Stellar Development Foundation and contributors. Licensed
// under the Apache License, Version 2.0. See the COPYING file at the root
// of this distribution or at http://www.apache.org/licenses/LICENSE-2.0

%#include "xdr/Stellar-types.h"

namespace stellar
{

enum ManageSaleAction
{
    BLOCK = 1,      //  block sale with a given sale id
    UNBLOCK = 2,    //  unblock sale
    DELETE = 3      //  delete sale
};


/* Can block, unblock or delete sale

Result: ManageSaleResult

*/

struct ManageSaleOp
{
    uint64 saleID;
    ManageSaleAction action;

    // reserved for future use
    union switch (LedgerVersion v)
    {
    case EMPTY_VERSION:
        void;
    }
    ext;
};


enum ManageSaleResultCode
{
    SUCCESS = 0,

    NOT_FOUND = -1, // sale not found
    ALREADY_BLOCKED = -2, // when we try to block blocked sale
    ALREADY_UNBLOCKED = -3 // when we try to unblock active sale
};

struct ManageSaleResultSuccess
{

    //reserved for future use
    union switch (LedgerVersion v)
    {
    case EMPTY_VERSION:
        void;
    }
    ext;
};

union ManageSaleResult switch (ManageSaleResultCode code)
{
case SUCCESS:
    ManageSaleResultSuccess success;
default:
    void;
};

}