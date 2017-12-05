// Copyright 2015 Stellar Development Foundation and contributors. Licensed
// under the Apache License, Version 2.0. See the COPYING file at the root
// of this distribution or at http://www.apache.org/licenses/LICENSE-2.0

%#include "xdr/Stellar-types.h"

namespace stellar
{

enum AssetPolicy
{
	TRANSFERABLE = 1,
	BASE_ASSET = 2,
	STATS_QUOTE_ASSET = 4
};



struct AssetEntry
{
    AssetCode code;
	AccountID owner;
    string64 name;
	AccountID preissuedAssetSigner;
	longstring description;
	string256 externalResourceLink;
	uint64 maxIssuanceAmount;
	uint64 availableForIssueance;
	uint64 issued;
    uint32 policies;

    // reserved for future use
    union switch (LedgerVersion v)
    {
    case EMPTY_VERSION:
        void;
    }
    ext;
};

}
