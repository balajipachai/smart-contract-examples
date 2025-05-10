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
# Step 1: Deploy the LockReleaseTokenPool
deploy-custom-lock-release-token-pool:
	forge script ./script/DeployCustomLockReleaseTokenPool.s.sol --broadcast --slow --optimize --optimizer-runs 999999 --verify --rpc-url ${RPC_URL} --private-key ${PRIVATE_KEY} --etherscan-api-key ${ETHERSCAN_API_KEY}

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
grant-approval:
	cast send ${TOKEN_ADDRESS} "approve(address,uint256)" ${SHIBASWAP_ADDRESS} ${TOKEN_AMOUNT} --rpc-url ${RPC_URL} --private-key ${PRIVATE_KEY}

# Exclude CCIPConnector from TAX on ChildChains
exclude-from-tax:
	cast send ${TOKEN_ADDRESS} "excludeFromTax(address)" ${CCIP_CONNECTOR_ADDRESS} --rpc-url ${RPC_URL} --private-key ${PRIVATE_KEY}
