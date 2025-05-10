-include .env

.PHONY: build test clean deploy

install: init

build:
	forge build

rebuild:
	clean build

init:
	nvm use 18
	git submodule update --init --recursive
	forge install
	npm install

deploy-lock-release-token-pool:
	forge script ./script/DeployLockReleaseTokenPool.s.sol --broadcast --slow --optimize --optimizer-runs 999999 --verify --rpc-url ${RPC_URL} --private-key ${PRIVATE_KEY} --etherscan-api-key ${ETHERSCAN_API_KEY}
# This will be deployed on Ethereum Mainnet
# Step 1: Deploy the LockReleaseTokenPoolV1
deploy-custom-lock-release-token-pool-v1:
	forge script ./script/DeployCustomLockReleaseTokenPoolV1.s.sol --broadcast --slow --optimize --optimizer-runs 999999 --verify --rpc-url ${RPC_URL} --private-key ${PRIVATE_KEY} --etherscan-api-key ${ETHERSCAN_API_KEY}

# This will be deployed on Ethereum Mainnet
# Step 1: Deploy the CustomLockReleaseTokenPoolV2
deploy-custom-lock-release-token-pool-v2:
	forge script ./script/DeployCustomLockReleaseTokenPoolV2.s.sol --broadcast --slow --optimize --optimizer-runs 999999 --verify --rpc-url ${RPC_URL} --private-key ${PRIVATE_KEY} --etherscan-api-key ${ETHERSCAN_API_KEY}

deploy-burn-mint-token-pool:
	forge script ./script/DeployBurnMintTokenPool.s.sol --broadcast --slow --optimize --optimizer-runs 999999 --verify --rpc-url ${RPC_URL} --private-key ${PRIVATE_KEY} --etherscan-api-key ${ETHERSCAN_API_KEY}

# This will be deployed on Shibarium
# Step 1: Deploy the BurnMintTokenPool
deploy-custom-burn-mint-token-pool:
	forge script ./script/DeployCustomBurnMintTokenPool.s.sol --broadcast --slow --optimize --optimizer-runs 999999 --rpc-url ${RPC_URL} --private-key ${PRIVATE_KEY}

# Step 2: Claim the admin role
claim-admin-role:
	forge script script/ClaimAdmin.s.sol --rpc-url ${RPC_URL} --private-key ${PRIVATE_KEY} --broadcast

# Step 3: Accept the admin role
accept-admin-role:
	forge script script/AcceptAdminRole.s.sol --rpc-url ${RPC_URL} --private-key ${PRIVATE_KEY} --broadcast

# Step 4: Set the token pool
set-token-pool:
	forge script script/SetPool.s.sol --rpc-url ${RPC_URL} --private-key ${PRIVATE_KEY} --broadcast

# Step 5: Configure the token pool
configure-token-pool:
	forge script script/ApplyChainUpdates.s.sol --rpc-url ${RPC_URL} --private-key ${PRIVATE_KEY} --broadcast


# Grant Approval
grant-approval-shibaswap:
	cast send ${TOKEN_ADDRESS} "approve(address,uint256)" ${SHIBASWAP_ADDRESS} ${TOKEN_AMOUNT} --rpc-url ${RPC_URL} --private-key ${PRIVATE_KEY}

# Grant Approval to Token Pool is required since after locking the tokens, the token pool will deposit the tokens in the predicate contract
# This is required only on Ethereum Mainnet
grant-approval-tokenpool:
	cast send ${TOKEN_ADDRESS} "approve(address,uint256)" ${TOKEN_POOL_ADDRESS} ${TOKEN_AMOUNT} --rpc-url ${RPC_URL} --private-key ${PRIVATE_KEY}

# Grant Approval to CCIPConnector is required since after locking the tokens, since, the tokens will be first pulled into CCIPConnector
#grant-approval-ccipconnector:
#	cast send ${TOKEN_ADDRESS} "approve(address,uint256)" ${CCIP_CONNECTOR_ADDRESS} ${TOKEN_AMOUNT} --rpc-url $# #{RPC_URL} --private-key ${PRIVATE_KEY}


# Grant Manager Role to Token Pool is required since after locking the tokens, the token pool will deposit the tokens in the predicate contract
# This is required only on Ethereum Mainnet
grant-manager-role-tokenpool:
	cast send ${PREDICATE_CONTRACT} "grantRole(bytes32,address)" ${MANAGER_ROLE} ${TOKEN_POOL_ADDRESS} --rpc-url ${RPC_URL} --private-key ${PRIVATE_KEY}

# Grant Approval to CCIPConnector is required since after locking the tokens, the token pool will deposit the tokens in the predicate contract
# This is required only on Ethereum Mainnet
#approve-ccipconnector-predicate:
#	cast send ${CCIP_CONNECTOR_ADDRESS} "approveToken(address,address,uint256)" ${TOKEN_ADDRESS} ${PREDICATE_CONTRACT} ${TOKEN_AMOUNT} --rpc-url ${RPC_URL} --private-key ${PRIVATE_KEY}

# Exclude CCIPConnector from TAX on ChildChains
# This is required only on ChildChains
exclude-from-tax:
	cast send ${TOKEN_ADDRESS} "excludeFromTax(address)" ${CCIP_CONNECTOR_ADDRESS} --rpc-url ${RPC_URL} --private-key ${PRIVATE_KEY}
