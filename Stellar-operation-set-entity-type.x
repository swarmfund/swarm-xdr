// Copyright 2015 Stellar Development Foundation and contributors. Licensed
// under the Apache License, Version 2.0. See the COPYING file at the root
// of this distribution or at http://www.apache.org/licenses/LICENSE-2.0

%#include "xdr/Stellar-ledger-entries.h"
%#include "xdr/Stellar-ledger-entries-entity-type.h"

namespace stellar
{
/* SetEntityTypeOp

 Creates, updates or deletes entity type

 Threshold: med

 Result: SetFeesEmissionRequestResult
 */
struct SetEntityTypeOp
{
    EntityTypeEntry entityType;
	bool isDelete;
	// reserved for future use
	union switch (LedgerVersion v)
	{
	case EMPTY_VERSION:
		void;
	}
	ext;
};

/******* SetFeesEmissionRequest Result ********/

enum SetEntityTypeResultCode
{
    // codes considered as "success" for the operation
    SUCCESS = 0,

    // codes considered as "failure" for the operation
    INVALID_TYPE = -1,      // type is not included in the types enum
    INVALID_NAME = -2,
    MALFORMED = -3,
	NOT_FOUND = -4
};

union SetEntityTypeResult switch (SetEntityTypeResultCode code)
{
    case SUCCESS:
        struct {
			// reserved for future use
			union switch (LedgerVersion v)
			{
			case EMPTY_VERSION:
				void;
			}
			ext;
		} success;
    default:
        void;
};

}
